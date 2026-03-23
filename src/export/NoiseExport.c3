module mc_export::noise;

import jni;
import minecraft::noise;
import minecraft::random;

fn long createNormalNoise(
    jni::JNIEnv env_ptr, jni::Jobject obj,
    long random_ptr, int firstOctave, jni::JdoubleArray amplitudes
) @export("Java_dev_sixik_NativeTests_createNormalNoise")
{
    jni::Jni jni = { env_ptr, *env_ptr };

    int len = jni.getArrayLength(amplitudes);
    if (len <= 0 || len > 32) { return 0; }

    jni::Jdouble* elems = jni.getDoubleArrayElements(amplitudes, null);
    if (elems == null) { return 0; }

    double[] slice = elems[0:len];

    random::RandomWrapper* wrapper = (random::RandomWrapper*)random_ptr;
    long noisePtr = (long)noise::createNormalNoiseFromSlice(wrapper.random, firstOctave, slice);

    jni.releaseDoubleArrayElements(amplitudes, elems, jni::JNI_ABORT);

    return noisePtr;
}

fn double getValue(
	jni::JNIEnv env, jni::Jobject obj, 
	long noise_ptr, double x, double y, double z
) @export("Java_dev_sixik_NativeTests_getValue")
{
	return ((noise::NormalNoise*)noise_ptr).getValue(x, y, z);
}

fn void free(
	jni::JNIEnv env, jni::Jobject obj,
	long noise_ptr 
) @export("Java_dev_sixik_NativeTests_deleteNoise")
{
	if (noise_ptr == 0) return; 
    ((noise::NormalNoise*)noise_ptr).delete();
}