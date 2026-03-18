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

 // 1. Создание генератора
fn long createNormalNoise(void* env, void* clazz, long seed)
    @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeTests_createNormalNoise")
{
    // Создаем генератор чисел
    random::LegacyRandomSource* randomSource = mem::alloc(random::LegacyRandomSource);
    randomSource.init(seed);

    // Создаем NormalNoise (7 октав)
    double[7] amps = { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 }; 
    noise::NormalNoise* normalNoise = noise::createNormalNoiseFromSlice(randomSource, -7, &amps);
    
    // Рандом больше не нужен, NormalNoise уже всё сгенерировал внутри себя
    mem::free(randomSource);

    // Возвращаем указатель в Java
    return (long)normalNoise;
}

// 2. Генерация карты внутри C3
fn double generateMap(void* env, void* clazz, long noisePtr, int size)
    @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeTests_generateMap")
{
    noise::NormalNoise* normalNoise = (noise::NormalNoise*)noisePtr;
    
    double sum = 0.0;
    double scale = 0.01;

    for (int x = 0; x < size; x++) {
        for (int z = 0; z < size; z++) {
            // Вызываем C3 метод без оверхеда JNI
            double val = normalNoise.getValue((double)x * scale, 0.0, (double)z * scale);
            sum += val;
        }
    }
    return sum;
}

// 3. Очистка памяти
fn void freeNormalNoise(void* env, void* clazz, long noisePtr)
    @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeTests_freeNormalNoise")
{
    noise::NormalNoise* normalNoise = (noise::NormalNoise*)noisePtr;
    normalNoise.free();
    mem::free(normalNoise);
}