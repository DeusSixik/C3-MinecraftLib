module c3_minecraft;

import minecraft::random;
import std;
import std::io;
import jni;

fn long legacyRandomTestCreate(jni::JNIEnv env_ptr, jni::Jobject obj, long seed) 
	@export("Java_dev_sixik_NativeTests_legacyRandomCreate") 
{	
	random::RandomWrapper* wrapper = std::core::mem::alloc(RandomWrapper);
	wrapper.random = random::create(seed);
	return (long) wrapper;
}

fn int legacyRandomTestNextInt(jni::JNIEnv env_ptr, jni::Jobject obj, long randomPtr)
	@export("Java_dev_sixik_NativeTests_legacyRandomNextInt") 
{
	if(randomPtr == 0) return -1;

	random::RandomWrapper* wrapper = (random::RandomWrapper*)randomPtr;
	return wrapper.random.nextInt();
}

fn void legacyRandomTestDelete(jni::JNIEnv env_ptr, jni::Jobject obj, long randomPtr) 
	@export("Java_dev_sixik_NativeTests_legacyRandomFree") 
{
	if(randomPtr == 0) return;

	random::RandomWrapper* wrapper = (random::RandomWrapper*)randomPtr;
	wrapper.delete(true);
}

fn int main(String[] args)
{

	io::printfn("Hello world!");
    return 0;
}
