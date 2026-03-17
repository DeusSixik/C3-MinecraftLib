module c3_minecraft;
import std::io;
import minecraft::random;
import minecraft::noise;

fn int main(String[] args)
{
	random::SimpleRandom* randomSource = mem::alloc(random::SimpleRandom);
	randomSource.initAuto();

	

	long noise = noise::createImprovedNoisePtr(randomSource);

	io::printfn("Noise value at (%d)", noise);

	noise::freeImprovedNoisePtr(noise);

	noise::ImprovedNoise* noiseSource = noise::getImprovedNoiseFromPtr(noise);
	io::printn(noiseSource.noise(0, 1, 2));
	return 0;
}
