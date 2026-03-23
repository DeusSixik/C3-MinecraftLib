module minecraft::random;

import std;
import minecraft::mth;
import minecraft::random_support;

enum RandomType : int {
	LEGACY,
	XOROSHIRO
}

struct RandomWrapper {
	RandomSource random;
}

fn void RandomWrapper.delete(RandomWrapper* self, bool deleteRandom = false) {
	if(deleteRandom && self.random != null) {
		self.random.delete();
		self.random = null;
	}

	std::core::mem::free(self);
}

fn RandomType RandomWrapper.getType(RandomWrapper* self) {
	if(self.random.type == LegacyRandomSource.typeid) 
	{
		return RandomType.LEGACY;
	}
	
	return RandomType.XOROSHIRO;
}

interface PositionalRandomFactory {

	fn RandomSource fromHashOf(String string);

	fn RandomSource fromSeed(long seed);

	fn RandomSource at(int x, int y, int z);

}

const double RANDOM_SOURCE_GAUSSIAN_SPREAD_FACTOR = 2.297;

interface RandomSource {
	
	fn RandomSource fork();

	fn PositionalRandomFactory forkPositional();

	fn void setSeed(long seed);
	
	fn int nextInt();

	fn int nextIntBounded(int bound = 32); 

	fn int nextInt_2(int from, int to);

	fn int nextIntBetweenInclusive(int from, int to);

	fn long nextLong();

	fn bool nextBoolean();

	fn float nextFloat();

	fn double nextDouble();

	fn double nextGaussian();

	fn double triangle(double a, double b);

	fn void consumeCount(int count);

	fn void delete();
}

fn RandomSource createUnique() {
	return create(random_support::generateUniqueSeed());
}

fn RandomSource create(long seed) {
	LegacyRandomSource* random = std::core::mem::alloc(LegacyRandomSource);
	random.init(seed);
	return random;
}

const float BIT_RANDOM_SOURCE_FLOAT_MULTIPLIER = 5.9604644775390625E-8F; 
const double BIT_RANDOM_SOURCE_DOUBLE_MULTIPLIER = 1.1102230246251565E-16;

interface BitRandomSource : RandomSource {

	fn int next(int value);

}

struct MarsagliaPolarGaussian {
	RandomSource randomSource;
	double nextNextGaussian;
	bool haveNextNextGaussian;
}

fn void MarsagliaPolarGaussian.init(MarsagliaPolarGaussian* self, RandomSource random) {
	self.randomSource = random;
}

fn void MarsagliaPolarGaussian.delete(MarsagliaPolarGaussian* self) {
	mem::free(self);
}

fn void MarsagliaPolarGaussian.reset(MarsagliaPolarGaussian* self) {
	self.haveNextNextGaussian = false;
}

fn double MarsagliaPolarGaussian.nextGaussian(MarsagliaPolarGaussian* self) {
	if(self.haveNextNextGaussian) {
		self.haveNextNextGaussian = false;
		return self.nextNextGaussian;
	}

	double d, e, f;

	do {
		d = 2 * self.randomSource.nextDouble() - 1;
		e = 2 * self.randomSource.nextDouble() - 1;
		f = mth::square(d) + mth::square(e);
	} while(f >= 1 || f == 0);

	double g = std::math::sqrt(-2 * std::math::ln(f) / f);
	self.nextNextGaussian = e * g;
	self.haveNextNextGaussian = true;
	return d * g;
}

///////////////////////////////////////////
// 			LegacyRandomSource           //
///////////////////////////////////////////

const int LEGACY_RANDOM_SOURCE_MODULUS_BITS = 48;
const long LEGACY_RANDOM_MODULUS_MASK = 281474976710655L;
const long LEGACY_RANDOM_MULTIPLIER = 25214903917L;
const long LEGACY_RANDOM_INCREMENT = 11L;

struct LegacyRandomSource(BitRandomSource) {
	Atomic {long} seed;
	MarsagliaPolarGaussian* gaussianSource;
}

fn void LegacyRandomSource.init(LegacyRandomSource* self, long seed) {
	MarsagliaPolarGaussian* created = std::core::mem::alloc(MarsagliaPolarGaussian);
	created.init(self);
	self.gaussianSource = created;
	self.setSeed(seed);
}

fn void LegacyRandomSource.delete(LegacyRandomSource* self) @dynamic {

	if(self.gaussianSource != null) {
		self.gaussianSource.delete();
		self.gaussianSource = null;
	}
	std::core::mem::free(self);
}

fn RandomSource LegacyRandomSource.fork(LegacyRandomSource* self) @dynamic {
	LegacyRandomSource* random = std::core::mem::alloc(LegacyRandomSource);
	random.init(self.nextLong());
	return random;
}

fn PositionalRandomFactory LegacyRandomSource.forkPositional(LegacyRandomSource* self) @dynamic {
	LegacyPositionalRandomFactory* random = std::core::mem::alloc(LegacyPositionalRandomFactory);
	random.init(self.nextLong());
	return random;
}

fn void LegacyRandomSource.setSeed(LegacyRandomSource* self, long seed) @dynamic {
	long seed_in = (seed ^ LEGACY_RANDOM_MULTIPLIER) & LEGACY_RANDOM_MODULUS_MASK;
	self.seed.store(seed_in);

	if(self.gaussianSource != null) {
		self.gaussianSource.reset();
	}
} 

fn int LegacyRandomSource.next(LegacyRandomSource* self, int value) @dynamic {
	long oldseed = self.seed.load();
    long nextseed = (oldseed * LEGACY_RANDOM_MULTIPLIER + LEGACY_RANDOM_INCREMENT) & LEGACY_RANDOM_MODULUS_MASK;
    self.seed.store(nextseed);
    return (int)(nextseed >> (LEGACY_RANDOM_SOURCE_MODULUS_BITS - value));
} 

fn double LegacyRandomSource.nextGaussian(LegacyRandomSource* self) @dynamic {
	return self.gaussianSource.nextGaussian();
}

fn int LegacyRandomSource.nextInt(LegacyRandomSource* self) @dynamic {
	return self.next(32);
}

<*
	@require bound > 0
*>
fn int LegacyRandomSource.nextIntBounded(LegacyRandomSource* self, int bound = 32) @dynamic {
	int r = self.next(31);
	int m = bound - 1;
	
	if ((bound & m) == 0) {
		return (int)(((long)bound * (long)r) >> 31);
	} 

	int u = r;
	int val;
	
	// Точный порт логики Java для отсечения смещения (modulo bias)
	while (true) {
		val = u % bound;
		if (u - val + m >= 0) {
			return val;
		}
		u = self.next(31);
	}
}

fn long LegacyRandomSource.nextLong(LegacyRandomSource* self) @dynamic {
	int i = self.next(32);
	int j = self.next(32);
	long l = (long)i << 32;
	return l + (long)j;
}

fn bool LegacyRandomSource.nextBoolean(LegacyRandomSource* self) @dynamic {
	return self.next(1) != 0;
}

fn float LegacyRandomSource.nextFloat(LegacyRandomSource* self) @dynamic {
	return (float)self.next(24) * BIT_RANDOM_SOURCE_FLOAT_MULTIPLIER;
}

fn double LegacyRandomSource.nextDouble(LegacyRandomSource* self) @dynamic {
	int i = self.next(26);
	int j = self.next(27);
	long l = ((long)i << 27) + (long)j;
	return (double)l * BIT_RANDOM_SOURCE_DOUBLE_MULTIPLIER;
}

fn int LegacyRandomSource.nextIntBetweenInclusive(LegacyRandomSource* self, int from, int to) @dynamic {
	return self.nextIntBounded(to - from + 1) + from;
}

<*
	@require from < to
*>
fn int LegacyRandomSource.nextInt_2(LegacyRandomSource* self, int from, int to) @dynamic {
	return from + self.nextIntBounded(to - from);
}

fn double LegacyRandomSource.triangle(LegacyRandomSource* self, double a, double b) @dynamic {
	return a + b * (self.nextDouble() - self.nextDouble());
}

fn void LegacyRandomSource.consumeCount(LegacyRandomSource* self, int value) @dynamic {
	for (int j = 0; j < value; j++)
	{
		self.nextInt();
	}
}

struct LegacyPositionalRandomFactory(PositionalRandomFactory) {
	long seed;
}

fn void LegacyPositionalRandomFactory.init(LegacyPositionalRandomFactory* self, long seed) {
	self.seed = seed;
}

fn RandomSource LegacyPositionalRandomFactory.at(LegacyPositionalRandomFactory* self, int x, int y, int z) @dynamic {
	long l = mth::getSeed(x, y, z);
	long m = l ^ self.seed;
	LegacyRandomSource* created = std::core::mem::alloc(LegacyRandomSource);
	created.init(m);
	return created;
}

fn RandomSource LegacyPositionalRandomFactory.fromHashOf(LegacyPositionalRandomFactory* self, String str) @dynamic {
	int i = mth::hashFromString(str);
	LegacyRandomSource* created = std::core::mem::alloc(LegacyRandomSource);
	created.init(i ^ self.seed);
	return created;
} 

fn RandomSource LegacyPositionalRandomFactory.fromSeed(LegacyPositionalRandomFactory* self, long seed) @dynamic {
	LegacyRandomSource* created = std::core::mem::alloc(LegacyRandomSource);
	created.init(seed);
	return created;
}

///////////////////////////////////////////
// 			XoroshiroRandomSource        //
///////////////////////////////////////////

struct Xoroshiro128PlusPlus {
	long seedLo;
	long seedHi;
}


fn void Xoroshiro128PlusPlus.init(Xoroshiro128PlusPlus* self, long seedLo, long seedHi) {
	self.seedLo = seedLo;
	self.seedHi = seedHi;

	if((self.seedLo | self.seedHi) == 0) {
		self.seedLo = random_support::GOLDEN_RATIO_64;
		self.seedHi = random_support::SILVER_RATIO_64;
	}
}

fn void Xoroshiro128PlusPlus.init2(Xoroshiro128PlusPlus* self, random_support::Seed128bit arg) {
	self.seedLo = arg.seedLo;
	self.seedHi = arg.seedHi;

	if((self.seedLo | self.seedHi) == 0) {
		self.seedLo = random_support::GOLDEN_RATIO_64;
		self.seedHi = random_support::SILVER_RATIO_64;
	}
}

fn void Xoroshiro128PlusPlus.delete(Xoroshiro128PlusPlus* self) {
	std::core::mem::free(self);
}

fn long Xoroshiro128PlusPlus.nextLong(Xoroshiro128PlusPlus* self) {
	long l = self.seedLo;
	long m = self.seedHi;
	long n = mth::long_rotateLeft(l + m, 17) + l;
	m ^= l;
	self.seedLo = mth::long_rotateLeft(l, 49) ^ m ^ m << 21;
	self.seedHi = mth::long_rotateLeft(m, 28);
	return n;
}

const float XOROSHIRO_RANDOM_SOURCE_FLOAT_UNIT = 5.9604645E-8F;
const float XOROSHIRO_RANDOM_SOURCE_DOUBLE_UNIT = 1.110223E-16;

struct XoroshiroRandomSource(RandomSource) {
	Xoroshiro128PlusPlus* randomNumberGenerator;
	MarsagliaPolarGaussian* gaussianSource;
}

fn void XoroshiroRandomSource.init(XoroshiroRandomSource* self, long seed) {
	MarsagliaPolarGaussian* created = std::core::mem::alloc(MarsagliaPolarGaussian);
	created.init(self);
	self.gaussianSource = created;

	self.randomNumberGenerator = std::core::mem::alloc(Xoroshiro128PlusPlus);
	self.randomNumberGenerator.init2(random_support::upgradeSeedTo128bit(seed));
}

fn void XoroshiroRandomSource.init2(XoroshiroRandomSource* self, random_support::Seed128bit arg) {
	MarsagliaPolarGaussian* created = std::core::mem::alloc(MarsagliaPolarGaussian);
	created.init(self);
	self.gaussianSource = created;

	self.randomNumberGenerator = std::core::mem::alloc(Xoroshiro128PlusPlus);
	self.randomNumberGenerator.init2(arg);
}

fn void XoroshiroRandomSource.init3(XoroshiroRandomSource* self, long seedLo, long seedHi) {
	MarsagliaPolarGaussian* created = std::core::mem::alloc(MarsagliaPolarGaussian);
	created.init(self);
	self.gaussianSource = created;

	self.randomNumberGenerator = std::core::mem::alloc(Xoroshiro128PlusPlus);
	self.randomNumberGenerator.init(seedLo, seedHi);
}

fn void XoroshiroRandomSource.delete(XoroshiroRandomSource* self) @dynamic {

	if(self.gaussianSource != null) {
		self.gaussianSource.delete();
		self.gaussianSource = null;
	}

	if(self.randomNumberGenerator != null) {
		self.randomNumberGenerator.delete();
		self.randomNumberGenerator = null;
	}

	std::core::mem::free(self);
}

fn RandomSource XoroshiroRandomSource.fork(XoroshiroRandomSource* self) @dynamic {
	XoroshiroRandomSource* random = std::core::mem::alloc(XoroshiroRandomSource);
	random.init(self.nextLong());
	return random;
}

fn PositionalRandomFactory XoroshiroRandomSource.forkPositional(XoroshiroRandomSource* self) @dynamic {
	XoroshiroPositionalRandomFactory* random = std::core::mem::alloc(XoroshiroPositionalRandomFactory);
	random.init(self.randomNumberGenerator.nextLong(), self.randomNumberGenerator.nextLong());
	return random;
}

fn void XoroshiroRandomSource.setSeed(XoroshiroRandomSource* self, long seed) @dynamic {
	
	random_support::Seed128bit bit = random_support::upgradeSeedTo128bit(seed);

	Xoroshiro128PlusPlus* data = self.randomNumberGenerator;
	
	data.seedLo = bit.seedLo;
	data.seedHi = bit.seedHi;

	if((data.seedLo | data.seedHi) == 0) {
		data.seedLo = random_support::GOLDEN_RATIO_64;
		data.seedHi = random_support::SILVER_RATIO_64;
	}

	self.gaussianSource.reset();
} 

fn double XoroshiroRandomSource.nextGaussian(XoroshiroRandomSource* self) @dynamic {
	return self.gaussianSource.nextGaussian();
}
 
fn int XoroshiroRandomSource.nextInt(XoroshiroRandomSource* self) @dynamic {
    return (int)self.randomNumberGenerator.nextLong();
}

<*
	@require bound > 0
*>
fn int XoroshiroRandomSource.nextIntBounded(XoroshiroRandomSource* self, int bound = 32) @dynamic {
	long l = (long)(uint)self.nextInt();
    long m = l * (long)bound;
    long n = m & 0xFFFFFFFFL;
    
    if (n < (long)bound) {
        int j = (int)((uint)(~bound + 1) % (uint)bound);
        while (n < (long)j) {
            l = (long)(uint)self.nextInt();
            m = l * (long)bound;
            n = m & 0xFFFFFFFFL;
        }
    }
    
    return (int)(m >> 32);
}

fn long XoroshiroRandomSource.nextBits(XoroshiroRandomSource* self, int bits) {
	return (long)((ulong)self.randomNumberGenerator.nextLong() >> (64 - bits));
}
 
fn long XoroshiroRandomSource.nextLong(XoroshiroRandomSource* self) @dynamic {
	return self.randomNumberGenerator.nextLong();
}

fn bool XoroshiroRandomSource.nextBoolean(XoroshiroRandomSource* self) @dynamic {
	return (self.randomNumberGenerator.nextLong() & 1) != 0;
}

fn float XoroshiroRandomSource.nextFloat(XoroshiroRandomSource* self) @dynamic {
	return self.nextBits(24) * XOROSHIRO_RANDOM_SOURCE_FLOAT_UNIT;
}

fn double XoroshiroRandomSource.nextDouble(XoroshiroRandomSource* self) @dynamic {
	return (double)(self.nextBits(53) * XOROSHIRO_RANDOM_SOURCE_DOUBLE_UNIT);
}

fn int XoroshiroRandomSource.nextIntBetweenInclusive(XoroshiroRandomSource* self, int from, int to) @dynamic {
	return self.nextIntBounded(to - from + 1) + from;
}

<*
	@require from < to
*>
fn int XoroshiroRandomSource.nextInt_2(XoroshiroRandomSource* self, int from, int to) @dynamic {
	return from + self.nextIntBounded(to - from);
}

fn double XoroshiroRandomSource.triangle(XoroshiroRandomSource* self, double a, double b) @dynamic {
	return a + b * (self.nextDouble() - self.nextDouble());
}

fn void XoroshiroRandomSource.consumeCount(XoroshiroRandomSource* self, int value) @dynamic {
	for (int j = 0; j < value; j++)
	{
		self.randomNumberGenerator.nextLong();
	}
}

struct XoroshiroPositionalRandomFactory(PositionalRandomFactory) {
	long seedLo;
	long seedHi;
}

fn void XoroshiroPositionalRandomFactory.init(XoroshiroPositionalRandomFactory* self, long seedLo, long seedHi) {
	self.seedLo = seedLo;
	self.seedHi = seedHi;
}

fn void XoroshiroPositionalRandomFactory.delete(XoroshiroPositionalRandomFactory* self) {
	std::core::mem::free(self);
}

fn RandomSource XoroshiroPositionalRandomFactory.at(XoroshiroPositionalRandomFactory* self, int x, int y, int z) @dynamic {
	long l = mth::getSeed(x, y, z);
	long m = l ^ self.seedLo;
	XoroshiroRandomSource* create = std::core::mem::alloc(XoroshiroRandomSource);
	create.init3(l, m);
	return create;
}

fn RandomSource XoroshiroPositionalRandomFactory.fromHashOf(XoroshiroPositionalRandomFactory* self, String str) @dynamic {
	XoroshiroRandomSource* create = std::core::mem::alloc(XoroshiroRandomSource);
	create.init2(random_support::seedFromHashOf(str).xor(self.seedLo, self.seedHi));
	return create;
}

fn RandomSource XoroshiroPositionalRandomFactory.fromSeed(XoroshiroPositionalRandomFactory* self, long seed) @dynamic {
	XoroshiroRandomSource* create = std::core::mem::alloc(XoroshiroRandomSource);
	create.init3(seed ^ self.seedLo, seed ^ self.seedHi);
	return create;
}