module minecraft::export::utils;

fn void freeMemory(void* env, void* clazz, long ptr)
	@export("Java_dev_sixik_generator_1accelerator_math_c3_NativeUtils_freeMemory")
{
	mem::free((void*)ptr);
}