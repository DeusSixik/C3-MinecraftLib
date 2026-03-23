module mc_export::random;

import jni;
import minecraft::noise;
import minecraft::random;

fn long create(
	jni::JNIEnv env, jni::Jobject obj, long seed, int type, bool isDefault
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_create")
{
	random::RandomWrapper* wrapper = std::core::mem::alloc(random::RandomWrapper);
	
	switch(type) {
		case 0: {
			if(isDefault) {
				wrapper.random = random::createUnique();
			} else {
				wrapper.random = minecraft::random::create(seed);
			}
		}
		case 1: {
			XoroshiroRandomSource* created = std::core::mem::alloc(XoroshiroRandomSource);
			created.init(seed);
			wrapper.random = created;
		}
	}

	return (long) wrapper;
}

fn void delete(
	jni::JNIEnv env, jni::Jobject obj, long random_ptr
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_delete") 
{
	if(random_ptr == 0) return;
	((random::RandomWrapper*) random_ptr).delete(true);
}

fn int nextInt(
	jni::JNIEnv env, jni::Jobject obj, long random_ptr, int bound, int type
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_nextIntN") {
	if(type == 0) {
		return ((random::RandomWrapper*) random_ptr).random.nextInt();
	}

	return ((random::RandomWrapper*) random_ptr).random.nextIntBounded(bound);
}

fn int nextInt_2(
	jni::JNIEnv env, jni::Jobject obj, long random_ptr, int from, int to
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_nextIntBound") {
	return ((random::RandomWrapper*) random_ptr).random.nextInt_2(from, to);
}

fn int nextIntBetweenInclusive(
	jni::JNIEnv env, jni::Jobject obj, long random_ptr, int from, int to
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_nextIntBetweenInclusive") {
	return ((random::RandomWrapper*) random_ptr).random.nextIntBetweenInclusive(from, to);
}

fn long nextLong(
	jni::JNIEnv env, jni::Jobject obj, long random_ptr
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_nextLong") {
	return ((random::RandomWrapper*) random_ptr).random.nextLong();
}

fn bool nextBoolean(
	jni::JNIEnv env, jni::Jobject obj, long random_ptr
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_nextBoolean") {
	return ((random::RandomWrapper*) random_ptr).random.nextBoolean();
}

fn float nextFloat(
	jni::JNIEnv env, jni::Jobject obj, long random_ptr
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_nextFloat") {
	return ((random::RandomWrapper*) random_ptr).random.nextFloat();
}

fn double nextDouble(
	jni::JNIEnv env, jni::Jobject obj, long random_ptr
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_nextDouble") {
	return ((random::RandomWrapper*) random_ptr).random.nextDouble();
}

fn double nextGaussian(
	jni::JNIEnv env, jni::Jobject obj, long random_ptr
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_nextGaussian") {
	return ((random::RandomWrapper*) random_ptr).random.nextGaussian();
}

fn int nextIntDirect(
    jni::JNIEnv env, jni::Jobject obj, long random_ptr
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeRandom_nextIntDirect") {
    random::RandomWrapper* wrapper = (random::RandomWrapper*)random_ptr;
    // достаём XoroshiroRandomSource напрямую минуя интерфейс
    random::XoroshiroRandomSource* xoro = (random::XoroshiroRandomSource*)wrapper.random.ptr;
    return xoro.nextInt();
}