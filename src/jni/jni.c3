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
alias GetArrayLengthFunc = fn Jsize(JNIEnv, Jobject);
alias GetDoubleArrayRegionFunc = fn void(JNIEnv, Jobject, Jsize, Jsize, double*);

struct JNINativeInterface {
    void* reserved0;
    void* reserved1;
    void* reserved2;
    void* reserved3;

    GetVersionFunc getVersion;
    DefineClassFunc defineClass;
    FindClassFunc findClass;

    // 164 отступа между findClass (индекс 6) и getArrayLength (индекс 171)
    void*[164] _padding1_a; 

    GetArrayLengthFunc getArrayLength;

    // 18 отступов между getArrayLength и getDoubleArrayElements (индекс 190)
    void*[18] _padding1_b; 

    GetDoubleArrayElementsFunc getDoubleArrayElements;

    void*[7] _padding2;
    ReleaseDoubleArrayElementsFunc releaseDoubleArrayElements;

	void*[7] _padding3;

	GetDoubleArrayRegionFunc getDoubleArrayRegion;
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

// fn Jsize JNINativeInterface.getArrayLength(JNINativeInterface* self, Jobject array) {
//     return self.getArrayLength2((JNIEnv)&self, array);
// }
