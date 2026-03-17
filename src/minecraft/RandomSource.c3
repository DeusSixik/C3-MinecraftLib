module minecraft::random;

import std;
import std::time;
import std::atomic;
import std::math;

const long SEED_UNIQUIFIER = 8682522807148012;

interface RandomSource {

	fn void setSeed(long seed);

	fn int nextInt(int bound = 0);

	fn long nextLong();

	fn bool nextBoolean();

	fn float nextFloat();

	fn double nextDouble();

	fn double nextGaussian();
}

<*
	@require max > min
*>
fn int RandomSource.nextIntBetweenInclusive(RandomSource* self, int min, int max) {
	int range = max - min + 1;
	return self.nextInt(range) + min;
}

fn double RandomSource.triangle(RandomSource* self, double value1, double value2) {
	return value1 + value2 * (self.nextDouble() - self.nextDouble()); 
}

fn void RandomSource.consumeCount(RandomSource* self, int count) {
	for (int i = 0; i < count; i++) {
		self.nextInt();
	}
}
<*
	@require max > min
*>
fn int RandomSource.nextIntBetween(RandomSource* self, int min, int max) {
	return min + self.nextInt(max - min);
}

const float FLOAT_MULTIPLIER = 5.9604645E-8F;
const double DOUBLE_MULTIPLIER = 1.110223E-16;

interface BitRandomSource: RandomSource {

	fn int next(int value);
}

struct MarsagliaPolarGaussian {
	RandomSource source;
	double nextNextGaussian;
	bool haveNextNextGaussian;
}

fn void MarsagliaPolarGaussian.init(MarsagliaPolarGaussian* self, RandomSource source) {
	self.source = source;
	self.haveNextNextGaussian = false;
}

fn double MarsagliaPolarGaussian.nextGaussian(MarsagliaPolarGaussian* self) {
	if (self.haveNextNextGaussian) {
		self.haveNextNextGaussian = false;
		return self.nextNextGaussian;
	} else {
		double v1, v2, s;
		do {
			v1 = 2 * self.source.nextDouble() - 1; 
			v2 = 2 * self.source.nextDouble() - 1; 
			s = v1 * v1 + v2 * v2;
		} while (s >= 1 || s == 0);

		double multiplier = math::sqrt(-2 * math::ln(s) / s);
		self.nextNextGaussian = v2 * multiplier;
		self.haveNextNextGaussian = true;
		return v1 * multiplier;
	}
}

fn void MarsagliaPolarGaussian.reset(MarsagliaPolarGaussian* self) {
	self.haveNextNextGaussian = false;
}

struct LegacyRandomSource(BitRandomSource) {
	Atomic {long} seed;
	MarsagliaPolarGaussian* gaussianSource;
}

fn void LegacyRandomSource.initAuto(LegacyRandomSource* self) {
	long current_time = (long) time::now(); 
    long generated_seed = current_time ^ SEED_UNIQUIFIER;
    self.init(generated_seed);
}

fn void LegacyRandomSource.init(LegacyRandomSource* self, long initial_seed) {
	self.setSeed(initial_seed);

	MarsagliaPolarGaussian* gaussian = mem::alloc(MarsagliaPolarGaussian);
	gaussian.init(self);
	self.gaussianSource = gaussian;
}

fn void LegacyRandomSource.setSeed(LegacyRandomSource* self, long seed) @dynamic {
	seed = (seed ^ 0x5DEECE66DL) & 0xFFFFFFFFFFFFL;
	self.seed.store(seed);
	self.gaussianSource.reset();
}

fn int LegacyRandomSource.next(LegacyRandomSource* self, int bits) @dynamic {
	long oldSeed = self.seed.load();
	long newSeed = (oldSeed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
	self.seed.store(newSeed);
	return (int)(newSeed >> (48 - bits));
}

fn double LegacyRandomSource.nextGaussian(LegacyRandomSource* self) @dynamic {
	return self.gaussianSource.nextGaussian();
}

<*
	@require bound > 0
*>
fn int LegacyRandomSource.nextInt(LegacyRandomSource* self, int bound) @dynamic {
	if ((bound & (bound - 1)) == 0) {
		return (int)((bound * (long)self.next(31)) >> 31);
	}

	int bits, val;
	do {
		bits = self.next(31);
		val = bits % bound;
	} while (bits - val + (bound - 1) < 0);

	return val;
}

fn long LegacyRandomSource.nextLong(LegacyRandomSource* self) @dynamic {
	return ((long)self.next(32) << 32) + self.next(32);
}

fn bool LegacyRandomSource.nextBoolean(LegacyRandomSource* self) @dynamic {
	return self.next(1) != 0;
}

fn double LegacyRandomSource.nextDouble(LegacyRandomSource* self) @dynamic {
	return ((double) ((long)(self.next(26)) << 27 + self.next(27))) * DOUBLE_MULTIPLIER;
}

fn float LegacyRandomSource.nextFloat(LegacyRandomSource* self) @dynamic {
	return self.next(24) * FLOAT_MULTIPLIER;
}

fn void LegacyRandomSource.free(LegacyRandomSource* self) {
	mem::free(self.gaussianSource);
}

const MULTIPLIER = 25214903917L;
const ADDEND = 11L;
const BITS = 48;
const MASK = 281474976710655L;

struct SimpleRandom(BitRandomSource) {	
	long seed;
}

fn void SimpleRandom.initAuto(SimpleRandom* self) {
	long current_time = (long) time::now(); 
    long generated_seed = current_time ^ SEED_UNIQUIFIER;
    self.init(generated_seed);
}

fn void SimpleRandom.init(SimpleRandom* self, long initial_seed) {
	self.seed = initial_seed;
}

fn void SimpleRandom.setSeed(SimpleRandom* self, long seed) @dynamic {
	self.seed = (seed ^ 25214903917L) & 281474976710655L;
}

fn int SimpleRandom.next(SimpleRandom* self, int bits) @dynamic {
    long shifted = self.advanceSeed() >> (48 - bits);
    return (int)shifted;
}

fn long SimpleRandom.advanceSeed(SimpleRandom* self) {
    self.seed = ((self.seed * MULTIPLIER) + ADDEND) & MASK;
    return self.seed;
}

fn double SimpleRandom.nextGaussian(SimpleRandom* self) @dynamic {
	return 0.0;
}

<*
    @require bound > 0
*>
fn int SimpleRandom.nextInt(SimpleRandom* self, int bound) @dynamic {
    if ((bound & (bound - 1)) == 0) {
        return (int)((bound * (long)self.next(31)) >> 31);
    }

    int bits, val;
    do {
        bits = self.next(31);
        val = bits % bound;
    } while (bits - val + (bound - 1) < 0);

    return val;
}

fn long SimpleRandom.nextLong(SimpleRandom* self) @dynamic {
	return ((long)self.next(32) << 32) + self.next(32);
}

fn bool SimpleRandom.nextBoolean(SimpleRandom* self) @dynamic {
	return self.next(1) != 0;
}

fn double SimpleRandom.nextDouble(SimpleRandom* self) @dynamic {
	return ((double) ((long)(self.next(26)) << 27 + self.next(27))) * DOUBLE_MULTIPLIER;
}

fn float SimpleRandom.nextFloat(SimpleRandom* self) @dynamic {
	return self.next(24) * FLOAT_MULTIPLIER;
}