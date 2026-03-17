module c3_minecraft;
import std::io;
import minecraft::random;
import minecraft::noise;

fn int main(String[] args)
{
    random::LegacyRandomSource* randomSource = mem::alloc(random::LegacyRandomSource);
    randomSource.init(255);

    noise::PerlinNoise* perlin = noise::createLegacyForBlendedNoise(randomSource, -15, 0);

    io::printn("--- Testing PerlinNoise (Octaves -15 to 0) ---");

    for (int z = 0; z < 5; z++) {
        for (int x = 0; x < 5; x++) {
            double scale = 0.5;
            double noiseValue = perlin.getValue((double)x * scale, 0, (double)z * scale);
            
            io::printf("%7.4f ", noiseValue);
        }
        io::printn(); 
    }

    io::printn("----------------------------------------------");

    perlin.free();
    mem::free(perlin);
    mem::free(randomSource);

    return 0;
}
