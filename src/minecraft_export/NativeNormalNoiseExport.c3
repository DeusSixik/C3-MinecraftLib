module minecraft::export::normal_noise;

import java;
import std::io;
import minecraft::random;
import minecraft::noise;

fn long create(
    jni::JNIEnv env, jni::Jobject obj, 
    long random_ptr, int firstOctave, jni::Jobject amplitudes
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeNormalNoise_create")
{
	jni::JNINativeInterface* jni = *env;
    
    int len = jni.getArrayLength(env, amplitudes);
    
    // Защита: отсекаем пустые или слишком огромные массивы
    if (len <= 0 || len > 32) { 
        return 0; 
    }
    
    // 1. Создаем локальный буфер прямо в памяти функции (без mem::alloc!)
    double[32] local_amps;
    
    // 2. Копируем данные напрямую из Java в наш стек
    // Явно приводим &local_amps к double*, чтобы компилятор не ругался
    jni.getDoubleArrayRegion(env, amplitudes, 0, len, (double*)&local_amps);
    
    // 3. Каст рандома
    random::LegacyRandomSource* lrs = (random::LegacyRandomSource*)random_ptr;
    random::RandomSource rs = (random::RandomSource)lrs; 

    // 4. Передаем в генератор только ту часть массива, в которой есть данные (слайс [0..len])
    long result = (long) noise::createNormalNoiseFromSlice(rs, firstOctave, local_amps[0..len]);
    
    return result;
}

fn double getValue(
	jni::JNIEnv env, jni::Jobject obj, 
	long noise_ptr, double x, double y, double z
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeNormalNoise_getValue")
{
	noise::NormalNoise* noise = (noise::NormalNoise*)noise_ptr;
	return noise.getValue(x, y, z);
}

fn void free(jni::JNIEnv env, jni::Jobject obj, long ptr) 
    @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeNormalNoise_free")
{
    // Броня от падений
    if (ptr == 0) return; 

    noise::NormalNoise* noise = (noise::NormalNoise*)ptr;
    noise.free();
    mem::free(noise);
}