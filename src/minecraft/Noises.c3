module minecraft::noise;
import minecraft::random;
import std;
import std::io;

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
    return (int) (char)self.p[i & 0xFF];
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

fn double ImprovedNoise.noise(ImprovedNoise* self, double x, double y, double z, double g = 0, double h = 0) {
    double i = x + self.xo;
    double j = y + self.yo;
    double k = z + self.zo;

    int l = fastFloor(i);
    int m = fastFloor(j);
    int n = fastFloor(k);

    double o = i - (double)l;
    double p = j - (double)m;
    double q = k - (double)n;


	double s = 0;
	if (g != 0.0) {
		double r = h >= 0.0 && h < p ? h : p;
		s = (double)math::floor(r / g + 1.0E-7) * g;
	}

    return self.sampleAndLerp(l, m, n, o, p - s, q, p);
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

    for (int i = 0; i < 256; i++) {
        int j = seed.nextInt(256 - i); 
        
        Byte b = self.p[i];
        self.p[i] = self.p[i + j];
        self.p[i + j] = b;
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

//////////////////////////////////////////
////	PERLINE NOISE				  ////
//////////////////////////////////////////

const int ROUND_OFF = 0x2000000;

struct PerlinNoise {
	ImprovedNoise*[] noiseLevels;
	double[] amplitudes;
	int firstOctave;
	double lowestFreqValueFactor;
	double lowestFreqInputFactor;
	double maxValue;
}

fn double wrap(double d) {
    return d - (double)math::floor(d / 3.3554432E7 + 0.5) * 3.3554432E7;
}

fn void skipOctave(random::RandomSource randomSource) {
    randomSource.consumeCount(262);
}

fn double PerlinNoise.edgeValue(PerlinNoise* self, double d) {
    double e = 0.0;
    double f = self.lowestFreqValueFactor;
    
    for (int i = 0; i < self.noiseLevels.len; i++) {
        ImprovedNoise* improvedNoise = self.noiseLevels[i];
        if (improvedNoise != null) {
            e += self.amplitudes[i] * d * f;
        }
        f /= 2.0;
    }
    return e;
}

fn double PerlinNoise.maxBrokenValue(PerlinNoise* self, double d) {
    return self.edgeValue(d + 2.0);
}

fn double PerlinNoise.getValue(PerlinNoise* self, double d, double e, double f) {
    return self.getValueFull(d, e, f, 0.0, 0.0, false);
}

fn double PerlinNoise.getValueFull(PerlinNoise* self, double d, double e, double f, double g, double h, bool use_yo) {
    double i = 0.0;
    double j = self.lowestFreqInputFactor;
    double k = self.lowestFreqValueFactor;
    
    for (int l = 0; l < self.noiseLevels.len; l++) {
        ImprovedNoise* improvedNoise = self.noiseLevels[l];
        if (improvedNoise != null) {
            double wrap_d = wrap(d * j);
            double wrap_e = use_yo ? -improvedNoise.yo :wrap(e * j);
            double wrap_f = wrap(f * j);
            double m = improvedNoise.noise(wrap_d, wrap_e, wrap_f, g * j, h * j); 
            
            i += self.amplitudes[l] * m * k;
        }
        j *= 2.0;
        k /= 2.0;
    }
    return i;
}

fn void PerlinNoise.init(PerlinNoise* self, random::RandomSource randomSource, int firstOctave, double[] amplitudes, bool usePositional = true) {
    self.firstOctave = firstOctave;
    
    self.amplitudes = mem::new_array(double, amplitudes.len);
    mem::copy(self.amplitudes.ptr, amplitudes.ptr, amplitudes.len * double.sizeof);
    
    int len = self.amplitudes.len;
    int j = -self.firstOctave;
    
    self.noiseLevels = mem::new_array(ImprovedNoise*, len);
    
    if (usePositional) {
        random::PositionalRandomFactory factory = randomSource.forkPositional();
        
        for (int k = 0; k < len; k++) {
            if (self.amplitudes[k] == 0.0) {
                self.noiseLevels[k] = null;
                continue;
            }
            
            int l = self.firstOctave + k;
            
            char[32] buffer;

            char[] hashNameSlice = io::bprintf(&buffer, "octave_%d", l)!!;
            
            random::RandomSource octaveRandom = factory.fromHashOf((String)hashNameSlice);
            
            ImprovedNoise* newNoise = mem::alloc(ImprovedNoise);
            newNoise.init(octaveRandom);
            self.noiseLevels[k] = newNoise;
            
			mem::free(octaveRandom.ptr); 
        }
        
    } else {
        ImprovedNoise* baseNoise = mem::alloc(ImprovedNoise);
        baseNoise.init(randomSource);
        
        if (j >= 0 && j < len && self.amplitudes[j] != 0.0) {
            self.noiseLevels[j] = baseNoise;
        } else {
            mem::free(baseNoise); 
        }
        
        for (int k = j - 1; k >= 0; k--) {
            if (k < len) {
                double e = self.amplitudes[k];
                if (e != 0.0) {
                    ImprovedNoise* newNoise = mem::alloc(ImprovedNoise);
                    newNoise.init(randomSource);
                    self.noiseLevels[k] = newNoise;
                } else {
                    skipOctave(randomSource);
                }
            } else {
                skipOctave(randomSource);
            }
        }
    }
    
    self.lowestFreqInputFactor = math::pow(2.0, (double)-j);
    self.lowestFreqValueFactor = math::pow(2.0, (double)(len - 1)) / (math::pow(2.0, (double)len) - 1.0);
    self.maxValue = self.edgeValue(2.0);
}

fn void PerlinNoise.free(PerlinNoise* self) {
    for (int i = 0; i < self.noiseLevels.len; i++) {
        if (self.noiseLevels[i] != null) {
            mem::free(self.noiseLevels[i]);
        }
    }
    mem::free(self.noiseLevels.ptr);
    mem::free(self.amplitudes.ptr);
}

struct AmplitudesData {
    int firstOctave;
    double[] amplitudes;
}

 fn AmplitudesData makeAmplitudes(int[] octaves) {
	int min_oct = octaves[0];
    int max_oct = octaves[0];
    for (int i = 1; i < octaves.len; i++) {
        if (octaves[i] < min_oct) min_oct = octaves[i];
        if (octaves[i] > max_oct) max_oct = octaves[i];
    }

    int k = max_oct - min_oct + 1;
    
    double[] amps = mem::new_array(double, k);
    mem::clear(amps.ptr, amps.len * double.sizeof);
    
    for (int idx = 0; idx < octaves.len; idx++) {
        int l = octaves[idx];
        amps[l - min_oct] = 1.0; 
    }
    
    AmplitudesData res;
    res.firstOctave = min_oct;
    res.amplitudes = amps;
    
    return res;
 }

 fn PerlinNoise* createLegacyForBlendedNoise(random::RandomSource randomSource, int min_octave, int max_octave) {
    int len = max_octave - min_octave + 1;
    int[] octaves = mem::new_array(int, len);
    for (int i = 0; i < len; i++) {
        octaves[i] = min_octave + i;
    }
    
    AmplitudesData data = makeAmplitudes(octaves);
    
    PerlinNoise* noise = mem::alloc(PerlinNoise);
    noise.init(randomSource, data.firstOctave, data.amplitudes, false);
    
    mem::free(octaves.ptr);
    mem::free(data.amplitudes.ptr);
    
    return noise;
}

fn PerlinNoise* createLegacyForLegacyNetherBiome(random::RandomSource randomSource, int firstOctave, double[] amplitudes) {
    PerlinNoise* noise = mem::alloc(PerlinNoise);
    noise.init(randomSource, firstOctave, amplitudes, false);
    return noise;
}

fn PerlinNoise* createFromRange(random::RandomSource randomSource, int min_octave, int max_octave) {
    int len = max_octave - min_octave + 1;
    int[] octaves = mem::new_array(int, len);
    for (int i = 0; i < len; i++) {
        octaves[i] = min_octave + i;
    }
    
    AmplitudesData data = makeAmplitudes(octaves);
    
    PerlinNoise* noise = mem::alloc(PerlinNoise);
    noise.init(randomSource, data.firstOctave, data.amplitudes, true);
    
    mem::free(octaves.ptr);
    mem::free(data.amplitudes.ptr);
    
    return noise;
}

fn PerlinNoise* createFromOctavesList(random::RandomSource randomSource, int[] octaves) {
    AmplitudesData data = makeAmplitudes(octaves);
    PerlinNoise* noise = mem::alloc(PerlinNoise);
    noise.init(randomSource, data.firstOctave, data.amplitudes, true);
    mem::free(data.amplitudes.ptr);
    return noise;
}

fn PerlinNoise* createFromAmplitudes(random::RandomSource randomSource, int firstOctave, double[] amplitudes) {
    PerlinNoise* noise = mem::alloc(PerlinNoise);
    noise.init(randomSource, firstOctave, amplitudes, true);
    return noise;
}