module mc_export::noise;

import jni;
import minecraft::noise;
import minecraft::random;

fn long createNormalNoise(
    jni::JNIEnv env_ptr, jni::Jobject obj,
    long random_ptr, int firstOctave, jni::JdoubleArray amplitudes
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeNormalNoise_create")
{
    jni::Jni jni = { env_ptr, *env_ptr };

    int len = jni.getArrayLength(amplitudes);
    if (len <= 0 || len > 32) { return 0; }

    bool is_copy = false;
    double* elems = (double*)jni.getPrimitiveArrayCritical(amplitudes, &is_copy);
    if (elems == null) { return 0; }

    noise::NoiseParameters params;
    params.firstOctave = firstOctave;
    params.amplitudes = elems[0:len]; 
    random::RandomWrapper* wrapper = (random::RandomWrapper*)random_ptr;

    noise::NormalNoise* result = mem::alloc(noise::NormalNoise);
    result.init(wrapper.random, params, true);

    jni.releasePrimitiveArrayCritical(amplitudes, elems, jni::JNI_ABORT);
    return (long)result;
}

fn double getValue(
	jni::JNIEnv env, jni::Jobject obj, 
	long noise_ptr, double x, double y, double z
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeNormalNoise_getValue")
{
	return ((noise::NormalNoise*)noise_ptr).getValue(x, y, z);
}

fn void deleteNoise(
	jni::JNIEnv env, jni::Jobject obj,
	long noise_ptr 
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeNormalNoise_deleteNoise")
{
	if (noise_ptr == 0) return; 
    ((noise::NormalNoise*)noise_ptr).delete();
}