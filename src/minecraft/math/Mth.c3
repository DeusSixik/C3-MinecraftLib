module minecraft::mth;

import std::hash::md5;
import std;

struct HashedString {
    String str;
    int hash;
    bool hash_is_zero;
}

fn void HashedString.init(HashedString* self, String str) {
	self.str = str;
	self.hashCode();
}

fn int HashedString.hashCode(HashedString* self) {
    int h = self.hash;
    if (h == 0 && !self.hash_is_zero) {
        foreach (c : self.str) {
            h = h * 31 + (int)c;
        }
        if (h == 0) {
            self.hash_is_zero = true;
        } else {
            self.hash = h;
        }
    }
    return h;
}

fn int hashFromString(String str) {
    int h = 0;
    foreach (c : str) {
        h = h * 31 + (int)c;
    }
    return h;
}

fn double square(double value) @inline {
	return value * value;
}

fn long getSeed(int i, int j, int k) @inline {
	long l = (long)(i * 3129871) ^ (long)k * 116129781L ^ (long)j;
	l = l * l * 42317861L + l * 11L;
	return l >> 16;
}

fn long atomicUpdateAndGet(Atomic{long} a, long multiplier, long addend, long mask) {
    long old_val;
    long new_val;
    do {
        old_val = a.load();
        new_val = (old_val * multiplier + addend) & mask;
    } while (mem::compare_exchange(&a.data, old_val, new_val, SEQ_CONSISTENT, SEQ_CONSISTENT) != old_val);
    return new_val;
}

fn long long_rotateLeft(long i, int distance) @inline {
    int shift = distance & 63;
    int inv_shift = (-distance) & 63;
    
    return (i << shift) | ((long)((ulong)i >> inv_shift));
}