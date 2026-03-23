module minecraft::random_support;

import minecraft::mth;
import std;

import std::hash::md5;

const long GOLDEN_RATIO_64 = -7046029254386353131L;
const long SILVER_RATIO_64 = 7640891576956012809L;

const Atomic {long} SEED_UNIQUIFIER = {
	.data = 8682522807148012
};

fn long mixStafford13(long seed) @inline {
	seed = (seed ^ (long)((ulong)seed >> 30)) * -4658895280553007687L;
	seed = (seed ^ (long)((ulong)seed >> 27)) * -7723592293110705685L;
	return seed ^ (long)((ulong)seed >> 31);
}

fn Seed128bit upgradeSeedTo128bitUnmixed(long seed) @inline {
	long m = seed ^ SILVER_RATIO_64;
	long n = m + GOLDEN_RATIO_64;
	return {
		.seedLo = m,
		.seedHi = n
	};
}

fn Seed128bit upgradeSeedTo128bit(long seed) {
	return upgradeSeedTo128bitUnmixed(seed).mixed();
}

fn Seed128bit seedFromHashOf(String str) {
    char[16] bs = md5::hash((char[])str);
    
    long seedLo = ((long)bs[0]  << 56) |
             	  ((long)bs[1]  << 48) |
             	  ((long)bs[2]  << 40) |
             	  ((long)bs[3]  << 32) |
             	  ((long)bs[4]  << 24) |
             	  ((long)bs[5]  << 16) |
             	  ((long)bs[6]  <<  8) |
             	  ((long)bs[7]);

    long seedHi = ((long)bs[8]  << 56) |
             	  ((long)bs[9]  << 48) |
             	  ((long)bs[10] << 40) |
             	  ((long)bs[11] << 32) |
             	  ((long)bs[12] << 24) |
             	  ((long)bs[13] << 16) |
             	  ((long)bs[14] <<  8) |
             	  ((long)bs[15]);

    return { .seedLo = seedLo, .seedHi = seedHi };
}

fn long generateUniqueSeed() {
	return mth::atomicUpdateAndGet(SEED_UNIQUIFIER, 1181783497276652981L, 0, (long) (ulong) std::time::clock::now());
}

struct Seed128bit {
	long seedLo;
	long seedHi;
}

fn Seed128bit Seed128bit.xor(Seed128bit* self, long seedLo, long seedHi) {
	return {
		.seedLo = self.seedLo ^ seedLo,
		.seedHi = self.seedHi ^ seedHi
	};
}

fn Seed128bit Seed128bit.xorOther(Seed128bit* self, Seed128bit other) {
	return self.xor(other.seedLo, other.seedHi);
}

fn Seed128bit Seed128bit.mixed(Seed128bit* self) {
	return {
		.seedLo = mixStafford13(self.seedLo),
		.seedHi = mixStafford13(self.seedHi)
	};
}