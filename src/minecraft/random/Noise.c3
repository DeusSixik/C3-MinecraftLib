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

const double[64] FLAT_SIMPLEX_GRAD = {
    1.0, 1.0, 0.0, 0.0, -1.0, 1.0, 0.0, 0.0, 1.0, -1.0, 0.0, 0.0, -1.0, -1.0, 0.0, 0.0,
    1.0, 0.0, 1.0, 0.0, -1.0, 0.0, 1.0, 0.0, 1.0, 0.0, -1.0, 0.0, -1.0, 0.0, -1.0, 0.0,
    0.0, 1.0, 1.0, 0.0, 0.0, -1.0, 1.0, 0.0, 0.0, 1.0, -1.0, 0.0, 0.0, -1.0, -1.0, 0.0,
    1.0, 1.0, 0.0, 0.0, 0.0, -1.0, 1.0, 0.0, -1.0, 1.0, 0.0, 0.0, 0.0, -1.0, -1.0, 0.0,
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

fn double lerp2(double d, double e, double f, double g, double h, double i) @inline {
    return lerp(e, lerp(d, f, g), lerp(d, h, i));
}

fn double lerp3(double d, double e, double f, double g, double h, double i, double j, double k, double l, double m, double n) @inline {
    return lerp(f, lerp2(d, e, g, h, i, j), lerp2(d, e, k, l, m, n));
}

fn double dot(int* grad, double x, double y, double z) @inline {
    return (double)grad[0] * x + (double)grad[1] * y + (double)grad[2] * z;
}

struct ImprovedNoise {
    Byte[512] p;
    double xo;
    double yo;
    double zo;
}

fn int ImprovedNoise.getP(ImprovedNoise* self, int i) @inline {
    return ((int)self.p[i & 0xFF]) & 0xFF;
}

fn double gradDot(int i, double x, double y, double z) @inline {
    return dot(&GRADIENT[i & 0xF], x, y, z);
}

fn double ImprovedNoise.sampleAndLerp(ImprovedNoise* self, int gridX, int gridY, int gridZ, double x, double wy, double z, double y) @inline {
    Byte* p = &self.p;

    int x_idx = gridX & 0xFF;
    int y_idx = gridY & 0xFF;
    int z_idx = gridZ & 0xFF;

    int hash_a  = (int)p[x_idx] + y_idx;
    int hash_b  = (int)p[x_idx + 1] + y_idx;

    int hash_aa = (int)p[hash_a] + z_idx;
    int hash_ab = (int)p[hash_a + 1] + z_idx;
    int hash_ba = (int)p[hash_b] + z_idx;
    int hash_bb = (int)p[hash_b + 1] + z_idx;

    int gi000 = ((int)p[hash_aa] & 15) << 2;
    int gi001 = ((int)p[hash_aa + 1] & 15) << 2;
    int gi010 = ((int)p[hash_ab] & 15) << 2;
    int gi011 = ((int)p[hash_ab + 1] & 15) << 2;
    int gi100 = ((int)p[hash_ba] & 15) << 2;
    int gi101 = ((int)p[hash_ba + 1] & 15) << 2;
    int gi110 = ((int)p[hash_bb] & 15) << 2;
    int gi111 = ((int)p[hash_bb + 1] & 15) << 2;

    double x1 = x - 1.0;
    double wy1 = wy - 1.0;
    double z1 = z - 1.0;

    double n000 = FLAT_SIMPLEX_GRAD[gi000] * x + FLAT_SIMPLEX_GRAD[gi000 | 1] * wy + FLAT_SIMPLEX_GRAD[gi000 | 2] * z;
    double n100 = FLAT_SIMPLEX_GRAD[gi100] * x1 + FLAT_SIMPLEX_GRAD[gi100 | 1] * wy + FLAT_SIMPLEX_GRAD[gi100 | 2] * z;
    double n010 = FLAT_SIMPLEX_GRAD[gi010] * x + FLAT_SIMPLEX_GRAD[gi010 | 1] * wy1 + FLAT_SIMPLEX_GRAD[gi010 | 2] * z;
    double n110 = FLAT_SIMPLEX_GRAD[gi110] * x1 + FLAT_SIMPLEX_GRAD[gi110 | 1] * wy1 + FLAT_SIMPLEX_GRAD[gi110 | 2] * z;
    double n001 = FLAT_SIMPLEX_GRAD[gi001] * x + FLAT_SIMPLEX_GRAD[gi001 | 1] * wy + FLAT_SIMPLEX_GRAD[gi001 | 2] * z1;
    double n101 = FLAT_SIMPLEX_GRAD[gi101] * x1 + FLAT_SIMPLEX_GRAD[gi101 | 1] * wy + FLAT_SIMPLEX_GRAD[gi101 | 2] * z1;
    double n011 = FLAT_SIMPLEX_GRAD[gi011] * x + FLAT_SIMPLEX_GRAD[gi011 | 1] * wy1 + FLAT_SIMPLEX_GRAD[gi011 | 2] * z1;
    double n111 = FLAT_SIMPLEX_GRAD[gi111] * x1 + FLAT_SIMPLEX_GRAD[gi111 | 1] * wy1 + FLAT_SIMPLEX_GRAD[gi111 | 2] * z1;

    double u = x * x * x * (10.0 + x * (x * 6.0 - 15.0));
    double v = y * y * y * (10.0 + y * (y * 6.0 - 15.0));
    double w = z * z * z * (10.0 + z * (z * 6.0 - 15.0));

    double lerpX1 = n000 + u * (n100 - n000);
    double lerpX2 = n010 + u * (n110 - n010);
    double lerpX3 = n001 + u * (n101 - n001);
    double lerpX4 = n011 + u * (n111 - n011);

    double lerpY1 = lerpX1 + v * (lerpX2 - lerpX1);
    double lerpY2 = lerpX3 + v * (lerpX4 - lerpX3);

    return lerpY1 + w * (lerpY2 - lerpY1);
}

fn double ImprovedNoise.noise(ImprovedNoise* self, double x, double y, double z, double yScale = 0.0, double yMax = 0.0) @inline {
    double inputX = x + self.xo;
    double inputY = y + self.yo;
    double inputZ = z + self.zo;

    int gridX = (int)inputX;
    if (inputX < (double)gridX) gridX--;

    int gridY = (int)inputY;
    if (inputY < (double)gridY) gridY--;

    int gridZ = (int)inputZ;
    if (inputZ < (double)gridZ) gridZ--;

    double deltaX = inputX - (double)gridX;
    double deltaY = inputY - (double)gridY;
    double deltaZ = inputZ - (double)gridZ;

    double weirdDeltaY;
    if (yScale != 0.0) {
        double range = (yMax >= 0.0 && yMax < deltaY) ? yMax : deltaY;
        double scaled = range / yScale + 1.0E-7;
        
        int scaledFloor = (int)scaled;
        if (scaled < (double)scaledFloor) scaledFloor--;

        weirdDeltaY = deltaY - ((double)scaledFloor * yScale);
    } else {
        weirdDeltaY = deltaY;
    }

    return self.sampleAndLerp(gridX, gridY, gridZ, deltaX, weirdDeltaY, deltaZ, deltaY);
}

fn double ImprovedNoise.sampleWithDerivative(ImprovedNoise* self, int i, int j, int k, double d, double e, double f, double* ds) @inline {
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

fn double ImprovedNoise.noiseWithDerivative(ImprovedNoise* self, double x, double y, double z, double* ds) @inline {
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

fn double[<4>] ImprovedNoise.noise4Z(ImprovedNoise* self, double x, double y, double[<4>] z, double yScale = 0.0, double yMax = 0.0) {
    double inputX = x + self.xo;
    double inputY = y + self.yo;
    
    int gridX = (int)inputX; if (inputX < (double)gridX) gridX--;
    int gridY = (int)inputY; if (inputY < (double)gridY) gridY--;
    
    double deltaX = inputX - (double)gridX;
    double deltaY = inputY - (double)gridY;
    
    double u = deltaX * deltaX * deltaX * (deltaX * (deltaX * 6.0 - 15.0) + 10.0);
    double v = deltaY * deltaY * deltaY * (deltaY * (deltaY * 6.0 - 15.0) + 10.0);
    
    char* p = &self.p;
    int x_idx = gridX & 0xFF;
    int y_idx = gridY & 0xFF;
    
    int hash_a  = (int)p[x_idx] + y_idx;
    int hash_b  = (int)p[x_idx + 1] + y_idx;
    
    int p_a = (int)p[hash_a];
    int p_a1 = (int)p[hash_a + 1];
    int p_b = (int)p[hash_b];
    int p_b1 = (int)p[hash_b + 1];

    double[<4>] inputZ = z + self.zo;
    
    int[<4>] gridZ;
    double[<4>] deltaZ;
    double[<4>] w;
    
    double[<4>] lerpY1;
    double[<4>] lerpY2;
    
    for(int i = 0; i < 4; i++) {
        gridZ[i] = (int)inputZ[i];
        if (inputZ[i] < (double)gridZ[i]) gridZ[i]--;
        
        deltaZ[i] = inputZ[i] - (double)gridZ[i];
        w[i] = deltaZ[i] * deltaZ[i] * deltaZ[i] * (deltaZ[i] * (deltaZ[i] * 6.0 - 15.0) + 10.0);
        
        int z_idx = gridZ[i] & 0xFF;
        
        int gi000 = ((int)p[p_a + z_idx] & 15) << 2;
        int gi001 = ((int)p[p_a + z_idx + 1] & 15) << 2;
        int gi010 = ((int)p[p_a1 + z_idx] & 15) << 2;
        int gi011 = ((int)p[p_a1 + z_idx + 1] & 15) << 2;
        int gi100 = ((int)p[p_b + z_idx] & 15) << 2;
        int gi101 = ((int)p[p_b + z_idx + 1] & 15) << 2;
        int gi110 = ((int)p[p_b1 + z_idx] & 15) << 2;
        int gi111 = ((int)p[p_b1 + z_idx + 1] & 15) << 2;

        double z1 = deltaZ[i] - 1.0;
        double x1 = deltaX - 1.0; 
        double wy1 = deltaY - 1.0; 

        double n000 = FLAT_SIMPLEX_GRAD[gi000] * deltaX + FLAT_SIMPLEX_GRAD[gi000 | 1] * deltaY + FLAT_SIMPLEX_GRAD[gi000 | 2] * deltaZ[i];
        double n100 = FLAT_SIMPLEX_GRAD[gi100] * x1 + FLAT_SIMPLEX_GRAD[gi100 | 1] * deltaY + FLAT_SIMPLEX_GRAD[gi100 | 2] * deltaZ[i];
        double n010 = FLAT_SIMPLEX_GRAD[gi010] * deltaX + FLAT_SIMPLEX_GRAD[gi010 | 1] * wy1 + FLAT_SIMPLEX_GRAD[gi010 | 2] * deltaZ[i];
        double n110 = FLAT_SIMPLEX_GRAD[gi110] * x1 + FLAT_SIMPLEX_GRAD[gi110 | 1] * wy1 + FLAT_SIMPLEX_GRAD[gi110 | 2] * deltaZ[i];
        double n001 = FLAT_SIMPLEX_GRAD[gi001] * deltaX + FLAT_SIMPLEX_GRAD[gi001 | 1] * deltaY + FLAT_SIMPLEX_GRAD[gi001 | 2] * z1;
        double n101 = FLAT_SIMPLEX_GRAD[gi101] * x1 + FLAT_SIMPLEX_GRAD[gi101 | 1] * deltaY + FLAT_SIMPLEX_GRAD[gi101 | 2] * z1;
        double n011 = FLAT_SIMPLEX_GRAD[gi011] * deltaX + FLAT_SIMPLEX_GRAD[gi011 | 1] * wy1 + FLAT_SIMPLEX_GRAD[gi011 | 2] * z1;
        double n111 = FLAT_SIMPLEX_GRAD[gi111] * x1 + FLAT_SIMPLEX_GRAD[gi111 | 1] * wy1 + FLAT_SIMPLEX_GRAD[gi111 | 2] * z1;

        double lerpX1 = n000 + u * (n100 - n000);
        double lerpX2 = n010 + u * (n110 - n010);
        double lerpX3 = n001 + u * (n101 - n001);
        double lerpX4 = n011 + u * (n111 - n011);

        lerpY1[i] = lerpX1 + v * (lerpX2 - lerpX1);
        lerpY2[i] = lerpX3 + v * (lerpX4 - lerpX3);
    }
    
    return lerpY1 + w * (lerpY2 - lerpY1);
}

fn double[<4>] PerlinNoise.getValue4Z(PerlinNoise* self, double d, double e, double[<4>] f) {
    return self.getValueFull4Z(d, e, f, 0.0, 0.0, false);
}

fn double[<4>] PerlinNoise.getValueFull4Z(PerlinNoise* self, double d, double e, double[<4>] f, double g, double h, bool use_yo) {
    double[<4>] i = {0.0, 0.0, 0.0, 0.0};
    double j = self.lowestFreqInputFactor;
    double k = self.lowestFreqValueFactor;
    
    ImprovedNoise*[] noises = self.noiseLevels;
    
    for (int l = 0; l < noises.len; l++) {
        ImprovedNoise* improvedNoise = noises[l];
        if (improvedNoise != null) {
            double wrap_d = wrap(d * j);
            double wrap_e = use_yo ? -improvedNoise.yo : wrap(e * j);
            
            double[<4>] wrap_f = f * j; 
            
            double[<4>] m = improvedNoise.noise4Z(wrap_d, wrap_e, wrap_f, g * j, h * j); 
            i += m * (self.amplitudes[l] * k);
        }
        j *= 2.0;
        k *= 0.5;
    }
    return i;
}

fn void ImprovedNoise.init(ImprovedNoise* self, random::RandomSource seed) {
    self.xo = seed.nextDouble() * 256.0;
    self.yo = seed.nextDouble() * 256.0;
    self.zo = seed.nextDouble() * 256.0;

    for (int i = 0; i < 256; i++) {
        self.p[i] = (Byte)i;
    }

    for (int i = 0; i < 256; i++) {
        int j = seed.nextIntBounded(256 - i); 
        
        Byte b = self.p[i];
        self.p[i] = self.p[i + j];
        self.p[i + j] = b;
    }

	for (int i = 0; i < 256; i++) {
        self.p[i + 256] = self.p[i];
    }
}

fn void ImprovedNoise.delete(ImprovedNoise* self) {
	std::core::mem::free(self);
}

fn long createImprovedNoisePtr(random::RandomSource randomSource) {
	ImprovedNoise* noise = mem::alloc(ImprovedNoise);
	noise.init(randomSource);
	return (long)noise;
}

//////////////////////////////////////////
////	PERLINE NOISE				  ////
//////////////////////////////////////////

const int ROUND_OFF = 0x2000000;

struct PerlinNoise {
	ImprovedNoise*[] noiseLevels;
    ImprovedNoise* pool;
    double[] amplitudes;
    int firstOctave;
    double lowestFreqValueFactor;
    double lowestFreqInputFactor;
    double maxValue;
}

fn double wrap(double d) @inline {
    return d - (double)(long)math::floor(d / 3.3554432E7 + 0.5) * 3.3554432E7;
}

fn void skipOctave(random::RandomSource randomSource) {
    randomSource.consumeCount(262);
}


fn double clampedLerp(double a, double b, double t) @inline {
    if (t < 0.0) return a;
    if (t > 1.0) return b;
    return lerp(t, a, b);
}

fn ImprovedNoise* PerlinNoise.getOctaveNoise(PerlinNoise* self, int i) {
    int idx = self.noiseLevels.len - 1 - i;
    if (idx < 0 || idx >= self.noiseLevels.len) return null;
    return self.noiseLevels[idx];
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
    
    ImprovedNoise*[] noises = self.noiseLevels;
    int len = noises.len;

    for (int l = 0; l < len; l++) {
        ImprovedNoise* improvedNoise = noises[l];
        
        if (improvedNoise != null) {
            double wrap_d = wrap(d * j);
            double wrap_e = use_yo ? -improvedNoise.yo : wrap(e * j);
            double wrap_f = wrap(f * j);
            
            double m = improvedNoise.noise(wrap_d, wrap_e, wrap_f, g * j, h * j); 
            i += self.amplitudes[l] * m * k;
        }
        
        j *= 2.0;
        k *= 0.5;
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
    
    int activeOctaves = 0;
    for (int k = 0; k < len; k++) {
        if (self.amplitudes[k] != 0.0) activeOctaves++;
    }
    
    self.pool = mem::new_array(ImprovedNoise, activeOctaves);
    int poolIdx = 0;
    
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
            
        
            ImprovedNoise* newNoise = &self.pool[poolIdx++];
            newNoise.init(octaveRandom);
            self.noiseLevels[k] = newNoise;
        }
        mem::free(factory.ptr);
        
    } else {
        ImprovedNoise dummyNoise; 
        ImprovedNoise* baseNoise;
        
        if (j >= 0 && j < len && self.amplitudes[j] != 0.0) {
            baseNoise = &self.pool[poolIdx++]; 
        } else {
            baseNoise = &dummyNoise;
        }
        
        baseNoise.init(randomSource);
        
        if (j >= 0 && j < len && self.amplitudes[j] != 0.0) {
            self.noiseLevels[j] = baseNoise;
        }
        
        for (int k = j - 1; k >= 0; k--) {
            if (k < len) {
                double e = self.amplitudes[k];
                if (e != 0.0) {
                    ImprovedNoise* newNoise = &self.pool[poolIdx++];
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
    
    self.lowestFreqInputFactor = j >= 0 ? (1.0 / (double)(1L << j)) : (double)(1L << -j);
    self.lowestFreqValueFactor = (double)(1L << (len - 1)) / (double)((1L << len) - 1);
    
    self.maxValue = self.edgeValue(2.0);
}

fn void PerlinNoise.delete(PerlinNoise* self) {
	if (self.pool != null) {
        mem::free(self.pool); // Уничтожаем весь пул октав разом
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

//////////////////////////////////////////
////	NORMAL NOISE				  ////
//////////////////////////////////////////

const double NORMAL_NOISE_INPUT_FACTOR = 1.0181268882175227;
const double NORMAL_NOISE_TARGET_DEVIATION = 0.3333333333333333; 

struct NoiseParameters {
    int firstOctave;
    double[] amplitudes;
}

fn void NoiseParameters.delete(NoiseParameters* self) {
	if(self.amplitudes.ptr == null) return;

	std::core::mem::free(self.amplitudes.ptr);
}

struct NormalNoise {
    double valueFactor;
    PerlinNoise* first;
    PerlinNoise* second;
    double maxValue;
    NoiseParameters parameters;
}

fn double expectedDeviation(int i) @inline {
    return 0.1 * (1.0 + 1.0 / (double)(i + 1));
}

fn double[<4>] NormalNoise.getValue4Z(NormalNoise* self, double x, double y, double[<4>] z) {
    double x2 = x * NORMAL_NOISE_INPUT_FACTOR;
    double y2 = y * NORMAL_NOISE_INPUT_FACTOR;
    
    double[<4>] z2 = z * NORMAL_NOISE_INPUT_FACTOR; 
    
    return (self.first.getValue4Z(x, y, z) + self.second.getValue4Z(x2, y2, z2)) * self.valueFactor;
}

fn double NormalNoise.getValue2D(NormalNoise* self, double x, double z) {
    double x2 = x * NORMAL_NOISE_INPUT_FACTOR;
    double z2 = z * NORMAL_NOISE_INPUT_FACTOR;
    
    return (self.first.getValue(x, 0.0, z) + self.second.getValue(x2, 0.0, z2)) * self.valueFactor;
}

fn double NormalNoise.getValue(NormalNoise* self, double x, double y, double z) {
    double x2 = x * NORMAL_NOISE_INPUT_FACTOR;
    double y2 = y * NORMAL_NOISE_INPUT_FACTOR;
    double z2 = z * NORMAL_NOISE_INPUT_FACTOR;
    
    return (self.first.getValue(x, y, z) + self.second.getValue(x2, y2, z2)) * self.valueFactor;
}

fn void NormalNoise.init(NormalNoise* self, random::RandomSource randomSource, NoiseParameters parameters, bool usePositional) {
    self.parameters.firstOctave = parameters.firstOctave;
    
    self.parameters.amplitudes = mem::new_array(double, parameters.amplitudes.len);
    mem::copy(self.parameters.amplitudes.ptr, parameters.amplitudes.ptr, parameters.amplitudes.len * double.sizeof);

    int i = self.parameters.firstOctave;
    double[] amplitudes = self.parameters.amplitudes;
    

    if (usePositional) {
        self.first = createFromAmplitudes(randomSource, i, amplitudes);
        self.second = createFromAmplitudes(randomSource, i, amplitudes);
    } else {
        self.first = createLegacyForLegacyNetherBiome(randomSource, i, amplitudes);
        self.second = createLegacyForLegacyNetherBiome(randomSource, i, amplitudes);
    }
    

    int j = 0x7FFFFFFF;
    int k = -0x7FFFFFFF - 1;
    
    for (int l = 0; l < amplitudes.len; l++) {
        double d = amplitudes[l];
        if (d != 0.0) {
            if (l < j) j = l;
            if (l > k) k = l;
        }
    }
    
    self.valueFactor = 0.16666666666666666 / expectedDeviation(k - j);
    self.maxValue = (self.first.maxValue + self.second.maxValue) * self.valueFactor;
}

fn void NormalNoise.delete(NormalNoise* self) {
	if (self.first != null) {
        self.first.delete();
    }
    if (self.second != null) {
        self.second.delete();
    }

	self.parameters.delete();
}

fn NormalNoise* createNormalNoise(random::RandomSource randomSource, NoiseParameters parameters) {
    NormalNoise* noise = mem::alloc(NormalNoise);
    noise.init(randomSource, parameters, true);
    return noise;
}

fn NormalNoise* createLegacyNormalNoise(random::RandomSource randomSource, NoiseParameters parameters) {
    NormalNoise* noise = mem::alloc(NormalNoise);
    noise.init(randomSource, parameters, false);
    return noise;
}

fn NormalNoise* createNormalNoiseFromSlice(random::RandomSource randomSource, int firstOctave, double[] amplitudes) {
    NoiseParameters params;
    params.firstOctave = firstOctave;

    params.amplitudes = mem::new_array(double, amplitudes.len);
    mem::copy(params.amplitudes.ptr, amplitudes.ptr, amplitudes.len * double.sizeof);

    NormalNoise* noise = mem::alloc(NormalNoise);
    noise.init(randomSource, params, true);

    mem::free(params.amplitudes.ptr);

    return noise;
}

//////////////////////////////////////////
////	BLENDED NOISE				  ////
//////////////////////////////////////////

struct BlendedNoise {
    PerlinNoise* minLimitNoise;
    PerlinNoise* maxLimitNoise;
    PerlinNoise* mainNoise;
    
    double xzScale;
    double yScale;
    double xzFactor;
    double yFactor;
    double smearScaleMultiplier;
    
    double xzMultiplier;
    double yMultiplier;
    double maxValue;
}

fn BlendedNoise* createBlendedNoise(random::RandomSource randomSource, double xzScale, double yScale, double xzFactor, double yFactor, double smearScaleMultiplier) {
    BlendedNoise* self = mem::alloc(BlendedNoise);
    
    self.minLimitNoise = createLegacyForBlendedNoise(randomSource, -15, 0);
    self.maxLimitNoise = createLegacyForBlendedNoise(randomSource, -15, 0);
    self.mainNoise = createLegacyForBlendedNoise(randomSource, -7, 0);
    
    self.xzScale = xzScale;
    self.yScale = yScale;
    self.xzFactor = xzFactor;
    self.yFactor = yFactor;
    self.smearScaleMultiplier = smearScaleMultiplier;
    
    self.xzMultiplier = 684.412 * self.xzScale;
    self.yMultiplier = 684.412 * self.yScale;
    
    self.maxValue = self.minLimitNoise.maxBrokenValue(self.yMultiplier);
    
    return self;
}

fn void BlendedNoise.delete(BlendedNoise* self) {
    if (self.minLimitNoise != null) {
        self.minLimitNoise.delete();
        // mem::free(self.minLimitNoise);
    }
    if (self.maxLimitNoise != null) {
        self.maxLimitNoise.delete();
        // mem::free(self.maxLimitNoise);
    }
    if (self.mainNoise != null) {
        self.mainNoise.delete();
        // mem::free(self.mainNoise);
    }
}

fn double BlendedNoise.compute(BlendedNoise* self, int blockX, int blockY, int blockZ) {
    double d = (double)blockX * self.xzMultiplier;
    double e = (double)blockY * self.yMultiplier;
    double f = (double)blockZ * self.xzMultiplier;
    
    double g = d / self.xzFactor;
    double h = e / self.yFactor;
    double i = f / self.xzFactor;
    
    double j = self.yMultiplier * self.smearScaleMultiplier;
    double k = j / self.yFactor;
    
    double l = 0.0;
    double m = 0.0;
    double n = 0.0;
    
    double o = 1.0;
    double inv_o = 1.0;
    
    ImprovedNoise*[] mainNoises = self.mainNoise.noiseLevels;
    int mainLen = mainNoises.len;

    for (int p = 0; p < 8; p++) {
        ImprovedNoise* improvedNoise = mainNoises[mainLen - 1 - p];
        if (improvedNoise != null) {
            n += improvedNoise.noise(wrap(g * o), wrap(h * o), wrap(i * o), k * o, h * o) * inv_o;
        }
        o *= 0.5;
        inv_o *= 2.0;
    }
    
    double q = (n / 10.0 + 1.0) * 0.5;
    bool bl2 = q >= 1.0;
    bool bl3 = q <= 0.0;
    
    o = 1.0;
    inv_o = 1.0;
    
    ImprovedNoise*[] minNoises = self.minLimitNoise.noiseLevels;
    ImprovedNoise*[] maxNoises = self.maxLimitNoise.noiseLevels;
    int minLen = minNoises.len;
    int maxLen = maxNoises.len;

    for (int r = 0; r < 16; r++) {
        double s = wrap(d * o);
        double t = wrap(e * o);
        double u = wrap(f * o);
        double v = j * o;
        
        if (!bl2) {
            ImprovedNoise* improvedNoise2 = minNoises[minLen - 1 - r];
            if (improvedNoise2 != null) {
                l += improvedNoise2.noise(s, t, u, v, e * o) * inv_o;
            }
        }
        
        if (!bl3) {
            ImprovedNoise* improvedNoise2 = maxNoises[maxLen - 1 - r];
            if (improvedNoise2 != null) {
                m += improvedNoise2.noise(s, t, u, v, e * o) * inv_o;
            }
        }
        o *= 0.5;
        inv_o *= 2.0;
    }
    
    return clampedLerp(l / 512.0, m / 512.0, q) / 128.0;
}


//////////////////////////////////////////
////	SIMPLEX NOISE		          ////
//////////////////////////////////////////

const double SIMPLEX_SQRT_3 = 1.7320508075688772;
const double SIMPLEX_F2 = 0.3660254037844386;    
const double SIMPLEX_G2 = 0.21132486540518713;   

struct SimplexNoise {
    char[512] p;
	char[512] p_mod12;
    double xo;
    double yo;
    double zo;
}

fn void SimplexNoise.init(SimplexNoise* self, random::RandomSource seed) {
    self.xo = seed.nextDouble() * 256.0;
    self.yo = seed.nextDouble() * 256.0;
    self.zo = seed.nextDouble() * 256.0;
    
    for (int i = 0; i < 256; i++) {
        self.p[i] = (char)i;
    }
    
    for (int i = 0; i < 256; i++) {
        int j = seed.nextIntBounded(256 - i);
        char k = self.p[i];
        self.p[i] = self.p[j + i];
        self.p[j + i] = k;
    }

    
    for (int i = 0; i < 256; i++) {
        self.p[i + 256] = self.p[i];
        
        char mod12 = self.p[i] % 12;
        self.p_mod12[i] = mod12;
        self.p_mod12[i + 256] = mod12;
    }
}

fn void SimplexNoise.delete(SimplexNoise* self) {
	std::core::mem::free(self);
}

fn int SimplexNoise.getP(SimplexNoise* self, int i) @inline {
    return self.p[i & 0xFF];
}

fn double SimplexNoise.getCornerNoise3D(SimplexNoise* self, int i, double d, double e, double f, double g) @inline {
    double h = g - d * d - e * e - f * f;
    if (h < 0.0) {
        return 0.0;
    }
    h *= h;
	
    return h * h * dot(&GRADIENT[i], d, e, f);
}

fn double SimplexNoise.getValue2D(SimplexNoise* self, double d, double e) {
    double f = (d + e) * SIMPLEX_F2;
    int i = fastFloor(d + f);
    int j = fastFloor(e + f);
    
    double g = (double)(i + j) * SIMPLEX_G2;
    double h = (double)i - g;
    double l = d - h;
    
    double k = (double)j - g; 
    double m = e - k;
    
    int n; 
    int o; 
    if (l > m) { 
        n = 1;
        o = 0;
    } else { 
        n = 0;
        o = 1;
    }
    
    double p = l - (double)n + SIMPLEX_G2;
    double q = m - (double)o + SIMPLEX_G2;
    double r = l - 1.0 + 2.0 * SIMPLEX_G2;
    double s = m - 1.0 + 2.0 * SIMPLEX_G2;
    
    int t = i & 0xFF;
    int u = j & 0xFF;
    
    char* p_arr = &self.p;
    char* p_mod = &self.p_mod12;

    int v = p_mod[t + p_arr[u]];
    int w = p_mod[t + n + p_arr[u + o]];
    int x = p_mod[t + 1 + p_arr[u + 1]];
    
    double y = self.getCornerNoise3D(v, l, m, 0.0, 0.5); 
    double z = self.getCornerNoise3D(w, p, q, 0.0, 0.5); 
    double aa = self.getCornerNoise3D(x, r, s, 0.0, 0.5);
    return 70.0 * (y + z + aa);
}

fn double SimplexNoise.getValue3D(SimplexNoise* self, double d, double e, double f) {
    double g = 0.3333333333333333; // 1/3
    double h = (d + e + f) * g;
    
    int i = fastFloor(d + h);
    int j = fastFloor(e + h);
    int k = fastFloor(f + h);
    
    double l = 0.16666666666666666; // 1/6
    double m = (double)(i + j + k) * l;
    
    double n = (double)i - m;
    double o = (double)j - m;
    double p = (double)k - m;
    
    double q = d - n;
    double r = e - o;
    double s = f - p;
    
    int t, u, v, w, x, y;
    
    if (q >= r) {
        if (r >= s) {
            t = 1; u = 0; v = 0; w = 1; x = 1; y = 0;
        } else if (q >= s) {
            t = 1; u = 0; v = 0; w = 1; x = 0; y = 1;
        } else {
            t = 0; u = 0; v = 1; w = 1; x = 0; y = 1;
        }
    } else if (r < s) {
        t = 0; u = 0; v = 1; w = 0; x = 1; y = 1;
    } else if (q < s) {
        t = 0; u = 1; v = 0; w = 0; x = 1; y = 1;
    } else {
        t = 0; u = 1; v = 0; w = 1; x = 1; y = 0;
    }
    
    double z = q - (double)t + l;
    double aa = r - (double)u + l;
    double ab = s - (double)v + l;
    
    double ac = q - (double)w + g;
    double ad = r - (double)x + g;
    double ae = s - (double)y + g;
    
    double af = q - 1.0 + 0.5;
    double ag = r - 1.0 + 0.5;
    double ah = s - 1.0 + 0.5;
    
    int ai = i & 0xFF;
    int aj = j & 0xFF;
    int ak = k & 0xFF;

    char* p2 = &self.p;
    char* p_mod = &self.p_mod12;

    int al = p_mod[ai + p2[aj + p2[ak]]];
    int am = p_mod[ai + t + p2[aj + u + p2[ak + v]]];
    int an = p_mod[ai + w + p2[aj + x + p2[ak + y]]];
    int ao = p_mod[ai + 1 + p2[aj + 1 + p2[ak + 1]]];
    
    double ap = self.getCornerNoise3D(al, q, r, s, 0.6);
    double aq = self.getCornerNoise3D(am, z, aa, ab, 0.6);
    double ar = self.getCornerNoise3D(an, ac, ad, ae, 0.6);
    double as = self.getCornerNoise3D(ao, af, ag, ah, 0.6);
    
    return 32.0 * (ap + aq + ar + as);
}

//////////////////////////////////////////
////	PERLIN SIMPLEX NOISE		  ////
//////////////////////////////////////////

fn bool containsInt(int[] array, int value) {
    for (int i = 0; i < array.len; i++) {
        if (array[i] == value) return true;
    }
    return false;
}

struct PerlinSimplexNoise {
    SimplexNoise*[] noiseLevels;
    double highestFreqValueFactor;
    double highestFreqInputFactor;
}

fn void PerlinSimplexNoise.init(PerlinSimplexNoise* self, random::RandomSource randomSource, int[] octaves) {
    int firstInt = octaves[0];
    int lastInt = octaves[0];
    for (int idx = 1; idx < octaves.len; idx++) {
        if (octaves[idx] < firstInt) firstInt = octaves[idx];
        if (octaves[idx] > lastInt) lastInt = octaves[idx];
    }
    
    int i = -firstInt;
    int j = lastInt;
    int k = i + j + 1;
    
    SimplexNoise* simplexNoise = mem::alloc(SimplexNoise);
    simplexNoise.init(randomSource);
    
    int l = j;
    self.noiseLevels = mem::new_array(SimplexNoise*, k);
    mem::clear(self.noiseLevels.ptr, k * (SimplexNoise*).sizeof);
    
    bool simplexStored = false;
    
    if (l >= 0 && l < k && containsInt(octaves, 0)) {
        self.noiseLevels[l] = simplexNoise;
        simplexStored = true;
    }
    
    for (int m = l + 1; m < k; m++) {
        if (m >= 0 && containsInt(octaves, l - m)) {
            SimplexNoise* newNoise = mem::alloc(SimplexNoise);
            newNoise.init(randomSource);
            self.noiseLevels[m] = newNoise;
        } else {
            randomSource.consumeCount(262);
        }
    }
    
    if (j > 0) {
        double noiseVal = simplexNoise.getValue3D(simplexNoise.xo, simplexNoise.yo, simplexNoise.zo);
        long n = (long)(noiseVal * 9.223372036854776E18);
        
        random::LegacyRandomSource* randomSource2 = mem::alloc(random::LegacyRandomSource);
        randomSource2.init(n);

		random::WorldgenRandom* worldGen = std::core::mem::alloc(WorldgenRandom);
		worldGen.init(randomSource2);
        
        for (int o = l - 1; o >= 0; o--) {
            if (o < k && containsInt(octaves, l - o)) {
                SimplexNoise* newNoise = mem::alloc(SimplexNoise);
                newNoise.init(worldGen);
                self.noiseLevels[o] = newNoise;
            } else {
                worldGen.consumeCount(262);
            }
        }
		worldGen.delete();
		
        // mem::free(randomSource2);
    }
    
    if (!simplexStored) {
        mem::free(simplexNoise);
    }
    
    self.highestFreqInputFactor = math::pow(2.0, (double)j);
    self.highestFreqValueFactor = 1.0 / (math::pow(2.0, (double)k) - 1.0);
}

fn void PerlinSimplexNoise.delete(PerlinSimplexNoise* self) {
    for (int idx = 0; idx < self.noiseLevels.len; idx++) {
        if (self.noiseLevels[idx] != null) {
            self.noiseLevels[idx].delete();
        }
    }
    mem::free(self.noiseLevels.ptr);
}

fn double PerlinSimplexNoise.getValue(PerlinSimplexNoise* self, double d, double e, bool bl) {
    double f = 0.0;
    double g = self.highestFreqInputFactor;
    double h = self.highestFreqValueFactor;
    
    for (int idx = 0; idx < self.noiseLevels.len; idx++) {
        SimplexNoise* simplexNoise = self.noiseLevels[idx];
        if (simplexNoise != null) {
            double x = d * g + (bl ? simplexNoise.xo : 0.0);
            double y = e * g + (bl ? simplexNoise.yo : 0.0);
            
            f += simplexNoise.getValue2D(x, y) * h;
        }
        g *= 0.5;
        h *= 2.0;
    }
    return f;
}

fn PerlinSimplexNoise* createPerlinSimplexNoise(random::RandomSource randomSource, int[] octaves) {
    PerlinSimplexNoise* noise = mem::alloc(PerlinSimplexNoise);
    noise.init(randomSource, octaves);
    return noise;
}