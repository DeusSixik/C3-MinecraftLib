module hashing;

fn long stringToSeed(char[] input) {
    ulong hash = 0xCBF29CE484222325uL; 
    for (int i = 0; i < input.len; i++) {
        hash ^= (ulong)input[i];
        hash *= 0x100000001B3uL;     
    }
    return (long)hash;
}