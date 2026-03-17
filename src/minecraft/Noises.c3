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
            
          
	         random::LegacyRandomSource* lrs = (random::LegacyRandomSource*)octaveRandom.ptr;
            lrs.free();
            mem::free(lrs);
        }

        mem::free(factory.ptr);
        
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

//////////////////////////////////////////
////	NORMAL NOISE				  ////
//////////////////////////////////////////

const double NORMAL_NOISE_INPUT_FACTOR = 1.0181268882175227;
const double NORMAL_NOISE_TARGET_DEVIATION = 0.3333333333333333; 

struct NoiseParameters {
    int firstOctave;
    double[] amplitudes;
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

fn void NormalNoise.free(NormalNoise* self) {
    if (self.first != null) {
        self.first.free();
        mem::free(self.first);
    }
    if (self.second != null) {
        self.second.free();
        mem::free(self.second);
    }
    
    mem::free(self.parameters.amplitudes.ptr);
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
    params.amplitudes = amplitudes;
    
    NormalNoise* noise = mem::alloc(NormalNoise);
    noise.init(randomSource, params, true);
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

fn void BlendedNoise.free(BlendedNoise* self) {
    if (self.minLimitNoise != null) {
        self.minLimitNoise.free();
        mem::free(self.minLimitNoise);
    }
    if (self.maxLimitNoise != null) {
        self.maxLimitNoise.free();
        mem::free(self.maxLimitNoise);
    }
    if (self.mainNoise != null) {
        self.mainNoise.free();
        mem::free(self.mainNoise);
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
    
    for (int p = 0; p < 8; p++) {
        ImprovedNoise* improvedNoise = self.mainNoise.getOctaveNoise(p);
        if (improvedNoise != null) {
            n += improvedNoise.noise(wrap(g * o), wrap(h * o), wrap(i * o), k * o, h * o) / o;
        }
        o /= 2.0;
    }
    
    double q = (n / 10.0 + 1.0) / 2.0;
    bool bl2 = q >= 1.0;
    bool bl3 = q <= 0.0;
    o = 1.0;
    
    for (int r = 0; r < 16; r++) {
        double s = wrap(d * o);
        double t = wrap(e * o);
        double u = wrap(f * o);
        double v = j * o;
        
        if (!bl2) {
            ImprovedNoise* improvedNoise2 = self.minLimitNoise.getOctaveNoise(r);
            if (improvedNoise2 != null) {
                l += improvedNoise2.noise(s, t, u, v, e * o) / o;
            }
        }
        
        if (!bl3) {
            ImprovedNoise* improvedNoise2 = self.maxLimitNoise.getOctaveNoise(r);
            if (improvedNoise2 != null) {
                m += improvedNoise2.noise(s, t, u, v, e * o) / o;
            }
        }
        o /= 2.0;
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
    int[512] p;
    double xo;
    double yo;
    double zo;
}

fn void SimplexNoise.init(SimplexNoise* self, random::RandomSource seed) {
    self.xo = seed.nextDouble() * 256.0;
    self.yo = seed.nextDouble() * 256.0;
    self.zo = seed.nextDouble() * 256.0;
    
    for (int i = 0; i < 256; i++) {
        self.p[i] = i;
    }
    
    for (int i = 0; i < 256; i++) {
        int j = seed.nextInt(256 - i);
        int k = self.p[i];
        self.p[i] = self.p[j + i];
        self.p[j + i] = k;
    }
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
    
    int v = self.getP(t + self.getP(u)) % 12;
    int w = self.getP(t + n + self.getP(u + o)) % 12;
    int x = self.getP(t + 1 + self.getP(u + 1)) % 12;
    
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
    
    int al = self.getP(ai + self.getP(aj + self.getP(ak))) % 12;
    int am = self.getP(ai + t + self.getP(aj + u + self.getP(ak + v))) % 12;
    int an = self.getP(ai + w + self.getP(aj + x + self.getP(ak + y))) % 12;
    int ao = self.getP(ai + 1 + self.getP(aj + 1 + self.getP(ak + 1))) % 12;
    
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
        
        for (int o = l - 1; o >= 0; o--) {
            if (o < k && containsInt(octaves, l - o)) {
                SimplexNoise* newNoise = mem::alloc(SimplexNoise);
                newNoise.init(randomSource2);
                self.noiseLevels[o] = newNoise;
            } else {
                randomSource2.consumeCount(262);
            }
        }
        mem::free(randomSource2);
    }
    
    if (!simplexStored) {
        mem::free(simplexNoise);
    }
    
    self.highestFreqInputFactor = math::pow(2.0, (double)j);
    self.highestFreqValueFactor = 1.0 / (math::pow(2.0, (double)k) - 1.0);
}

fn void PerlinSimplexNoise.free(PerlinSimplexNoise* self) {
    for (int idx = 0; idx < self.noiseLevels.len; idx++) {
        if (self.noiseLevels[idx] != null) {
            mem::free(self.noiseLevels[idx]);
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
        g /= 2.0;
        h *= 2.0;
    }
    return f;
}

fn PerlinSimplexNoise* createPerlinSimplexNoise(random::RandomSource randomSource, int[] octaves) {
    PerlinSimplexNoise* noise = mem::alloc(PerlinSimplexNoise);
    noise.init(randomSource, octaves);
    return noise;
}