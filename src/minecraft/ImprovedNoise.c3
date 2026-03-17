module minecraft::noise;
import minecraft::random;
import std;

alias Byte = char;

const int[3][16] GRADIENT = {
    {1, 1, 0}, {-1, 1, 0}, {1, -1, 0}, {-1, -1, 0},
    {1, 0, 1}, {-1, 0, 1}, {1, 0, -1}, {-1, 0, -1},
    {0, 1, 1}, {0, -1, 1}, {0, 1, -1}, {0, -1, -1},
    {1, 1, 0}, {0, -1, 1}, {-1, 1, 0}, {0, -1, -1}
};

fn int fastFloor(double x) @inline {
    int i = (int)x;
    return x < (double)i ? i - 1 : i;
}

fn double smoothstep(double d) @inline {
    return d * d * d * (d * (d * 6.0 - 15.0) + 10.0);
}

fn double smoothstepDerivative(double d) @inline {
    return 30.0 * d * d * (d - 1.0) * (d - 1.0);
}

fn double lerp(double t, double a, double b) @inline {
    return a + t * (b - a);
}

fn double lerp2(double t, double t2, double a, double b, double c, double d) @inline {
    return lerp(t2, lerp(t, a, b), lerp(t, c, d));
}

fn double lerp3(double t, double t2, double t3, double a, double b, double c, double d, double e, double f, double g, double h) @inline {
    return lerp(t3, lerp2(t, t2, a, b, c, d), lerp2(t, t2, e, f, g, h));
}

fn double dot(int* grad, double x, double y, double z) @inline {
    return (double)grad[0] * x + (double)grad[1] * y + (double)grad[2] * z;
}

struct ImprovedNoise {
    Byte[256] p;
    double xo;
    double yo;
    double zo;
}

fn int ImprovedNoise.getP(ImprovedNoise* self, int i) @inline {
    return (int)self.p[i & 0xFF];
}

fn double gradDot(int i, double x, double y, double z) @inline {
    return dot(&GRADIENT[i & 0xF], x, y, z);
}

fn double ImprovedNoise.sampleAndLerp(ImprovedNoise* self, int i, int j, int k, double d, double e, double f, double g) {
    int l = self.getP(i);
    int m = self.getP(i + 1);
    int n = self.getP(l + j);
    int o = self.getP(l + j + 1);
    int p = self.getP(m + j);
    int q = self.getP(m + j + 1);

    double h = gradDot(self.getP(n + k), d, e, f);
    double r = gradDot(self.getP(p + k), d - 1.0, e, f);
    double s = gradDot(self.getP(o + k), d, e - 1.0, f);
    double t = gradDot(self.getP(q + k), d - 1.0, e - 1.0, f);
    double u = gradDot(self.getP(n + k + 1), d, e, f - 1.0);
    double v = gradDot(self.getP(p + k + 1), d - 1.0, e, f - 1.0);
    double w = gradDot(self.getP(o + k + 1), d, e - 1.0, f - 1.0);
    double x = gradDot(self.getP(q + k + 1), d - 1.0, e - 1.0, f - 1.0);

    double y = smoothstep(d);
    double z = smoothstep(g);
    double aa = smoothstep(f);

    return lerp3(y, z, aa, h, r, s, t, u, v, w, x);
}

fn double ImprovedNoise.noise(ImprovedNoise* self, double x, double y, double z) {
    double i = x + self.xo;
    double j = y + self.yo;
    double k = z + self.zo;

    int l = fastFloor(i);
    int m = fastFloor(j);
    int n = fastFloor(k);

    double o = i - (double)l;
    double p = j - (double)m;
    double q = k - (double)n;

    return self.sampleAndLerp(l, m, n, o, p, q, p);
}

fn double ImprovedNoise.sampleWithDerivative(ImprovedNoise* self, int i, int j, int k, double d, double e, double f, double* ds) {
    int l = self.getP(i);
    int m = self.getP(i + 1);
    int n = self.getP(l + j);
    int o = self.getP(l + j + 1);
    int p = self.getP(m + j);
    int q = self.getP(m + j + 1);

    int r = self.getP(n + k);
    int s = self.getP(p + k);
    int t = self.getP(o + k);
    int u = self.getP(q + k);
    int v = self.getP(n + k + 1);
    int w = self.getP(p + k + 1);
    int x = self.getP(o + k + 1);
    int y_idx = self.getP(q + k + 1); // _idx чтобы избежать конфликта с 'y' параметрами

    int* is_grad = &GRADIENT[r & 0xF];
    int* js_grad = &GRADIENT[s & 0xF];
    int* ks_grad = &GRADIENT[t & 0xF];
    int* ls_grad = &GRADIENT[u & 0xF];
    int* ms_grad = &GRADIENT[v & 0xF];
    int* ns_grad = &GRADIENT[w & 0xF];
    int* os_grad = &GRADIENT[x & 0xF];
    int* ps_grad = &GRADIENT[y_idx & 0xF];

    double g = dot(is_grad, d, e, f);
    double h = dot(js_grad, d - 1.0, e, f);
    double z = dot(ks_grad, d, e - 1.0, f);
    double aa = dot(ls_grad, d - 1.0, e - 1.0, f);
    double ab = dot(ms_grad, d, e, f - 1.0);
    double ac = dot(ns_grad, d - 1.0, e, f - 1.0);
    double ad = dot(os_grad, d, e - 1.0, f - 1.0);
    double ae = dot(ps_grad, d - 1.0, e - 1.0, f - 1.0);

    double af = smoothstep(d);
    double ag = smoothstep(e);
    double ah = smoothstep(f);

    double ai = lerp3(af, ag, ah, (double)is_grad[0], (double)js_grad[0], (double)ks_grad[0], (double)ls_grad[0], (double)ms_grad[0], (double)ns_grad[0], (double)os_grad[0], (double)ps_grad[0]);
    double aj = lerp3(af, ag, ah, (double)is_grad[1], (double)js_grad[1], (double)ks_grad[1], (double)ls_grad[1], (double)ms_grad[1], (double)ns_grad[1], (double)os_grad[1], (double)ps_grad[1]);
    double ak = lerp3(af, ag, ah, (double)is_grad[2], (double)js_grad[2], (double)ks_grad[2], (double)ls_grad[2], (double)ms_grad[2], (double)ns_grad[2], (double)os_grad[2], (double)ps_grad[2]);

    double al = lerp2(ag, ah, h - g, aa - z, ac - ab, ae - ad);
    double am = lerp2(ah, af, z - g, ad - ab, aa - h, ae - ac);
    double an = lerp2(af, ag, ab - g, ac - h, ad - z, ae - aa);

	double ao = smoothstepDerivative(d);	
    double ap = smoothstepDerivative(e);
    double aq = smoothstepDerivative(f);

	ds[0] += ai + ao * al;
    ds[1] += aj + ap * am;
    ds[2] += ak + aq * an;

    return lerp3(af, ag, ah, g, h, z, aa, ab, ac, ad, ae);
}

fn double ImprovedNoise.noiseWithDerivative(ImprovedNoise* self, double x, double y, double z, double* ds) {
    double g = x + self.xo;
    double h = y + self.yo;
    double i = z + self.zo;

    int j = fastFloor(g);
    int k = fastFloor(h);
    int l = fastFloor(i);

    double m = g - (double)j;
    double n = h - (double)k;
    double o = i - (double)l;

    return self.sampleWithDerivative(j, k, l, m, n, o, ds);
}

fn void ImprovedNoise.init(ImprovedNoise* self, random::RandomSource seed) {
	self.xo = seed.nextDouble() * 256.0;
	self.yo = seed.nextDouble() * 256.0;
	self.zo = seed.nextDouble() * 256.0;

	for (int i = 0; i < 256; i++) {
		self.p[i] = (Byte)i;
	}

	for (int i = 255; i > 0; i--) {
		int j = (int)(seed.nextDouble() * (double)(i + 1)); 
		
		Byte temp = self.p[i];
		self.p[i] = self.p[j];
		self.p[j] = temp;
	}
}

fn long createImprovedNoisePtr(random::RandomSource randomSource) {
	ImprovedNoise* noise = mem::alloc(ImprovedNoise);
	noise.init(randomSource);
	return (long)noise;
}

<*
    @require ptr != 0
*>
fn ImprovedNoise* getImprovedNoiseFromPtr(long ptr) {
	return (ImprovedNoise*)ptr;
}

<*
    @require ptr != 0
*>
fn void freeImprovedNoisePtr(long ptr) {
	mem::free((ImprovedNoise*)ptr);
}