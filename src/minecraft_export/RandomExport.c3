module minecraft::export::random;

import java;
import minecraft::random;

fn long createLegacyRandomSource(jni::JNIEnv env, jni::Jobject obj, long seed)
	@export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_createLegacyRandomSource")
 {
	random::LegacyRandomSource* randomSource = mem::alloc(random::LegacyRandomSource);
	randomSource.init(seed);
	return (long)randomSource;
}

fn long createLegacyRandomSourceAuto(jni::JNIEnv env, jni::Jobject obj)
	@export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_createLegacyRandomSourceAuto")
 {
	random::LegacyRandomSource* randomSource = mem::alloc(random::LegacyRandomSource);
	randomSource.initAuto();
	return (long)randomSource;
}

fn void destroyLegacyRandomSource(jni::JNIEnv env, jni::Jobject obj, long ptr)
	@export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_destroyLegacyRandomSource")
{
	if(ptr != 0) {
		random::LegacyRandomSource* randomSource = (random::LegacyRandomSource*)ptr;
		if(randomSource != null) {
			randomSource.free();
			mem::free(randomSource);
		}
	}
}

fn void setSeedLegacyRandomSource(jni::JNIEnv env, jni::Jobject obj, long ptr, long seed)
	@export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_setSeedLegacyRandomSource")
{
	random::LegacyRandomSource* randomSource = (random::LegacyRandomSource*)ptr;
	randomSource.setSeed(seed);
}