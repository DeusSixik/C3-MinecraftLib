module java::jni;

alias Jint = int;
alias Jsize = int;
alias Jbyte = char;
alias Jclass = void*;
alias Jobject = void*;
alias Jboolean = bool;

alias JNIEnv = JNINativeInterface**;

alias GetVersionFunc = fn Jint(JNIEnv);
alias DefineClassFunc = fn Jclass(JNIEnv, char*, Jobject, Jbyte*, Jsize);
alias FindClassFunc = fn Jclass(JNIEnv, char*);
alias GetDoubleArrayElementsFunc = fn double*(JNIEnv, Jobject, Jboolean*);
alias ReleaseDoubleArrayElementsFunc = fn void(JNIEnv, Jobject, double*, Jint);
alias GetDirectBufferAddressFunc = fn void*(JNIEnv, Jobject);

struct JNINativeInterface {
    void* reserved0;
    void* reserved1;
    void* reserved2;
    void* reserved3;

    GetVersionFunc getVersion;
    DefineClassFunc defineClass;
    FindClassFunc findClass;

	void*[183] _padding1;

	GetDoubleArrayElementsFunc getDoubleArrayElements;

	void*[7] _padding2;
    ReleaseDoubleArrayElementsFunc releaseDoubleArrayElements;
    
    GetDirectBufferAddressFunc getDirectBufferAddress;
}

fn Jint JNINativeInterface.getVersion2(JNINativeInterface* self) {
    return self.getVersion((JNIEnv)&self);
}

fn Jclass JNINativeInterface.findClass2(JNINativeInterface* self, char* name) {
    return self.findClass((JNIEnv)&self, name);
}

fn double* JNINativeInterface.getDoubleArray(JNINativeInterface* self, Jobject array) {
    return self.getDoubleArrayElements((JNIEnv)&self, array, null);
}

fn void JNINativeInterface.releaseDoubleArray(JNINativeInterface* self, Jobject array, double* elems) {
    // 0 = скопировать данные обратно в Java и освободить память
    self.releaseDoubleArrayElements((JNIEnv)&self, array, elems, 0);
}

