module minecraft::export::tests;

import java;
import std::io;
import minecraft::random;
import minecraft::noise;

fn void testLegacyRandomSource(jni::JNIEnv env, jni::Jobject obj, long seed)
	@export("Java_dev_sixik_generator_1accelerator_math_c3_NativeTests_blendedNoise")
 {
	random::LegacyRandomSource* randomSource = mem::alloc(random::LegacyRandomSource);
    randomSource.init(seed);

    // Параметры для стандартного BlendedNoise в Minecraft
    // (scale: 0.1, 0.1, фактор: 80.0, 160.0, smear: 8.0)
    noise::BlendedNoise* blended = noise::createBlendedNoise(randomSource, 0.1, 0.1, 80.0, 160.0, 8.0);

    io::printn("--- BlendedNoise Generation ---");

    // Вычислим шум для столбца блоков от Y = 0 до Y = 10
    for (int y = 0; y <= 10; y++) {
        double val = blended.compute(0, y, 0);
        io::printfn("Block (0, %d, 0) density: %.5f", y, val);
    }

    // Чистим память!
    blended.free();
    mem::free(blended);
    mem::free(randomSource);
 }