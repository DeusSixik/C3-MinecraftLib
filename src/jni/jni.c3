module jni;

// Default JNI types and structures

alias Jint = int;
alias Jsize = int;
alias Jbyte = char;
alias Jchar = ushort;
alias Jshort = short;
alias Jlong = long;
alias Jfloat = float;
alias Jdouble = double;
alias Jboolean = bool;

alias Jobject = void*;
alias Jclass = Jobject;
alias Jthrowable = Jobject;
alias Jstring = Jobject;
alias Jarray = Jobject;
alias Jweak = Jobject;

alias JbooleanArray = Jarray;
alias JbyteArray = Jarray;
alias JcharArray = Jarray;
alias JshortArray = Jarray;
alias JintArray = Jarray;
alias JlongArray = Jarray;
alias JfloatArray = Jarray;
alias JdoubleArray = Jarray;
alias JobjectArray = Jarray;

alias VaList = void*;

union JValue {
    bool 	z;     
    char 	b;     
    ushort 	c;   
    short 	s;    
    int 	i;      
    long 	j;     
    float 	f;    
    double 	d;   
    Jobject l;  
}

alias JfieldID = JJfieldID*;
alias JmethodID = JJmethodID*;

/* Return values from jobjectRefType */
enum JobjectType : int {
    JNI_INVALID_REF_TYPE,
    JNI_LOCAL_REF_TYPE,
    JNI_GLOBAL_REF_TYPE,
    JNI_WEAK_GLOBAL_REF_TYPE
}

/*
 * jboolean constants
 */
const char JNI_FALSE = 0;
const char JNI_TRUE = 1;


/*
 * possible return values for JNI functions.
 */
constdef JniResult : int {
    JNI_OK        = 0,    /* success */
    JNI_ERR       = -1,   /* unknown error */
    JNI_EDETACHED  = -2,  /* thread detached from the VM */
    JNI_EVERSION  = -3,   /* JNI version error */
    JNI_ENOMEM    = -4,   /* not enough memory */
    JNI_EEXIST    = -5,   /* VM already created */
    JNI_EINVAL    = -6    /* invalid arguments */
}

/*
 * used in ReleaseScalarArrayElements
 */
const char JNI_COMMIT = 1;
const char JNI_ABORT = 2;

/*
 * used in RegisterNatives to describe native method name, signature,
 * and function pointer.
 */

struct JNINativeMethod {
    char* name;      
    char* signature; 
    void* fnPtr;     
}

// Enum for JNI

alias JNIEnv = JNINativeInterface**;

// JNI structures

struct JJfieldID { char _unused; }
struct JJmethodID { char _unused; }

struct JJavaVM { char _unused; }
alias JavaVM = JJavaVM*;

struct Jni {
    JNIEnv env;
    JNINativeInterface* vtable;
}

struct JNINativeInterface {
    void* reserved0;
    void* reserved1;
    void* reserved2;
    void* reserved3;

	GetVersionFunc 						getVersionFn;
	DefineClassFunc 					defineClassFn;
	FindClassFunc 						findClassFn;
	FromReflectedMethodFunc 			fromReflectedMethodFn;
	FromReflectedFieldFunc 				fromReflectedFieldFn;
	ToReflectedMethodFunc 				toReflectedMethodFn;
	GetSuperclassFunc 					getSuperclassFn;
	IsAssignableFromFunc				isAssignableFromFn;
	ToReflectedFieldFunc				toReflectedFieldFn;
	ThrowFunc 							throwFn;
	ThrowNewFunc 						throwNewFn;
	ExceptionOccurredFunc 				exceptionOccurredFn;
	ExceptionDescribeFunc 				exceptionDescribeFn;
	ExceptionClearFunc 					exceptionClearFn;
	FatalErrorFunc 						fatalErrorFn;
	PushLocalFrameFunc 					pushLocalFrameFn;
	PopLocalFrameFunc 					popLocalFrameFn;
	NewGlobalRefFunc 					newGlobalRefFn;
	DeleteGlobalRefFunc 				deleteGlobalRefFn;
	DeleteLocalRefFunc					deleteLocalRefFn;
	IsSameObjectFunc 					isSameObjectFn;
	NewLocalRefFunc 					newLocalRefFn;
	EnsureLocalCapacityFunc 			ensureLocalCapacityFn;
	AllocObjectFunc 					allocObjectFn;
	void* space_1;
	NewObjectVFunc 						newObjectVFn;
	NewObjectAFunc 						newObjectAFn;
	GetObjectClassFunc 					getObjectClassFn;
	IsInstanceOfFunc 					isInstanceOfFn;
	GetMethodIDFunc 					getMethodIDFn;
	void* space_2;
	CallObjectMethodVFunc 				callObjectMethodVFn;
	CallObjectMethodAFunc 				callObjectMethodAFn;
	void* space_3;
	CallBooleanMethodVFunc 				callBooleanMethodVFn;
	CallBooleanMethodAFunc 				callBooleanMethodAFn;
	void* space_4;
	CallByteMethodVFunc 				callByteMethodVFn;
	CallByteMethodAFunc 				callByteMethodAFn;
	void* space_5;
	CallCharMethodVFunc 				callCharMethodVFn;
	CallCharMethodAFunc 				callCharMethodAFn;
	void* space_6;
	CallShortMethodVFunc 				callShortMethodVFn;
	CallShortMethodAFunc 				callShortMethodAFn;
	void* space_7;
	CallIntMethodVFunc 					callIntMethodVFn;
	CallIntMethodAFunc 					callIntMethodAFn;
	void* space_8;
	CallLongMethodVFunc 				callLongMethodVFn;
	CallLongMethodAFunc 				callLongMethodAFn;
	void* space_9;
	CallFloatMethodVFunc 				callFloatMethodVFn;
	CallFloatMethodAFunc 				callFloatMethodAFn;
	void* space_10;
	CallDoubleMethodVFunc 				callDoubleMethodVFn;
	CallDoubleMethodAFunc 				callDoubleMethodAFn;
	void* space_11;
	CallVoidMethodVFunc 				callVoidMethodVFn;
	CallVoidMethodAFunc 				callVoidMethodAFn;
	void* space_12;
	CallNonvirtualObjectMethodVFunc 	callNonvirtualObjectMethodVFn;
	CallNonvirtualObjectMethodAFunc 	callNonvirtualObjectMethodAFn;
	void* space_13;
	CallNonvirtualBooleanMethodVFunc 	callNonvirtualBooleanMethodVFn;
	CallNonvirtualBooleanMethodAFunc 	callNonvirtualBooleanMethodAFn;
	void* space_14;
	CallNonvirtualByteMethodVFunc		callNonvirtualByteMethodVFn;
	CallNonvirtualByteMethodAFunc		callNonvirtualByteMethodAFn;
	void* space_15;
	CallNonvirtualCharMethodVFunc 		callNonvirtualCharMethodVFn;
	CallNonvirtualCharMethodAFunc 		callNonvirtualCharMethodAFn;
	void* space_16;
	CallNonvirtualShortMethodVFunc 		callNonvirtualShortMethodVFn;
	CallNonvirtualShortMethodAFunc 		callNonvirtualShortMethodAFn;
	void* space_17;
	CallNonvirtualIntMethodVFunc 		callNonvirtualIntMethodVFn;
	CallNonvirtualIntMethodAFunc 		callNonvirtualIntMethodAFn;
	void* space_18;
	CallNonvirtualLongMethodVFunc 		callNonvirtualLongMethodVFn;
	CallNonvirtualLongMethodAFunc 		callNonvirtualLongMethodAFn;
	void* space_19;
	CallNonvirtualFloatMethodVFunc 		callNonvirtualFloatMethodVFn;
	CallNonvirtualFloatMethodAFunc 		callNonvirtualFloatMethodAFn;
	void* space_20;
	CallNonvirtualDoubleMethodVFunc 	callNonvirtualDoubleMethodVFn;
	CallNonvirtualDoubleMethodAFunc 	callNonvirtualDoubleMethodAFn;
	void* space_21;
	CallNonvirtualVoidMethodVFunc 		callNonvirtualVoidMethodVFn;
	CallNonvirtualVoidMethodAFunc 		callNonvirtualVoidMethodAFn;
	GetFieldIDFunc 						getFieldIDFn;
	GetObjectFieldFunc 					getObjectFieldFn;
	GetBooleanFieldFunc 				getBooleanFieldFn;
	GetByteFieldFunc 					getByteFieldFn;
	GetCharFieldFunc 					getCharFieldFn;
	GetShortFieldFunc 					getShortFieldFn;
	GetIntFieldFunc 					getIntFieldFn;
	GetLongFieldFunc 					getLongFieldFn;
	GetFloatFieldFunc 					getFloatFieldFn;
	GetDoubleFieldFunc 					getDoubleFieldFn;
	SetObjectFieldFunc 					setObjectFieldFn;
	SetBooleanFieldFunc 				setBooleanFieldFn;
	SetByteFieldFunc 					setByteFieldFn;
	SetCharFieldFunc 					setCharFieldFn;
	SetShortFieldFunc 					setShortFieldFn;
	SetIntFieldFunc 					setIntFieldFn;
	SetLongFieldFunc 					setLongFieldFn;
	SetFloatFieldFunc 					setFloatFieldFn;
	SetDoubleFieldFunc 					setDoubleFieldFn;
	GetStaticMethodIDFunc 				getStaticMethodIDFn;
	void* space_22;
	CallStaticObjectMethodVFunc 		callStaticObjectMethodVFn;
	CallStaticObjectMethodAFunc 		callStaticObjectMethodAFn;
	void* space_23;
	CallStaticBooleanMethodVFunc 		callStaticBooleanMethodVFn;
	CallStaticBooleanMethodAFunc 		callStaticBooleanMethodAFn;
	void* space_24;
	CallStaticByteMethodVFunc 			callStaticByteMethodVFn;
	CallStaticByteMethodAFunc 			callStaticByteMethodAFn;
	void* space_25;
	CallStaticCharMethodVFunc 			callStaticCharMethodVFn;
	CallStaticCharMethodAFunc 			callStaticCharMethodAFn;
	void* space_26;
	CallStaticShortMethodVFunc			callStaticShortMethodVFn;
	CallStaticShortMethodAFunc			callStaticShortMethodAFn;
	void* space_27;
	CallStaticIntMethodVFunc 			callStaticIntMethodVFn;
	CallStaticIntMethodAFunc 			callStaticIntMethodAFn;
	void* space_28;
	CallStaticLongMethodVFunc 			callStaticLongMethodVFn;
	CallStaticLongMethodAFunc 			callStaticLongMethodAFn;
	void* space_29;
	CallStaticFloatMethodVFunc 			callStaticFloatMethodVFn;
	CallStaticFloatMethodAFunc 			callStaticFloatMethodAFn;
	void* space_30;
	CallStaticDoubleMethodVFunc 		callStaticDoubleMethodVFn;
	CallStaticDoubleMethodAFunc 		callStaticDoubleMethodAFn;
	void* space_31;
	CallStaticVoidMethodVFunc 			callStaticVoidMethodVFn;
	CallStaticVoidMethodAFunc 			callStaticVoidMethodAFn;
	GetStaticFieldIDFunc 				getStaticFieldIDFn;
	GetStaticObjectFieldFunc 			getStaticObjectFieldFn;
	GetStaticBooleanFieldFunc 			getStaticBooleanFieldFn;
	GetStaticByteFieldFunc 				getStaticByteFieldFn;
	GetStaticCharFieldFunc 				getStaticCharFieldFn;
	GetStaticShortFieldFunc 			getStaticShortFieldFn;
	GetStaticIntFieldFunc 				getStaticIntFieldFn;
	GetStaticLongFieldFunc 				getStaticLongFieldFn;
	GetStaticFloatFieldFunc 			getStaticFloatFieldFn;
	GetStaticDoubleFieldFunc 			getStaticDoubleFieldFn;
	SetStaticObjectFieldFunc 			setStaticObjectFieldFn;
	SetStaticBooleanFieldFunc 			setStaticBooleanFieldFn;
	SetStaticByteFieldFunc 				setStaticByteFieldFn;
	SetStaticCharFieldFunc 				setStaticCharFieldFn;
	SetStaticShortFieldFunc 			setStaticShortFieldFn;
	SetStaticIntFieldFunc 				setStaticIntFieldFn;
	SetStaticLongFieldFunc 				setStaticLongFieldFn;
	SetStaticFloatFieldFunc 			setStaticFloatFieldFn;
	SetStaticDoubleFieldFunc 			setStaticDoubleFieldFn;
	NewStringFunc 						newStringFn;
	GetStringLengthFunc 				getStringLengthFn;
	GetStringCharsFunc 					getStringCharsFn;
	ReleaseStringCharsFunc 				releaseStringCharsFn;
	NewStringUTFFunc 					newStringUTFFn;
	GetStringUTFLengthFunc 				getStringUTFLengthFn;
	GetStringUTFCharsFunc 				getStringUTFCharsFn;
	ReleaseStringUTFCharsFunc 			releaseStringUTFCharsFn;
	GetArrayLengthFunc 					getArrayLengthFn;
	NewObjectArrayFunc 					newObjectArrayFn;
	GetObjectArrayElementFunc 			getObjectArrayElementFn;
	SetObjectArrayElementFunc 			setObjectArrayElementFn;
	NewBooleanArrayFunc 				newBooleanArrayFn;
	NewByteArrayFunc 					newByteArrayFn;
	NewCharArrayFunc 					newCharArrayFn;
	NewShortArrayFunc 					newShortArrayFn;
	NewIntArrayFunc 					newIntArrayFn;
	NewLongArrayFunc 					newLongArrayFn;
	NewFloatArrayFunc 					newFloatArrayFn;
	NewDoubleArrayFunc 					newDoubleArrayFn;
	GetBooleanArrayElementsFunc 		getBooleanArrayElementsFn;
	GetByteArrayElementsFunc 			getByteArrayElementsFn;
	GetCharArrayElementsFunc 			getCharArrayElementsFn;
	GetShortArrayElementsFunc 			getShortArrayElementsFn;
	GetIntArrayElementsFunc 			getIntArrayElementsFn;
	GetLongArrayElementsFunc 			getLongArrayElementsFn;
	GetFloatArrayElementsFunc 			getFloatArrayElementsFn;
	GetDoubleArrayElementsFunc 			getDoubleArrayElementsFn;
	ReleaseBooleanArrayElementsFunc 	releaseBooleanArrayElementsFn;
	ReleaseByteArrayElementsFunc 		releaseByteArrayElementsFn;
	ReleaseCharArrayElementsFunc 		releaseCharArrayElementsFn;
	ReleaseShortArrayElementsFunc 		releaseShortArrayElementsFn;
	ReleaseIntArrayElementsFunc 		releaseIntArrayElementsFn;
	ReleaseLongArrayElementsFunc 		releaseLongArrayElementsFn;
	ReleaseFloatArrayElementsFunc 		releaseFloatArrayElementsFn;
	ReleaseDoubleArrayElementsFunc 		releaseDoubleArrayElementsFn;
	GetBooleanArrayRegionFunc 			getBooleanArrayRegionFn;
	GetByteArrayRegionFunc				getByteArrayRegionFn;
	GetCharArrayRegionFunc				getCharArrayRegionFn;
	GetShortArrayRegionFunc				getShortArrayRegionFn;
	GetIntArrayRegionFunc 				getIntArrayRegionFn;
	GetLongArrayRegionFunc 				getLongArrayRegionFn;
	GetFloatArrayRegionFunc 			getFloatArrayRegionFn;
	GetDoubleArrayRegionFunc 			getDoubleArrayRegionFn;
	SetBooleanArrayRegionFunc 			setBooleanArrayRegionFn;
    SetByteArrayRegionFunc    			setByteArrayRegionFn;
    SetCharArrayRegionFunc    			setCharArrayRegionFn;
    SetShortArrayRegionFunc   			setShortArrayRegionFn;
    SetIntArrayRegionFunc     			setIntArrayRegionFn;
    SetLongArrayRegionFunc    			setLongArrayRegionFn;
    SetFloatArrayRegionFunc   			setFloatArrayRegionFn;
    SetDoubleArrayRegionFunc  			setDoubleArrayRegionFn;
	RegisterNativesFunc   				registerNativesFn;   
    UnregisterNativesFunc 				unregisterNativesFn; 
    MonitorEnterFunc      				monitorEnterFn;      
    MonitorExitFunc       				monitorExitFn;       
    GetJavaVMFunc         				getJavaVMFn;         
	GetStringRegionFunc               	getStringRegionFn;              
    GetStringUTFRegionFunc            	getStringUTFRegionFn;           
    GetPrimitiveArrayCriticalFunc     	getPrimitiveArrayCriticalFn;    
    ReleasePrimitiveArrayCriticalFunc 	releasePrimitiveArrayCriticalFn;
    GetStringCriticalFunc             	getStringCriticalFn;            
    ReleaseStringCriticalFunc         	releaseStringCriticalFn;        
	NewWeakGlobalRefFunc        		newWeakGlobalRefFn;        
    DeleteWeakGlobalRefFunc     		deleteWeakGlobalRefFn;     
    ExceptionCheckFunc          		exceptionCheckFn;          
    NewDirectByteBufferFunc     		newDirectByteBufferFn;     
    GetDirectBufferAddressFunc  		getDirectBufferAddressFn;  
    GetDirectBufferCapacityFunc 		getDirectBufferCapacityFn; 
	GetObjectRefTypeFunc 				getObjectRefTypeFn; 
    GetModuleFunc        				getModuleFn;        
    IsVirtualThreadFunc  				isVirtualThreadFn;  
}

// JNI Functions

alias GetVersionFunc 					= fn Jint(JNIEnv);
alias DefineClassFunc 					= fn Jclass(JNIEnv, char* name, Jclass loader, Jbyte* buf, Jsize len);
alias FindClassFunc 					= fn Jclass(JNIEnv, char* name);
alias FromReflectedMethodFunc 			= fn JmethodID(JNIEnv, Jobject method);
alias FromReflectedFieldFunc 			= fn JfieldID(JNIEnv, Jobject field);
alias ToReflectedMethodFunc 			= fn Jobject(JNIEnv, Jclass cls, JmethodID methodID, Jboolean isStatic);
alias GetSuperclassFunc 				= fn Jclass(JNIEnv, Jclass sub);
alias IsAssignableFromFunc 				= fn Jboolean(JNIEnv, Jclass sub, Jclass sup);
alias ToReflectedFieldFunc 				= fn Jobject(JNIEnv, Jclass cls, JfieldID fieldID, Jboolean isStatic);
alias ThrowFunc 						= fn Jint(JNIEnv, Jthrowable obj);
alias ThrowNewFunc 						= fn Jint(JNIEnv, char* className, char* message);
alias ExceptionOccurredFunc 			= fn Jthrowable(JNIEnv);
alias ExceptionDescribeFunc 			= fn void(JNIEnv);
alias ExceptionClearFunc 				= fn void(JNIEnv);
alias FatalErrorFunc 					= fn void(JNIEnv, char* msg);
alias PushLocalFrameFunc 				= fn Jint(JNIEnv, Jint capacity);
alias PopLocalFrameFunc 				= fn Jobject(JNIEnv, Jobject result);
alias NewGlobalRefFunc 					= fn Jobject(JNIEnv, Jobject obj);
alias DeleteGlobalRefFunc 				= fn void(JNIEnv, Jobject globalRef);
alias DeleteLocalRefFunc 				= fn void(JNIEnv, Jobject localRef);
alias IsSameObjectFunc 					= fn Jboolean(JNIEnv, Jobject ref1, Jobject ref2);
alias NewLocalRefFunc 					= fn Jobject(JNIEnv, Jobject ref);
alias EnsureLocalCapacityFunc 			= fn Jint(JNIEnv, Jint capacity);
alias AllocObjectFunc 					= fn Jobject(JNIEnv, Jclass cls);
alias NewObjectVFunc 					= fn Jobject(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias NewObjectAFunc 					= fn Jobject(JNIEnv, Jclass cls, JmethodID method, JValue* args);
alias GetObjectClassFunc 				= fn Jclass(JNIEnv, Jobject obj);
alias IsInstanceOfFunc 					= fn Jboolean(JNIEnv, Jobject obj, Jclass cls);
alias GetMethodIDFunc 					= fn JmethodID(JNIEnv, Jclass cls, char* name, char* sig);
alias CallObjectMethodVFunc 			= fn Jobject(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallObjectMethodAFunc 			= fn Jobject(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallBooleanMethodVFunc 			= fn Jboolean(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallBooleanMethodAFunc 			= fn Jboolean(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallByteMethodVFunc 				= fn Jbyte(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallByteMethodAFunc 				= fn Jbyte(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallCharMethodVFunc 				= fn Jchar(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallCharMethodAFunc 				= fn Jchar(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallShortMethodVFunc 				= fn Jshort(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallShortMethodAFunc 				= fn Jshort(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallIntMethodVFunc 				= fn Jint(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallIntMethodAFunc 				= fn Jint(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallLongMethodVFunc 				= fn Jlong(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallLongMethodAFunc 				= fn Jlong(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallFloatMethodVFunc 				= fn Jfloat(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallFloatMethodAFunc 				= fn Jfloat(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallDoubleMethodVFunc 			= fn Jdouble(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallDoubleMethodAFunc 			= fn Jdouble(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallVoidMethodVFunc 				= fn void(JNIEnv, Jobject obj, JmethodID methodID, VaList args);
alias CallVoidMethodAFunc 				= fn void(JNIEnv, Jobject obj, JmethodID methodID, JValue* args);
alias CallNonvirtualObjectMethodVFunc 	= fn Jobject(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualObjectMethodAFunc 	= fn Jobject(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias CallNonvirtualBooleanMethodVFunc 	= fn Jboolean(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualBooleanMethodAFunc 	= fn Jboolean(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias CallNonvirtualByteMethodVFunc 	= fn Jbyte(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualByteMethodAFunc 	= fn Jbyte(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias CallNonvirtualCharMethodVFunc 	= fn Jchar(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualCharMethodAFunc 	= fn Jchar(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias CallNonvirtualShortMethodVFunc 	= fn Jshort(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualShortMethodAFunc 	= fn Jshort(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias CallNonvirtualIntMethodVFunc 		= fn Jint(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualIntMethodAFunc 		= fn Jint(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias CallNonvirtualLongMethodVFunc 	= fn Jlong(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualLongMethodAFunc 	= fn Jlong(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias CallNonvirtualFloatMethodVFunc 	= fn Jfloat(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualFloatMethodAFunc 	= fn Jfloat(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias CallNonvirtualDoubleMethodVFunc 	= fn Jdouble(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualDoubleMethodAFunc 	= fn Jdouble(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias CallNonvirtualVoidMethodVFunc 	= fn void(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, VaList args);
alias CallNonvirtualVoidMethodAFunc 	= fn void(JNIEnv, Jobject obj, Jclass cls, JmethodID methodID, JValue* args);
alias GetFieldIDFunc 					= fn JfieldID(JNIEnv, Jclass cls, char* name, char* sig);
alias GetObjectFieldFunc 				= fn Jobject(JNIEnv, Jobject obj, JfieldID fieldID);
alias GetBooleanFieldFunc 				= fn Jboolean(JNIEnv, Jobject obj, JfieldID fieldID);
alias GetByteFieldFunc 					= fn Jbyte(JNIEnv, Jobject obj, JfieldID fieldID);
alias GetCharFieldFunc 					= fn Jchar(JNIEnv, Jobject obj, JfieldID fieldID);
alias GetShortFieldFunc 				= fn Jshort(JNIEnv, Jobject obj, JfieldID fieldID);
alias GetIntFieldFunc 					= fn Jint(JNIEnv, Jobject obj, JfieldID fieldID);
alias GetLongFieldFunc 					= fn Jlong(JNIEnv, Jobject obj, JfieldID fieldID);
alias GetFloatFieldFunc 				= fn Jfloat(JNIEnv, Jobject obj, JfieldID fieldID);
alias GetDoubleFieldFunc 				= fn Jdouble(JNIEnv, Jobject obj, JfieldID fieldID);
alias SetObjectFieldFunc 				= fn void(JNIEnv, Jobject obj, JfieldID fieldID, Jobject value);
alias SetBooleanFieldFunc 				= fn void(JNIEnv, Jobject obj, JfieldID fieldID, Jboolean value);
alias SetByteFieldFunc 					= fn void(JNIEnv, Jobject obj, JfieldID fieldID, Jbyte value);
alias SetCharFieldFunc 					= fn void(JNIEnv, Jobject obj, JfieldID fieldID, Jchar value);
alias SetShortFieldFunc 				= fn void(JNIEnv, Jobject obj, JfieldID fieldID, Jshort value);
alias SetIntFieldFunc 					= fn void(JNIEnv, Jobject obj, JfieldID fieldID, Jint value);
alias SetLongFieldFunc 					= fn void(JNIEnv, Jobject obj, JfieldID fieldID, Jlong value);
alias SetFloatFieldFunc 				= fn void(JNIEnv, Jobject obj, JfieldID fieldID, Jfloat value);
alias SetDoubleFieldFunc 				= fn void(JNIEnv, Jobject obj, JfieldID fieldID, Jdouble value);
alias GetStaticMethodIDFunc 			= fn JmethodID(JNIEnv, Jclass cls, char* name, char* sig);
alias CallStaticObjectMethodVFunc 		= fn Jobject(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticObjectMethodAFunc 		= fn Jobject(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias CallStaticBooleanMethodVFunc 		= fn Jboolean(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticBooleanMethodAFunc 		= fn Jboolean(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias CallStaticByteMethodVFunc 		= fn Jbyte(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticByteMethodAFunc 		= fn Jbyte(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias CallStaticCharMethodVFunc 		= fn Jchar(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticCharMethodAFunc 		= fn Jchar(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias CallStaticShortMethodVFunc 		= fn Jshort(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticShortMethodAFunc 		= fn Jshort(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias CallStaticIntMethodVFunc 			= fn Jint(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticIntMethodAFunc 			= fn Jint(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias CallStaticLongMethodVFunc 		= fn Jlong(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticLongMethodAFunc 		= fn Jlong(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias CallStaticFloatMethodVFunc 		= fn Jfloat(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticFloatMethodAFunc 		= fn Jfloat(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias CallStaticDoubleMethodVFunc 		= fn Jdouble(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticDoubleMethodAFunc 		= fn Jdouble(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias CallStaticVoidMethodVFunc 		= fn void(JNIEnv, Jclass cls, JmethodID methodID, VaList args);
alias CallStaticVoidMethodAFunc 		= fn void(JNIEnv, Jclass cls, JmethodID methodID, JValue* args);
alias GetStaticFieldIDFunc 				= fn JfieldID(JNIEnv, Jclass cls, char* name, char* sig);
alias GetStaticObjectFieldFunc 			= fn Jobject(JNIEnv, Jclass cls, JfieldID fieldID);
alias GetStaticBooleanFieldFunc 		= fn Jboolean(JNIEnv, Jclass cls, JfieldID fieldID);
alias GetStaticByteFieldFunc 			= fn Jbyte(JNIEnv, Jclass cls, JfieldID fieldID);
alias GetStaticCharFieldFunc 			= fn Jchar(JNIEnv, Jclass cls, JfieldID fieldID);
alias GetStaticShortFieldFunc 			= fn Jshort(JNIEnv, Jclass cls, JfieldID fieldID);
alias GetStaticIntFieldFunc 			= fn Jint(JNIEnv, Jclass cls, JfieldID fieldID);
alias GetStaticLongFieldFunc 			= fn Jlong(JNIEnv, Jclass cls, JfieldID fieldID);
alias GetStaticFloatFieldFunc 			= fn Jfloat(JNIEnv, Jclass cls, JfieldID fieldID);
alias GetStaticDoubleFieldFunc 			= fn Jdouble(JNIEnv, Jclass cls, JfieldID fieldID);
alias SetStaticObjectFieldFunc 			= fn void(JNIEnv, Jclass cls, JfieldID fieldID, Jobject value);
alias SetStaticBooleanFieldFunc 		= fn void(JNIEnv, Jclass cls, JfieldID fieldID, Jboolean value);
alias SetStaticByteFieldFunc 			= fn void(JNIEnv, Jclass cls, JfieldID fieldID, Jbyte value);
alias SetStaticCharFieldFunc 			= fn void(JNIEnv, Jclass cls, JfieldID fieldID, Jchar value);
alias SetStaticShortFieldFunc 			= fn void(JNIEnv, Jclass cls, JfieldID fieldID, Jshort value);
alias SetStaticIntFieldFunc 			= fn void(JNIEnv, Jclass cls, JfieldID fieldID, Jint value);
alias SetStaticLongFieldFunc 			= fn void(JNIEnv, Jclass cls, JfieldID fieldID, Jlong value);
alias SetStaticFloatFieldFunc 			= fn void(JNIEnv, Jclass cls, JfieldID fieldID, Jfloat value);
alias SetStaticDoubleFieldFunc 			= fn void(JNIEnv, Jclass cls, JfieldID fieldID, Jdouble value);
alias NewStringFunc 					= fn Jstring(JNIEnv, char* bytes);
alias GetStringLengthFunc 				= fn Jsize(JNIEnv, Jstring str);
alias GetStringCharsFunc 				= fn char*(JNIEnv, Jstring str, Jboolean* isCopy);
alias ReleaseStringCharsFunc 			= fn void(JNIEnv, Jstring str, char* chars);
alias NewStringUTFFunc 					= fn Jstring(JNIEnv, char* bytes);
alias GetStringUTFLengthFunc 			= fn Jsize(JNIEnv, Jstring str);
alias GetStringUTFCharsFunc 			= fn char*(JNIEnv, Jstring str, Jboolean* isCopy);
alias ReleaseStringUTFCharsFunc 		= fn void(JNIEnv, Jstring str, char* chars);
alias GetArrayLengthFunc 				= fn Jsize(JNIEnv, Jarray array);
alias NewObjectArrayFunc 				= fn JobjectArray(JNIEnv, Jsize length, Jclass elementClass, Jobject initialElement);
alias GetObjectArrayElementFunc 		= fn Jobject(JNIEnv, JobjectArray array, Jsize index);
alias SetObjectArrayElementFunc 		= fn void(JNIEnv, JobjectArray array, Jsize index, Jobject value);
alias NewBooleanArrayFunc 				= fn JbooleanArray(JNIEnv, Jsize length);
alias NewByteArrayFunc 					= fn JbyteArray(JNIEnv, Jsize length);
alias NewCharArrayFunc 					= fn JcharArray(JNIEnv, Jsize length);
alias NewShortArrayFunc 				= fn JshortArray(JNIEnv, Jsize length);
alias NewIntArrayFunc 					= fn JintArray(JNIEnv, Jsize length);
alias NewLongArrayFunc 					= fn JlongArray(JNIEnv, Jsize length);
alias NewFloatArrayFunc 				= fn JfloatArray(JNIEnv, Jsize length);
alias NewDoubleArrayFunc 				= fn JdoubleArray(JNIEnv, Jsize length);
alias GetBooleanArrayElementsFunc 		= fn Jboolean*(JNIEnv, JbooleanArray array, Jboolean* isCopy);
alias GetByteArrayElementsFunc 			= fn Jbyte*(JNIEnv, JbyteArray array, Jboolean* isCopy);
alias GetCharArrayElementsFunc 			= fn Jchar*(JNIEnv, JcharArray array, Jboolean* isCopy);
alias GetShortArrayElementsFunc 		= fn Jshort*(JNIEnv, JshortArray array, Jboolean* isCopy);
alias GetIntArrayElementsFunc 			= fn Jint*(JNIEnv, JintArray array, Jboolean* isCopy);
alias GetLongArrayElementsFunc 			= fn Jlong*(JNIEnv, JlongArray array, Jboolean* isCopy);
alias GetFloatArrayElementsFunc 		= fn Jfloat*(JNIEnv, JfloatArray array, Jboolean* isCopy);
alias GetDoubleArrayElementsFunc 		= fn Jdouble*(JNIEnv, JdoubleArray array, Jboolean* isCopy);
alias ReleaseBooleanArrayElementsFunc 	= fn void(JNIEnv, JbooleanArray array, Jboolean* elems, Jint mode);
alias ReleaseByteArrayElementsFunc 		= fn void(JNIEnv, JbyteArray array, Jbyte* elems, Jint mode);
alias ReleaseCharArrayElementsFunc 		= fn void(JNIEnv, JcharArray array, Jchar* elems, Jint mode);
alias ReleaseShortArrayElementsFunc 	= fn void(JNIEnv, JshortArray array, Jshort* elems, Jint mode);
alias ReleaseIntArrayElementsFunc 		= fn void(JNIEnv, JintArray array, Jint* elems, Jint mode);
alias ReleaseLongArrayElementsFunc 		= fn void(JNIEnv, JlongArray array, Jlong* elems, Jint mode);
alias ReleaseFloatArrayElementsFunc 	= fn void(JNIEnv, JfloatArray array, Jfloat* elems, Jint mode);
alias ReleaseDoubleArrayElementsFunc 	= fn void(JNIEnv, JdoubleArray array, Jdouble* elems, Jint mode);
alias GetBooleanArrayRegionFunc 		= fn void(JNIEnv, JbooleanArray array, Jsize start, Jsize len, Jboolean *buf);
alias GetByteArrayRegionFunc 			= fn void(JNIEnv, JbyteArray array, Jsize start, Jsize len, Jbyte *buf);
alias GetCharArrayRegionFunc 			= fn void(JNIEnv, JcharArray array, Jsize start, Jsize len, Jchar *buf);
alias GetShortArrayRegionFunc 			= fn void(JNIEnv, JshortArray array, Jsize start, Jsize len, Jshort *buf);
alias GetIntArrayRegionFunc 			= fn void(JNIEnv, JintArray array, Jsize start, Jsize len, Jint *buf);
alias GetLongArrayRegionFunc 			= fn void(JNIEnv, JlongArray array, Jsize start, Jsize len, Jlong *buf);
alias GetFloatArrayRegionFunc 			= fn void(JNIEnv, JfloatArray array, Jsize start, Jsize len, Jfloat *buf);
alias GetDoubleArrayRegionFunc 			= fn void(JNIEnv, JdoubleArray array, Jsize start, Jsize len, Jdouble *buf);

alias SetBooleanArrayRegionFunc 		= fn void(JNIEnv, JbooleanArray, Jsize, Jsize, Jboolean*);
alias SetByteArrayRegionFunc    		= fn void(JNIEnv, JbyteArray, Jsize, Jsize, Jbyte*);
alias SetCharArrayRegionFunc    		= fn void(JNIEnv, JcharArray, Jsize, Jsize, Jchar*);
alias SetShortArrayRegionFunc   		= fn void(JNIEnv, JshortArray, Jsize, Jsize, Jshort*);
alias SetIntArrayRegionFunc     		= fn void(JNIEnv, JintArray, Jsize, Jsize, Jint*);
alias SetLongArrayRegionFunc    		= fn void(JNIEnv, JlongArray, Jsize, Jsize, Jlong*);
alias SetFloatArrayRegionFunc   		= fn void(JNIEnv, JfloatArray, Jsize, Jsize, Jfloat*);
alias SetDoubleArrayRegionFunc  		= fn void(JNIEnv, JdoubleArray, Jsize, Jsize, Jdouble*);
alias RegisterNativesFunc   			= fn int(JNIEnv, Jclass, JNINativeMethod*, int);
alias UnregisterNativesFunc 			= fn int(JNIEnv, Jclass);
alias MonitorEnterFunc      			= fn int(JNIEnv, Jobject);
alias MonitorExitFunc       			= fn int(JNIEnv, Jobject);
alias GetJavaVMFunc         			= fn int(JNIEnv, JavaVM**);
alias GetStringRegionFunc               = fn void(JNIEnv, Jstring, Jsize, Jsize, ushort*);
alias GetStringUTFRegionFunc            = fn void(JNIEnv, Jstring, Jsize, Jsize, char*);
alias GetPrimitiveArrayCriticalFunc     = fn void*(JNIEnv, Jarray, bool*);
alias ReleasePrimitiveArrayCriticalFunc = fn void(JNIEnv, Jarray, void*, int);
alias GetStringCriticalFunc             = fn ushort*(JNIEnv, Jstring, bool*);
alias ReleaseStringCriticalFunc         = fn void(JNIEnv, Jstring, ushort*);
alias NewWeakGlobalRefFunc       		= fn Jweak(JNIEnv, Jobject);
alias DeleteWeakGlobalRefFunc    		= fn void(JNIEnv, Jweak);
alias ExceptionCheckFunc         		= fn bool(JNIEnv);
alias NewDirectByteBufferFunc    		= fn Jobject(JNIEnv, void*, long);
alias GetDirectBufferAddressFunc 		= fn void*(JNIEnv, Jobject);
alias GetDirectBufferCapacityFunc 		= fn long(JNIEnv, Jobject);
alias GetObjectRefTypeFunc 				= fn JobjectType(JNIEnv, Jobject);
alias GetModuleFunc         			= fn Jobject(JNIEnv, Jclass);
alias IsVirtualThreadFunc   			= fn bool(JNIEnv, Jobject);

// Method implementations

fn Jint Jni.getVersion(Jni* self) {
	return self.vtable.getVersionFn(self.env);
}

fn Jclass Jni.defineClass(Jni* self, char* name, Jclass loader, Jbyte* buf, Jsize len) {
	return self.vtable.defineClassFn(self.env, name, loader, buf, len);
}

fn Jclass Jni.findClass(Jni* self, char* name) {
	return self.vtable.findClassFn(self.env, name);
}

fn JmethodID Jni.fromReflectedMethod(Jni* self, Jobject method) {
	return self.vtable.fromReflectedMethodFn(self.env, method);
}

fn JfieldID Jni.fromReflectedField(Jni* self, Jobject field) {
	return self.vtable.fromReflectedFieldFn(self.env, field);
}

fn Jobject Jni.toReflectedMethod(Jni* self, Jclass cls, JmethodID methodID, Jboolean isStatic) {
	return self.vtable.toReflectedMethodFn(self.env, cls, methodID, isStatic);
}

fn Jclass Jni.getSuperclass(Jni* self, Jclass sub) {
	return self.vtable.getSuperclassFn(self.env, sub);
}

fn Jboolean Jni.isAssignableFrom(Jni* self, Jclass sub, Jclass sup) {
	return self.vtable.isAssignableFromFn(self.env, sub, sup);
}

fn Jobject Jni.toReflectedField(Jni* self, Jclass cls, JfieldID fieldID, Jboolean isStatic) {
	return self.vtable.toReflectedFieldFn(self.env, cls, fieldID, isStatic);
}

fn Jint Jni.throw(Jni* self, Jthrowable obj) {
	return self.vtable.throwFn(self.env, obj);
}

fn Jint Jni.throwNew(Jni* self, char* className, char* message) {
	return self.vtable.throwNewFn(self.env, className, message);
}

fn Jthrowable Jni.exceptionOccurred(Jni* self) {
	return self.vtable.exceptionOccurredFn(self.env);
}

fn void Jni.exceptionDescribe(Jni* self) {
	self.vtable.exceptionDescribeFn(self.env);
}

fn void Jni.exceptionClear(Jni* self) {
	self.vtable.exceptionClearFn(self.env);
}

fn void Jni.fatalError(Jni* self, char* msg) {
	self.vtable.fatalErrorFn(self.env, msg);
}

fn Jint Jni.pushLocalFrame(Jni* self, Jint capacity) {
	return self.vtable.pushLocalFrameFn(self.env, capacity);
}

fn Jobject Jni.popLocalFrame(Jni* self, Jobject result) {
	return self.vtable.popLocalFrameFn(self.env, result);
}

fn Jobject Jni.newGlobalRef(Jni* self, Jobject obj) {
	return self.vtable.newGlobalRefFn(self.env, obj);
}

fn void Jni.deleteGlobalRef(Jni* self, Jobject globalRef) {
	self.vtable.deleteGlobalRefFn(self.env, globalRef);
}

fn void Jni.deleteLocalRef(Jni* self, Jobject localRef) {
	self.vtable.deleteLocalRefFn(self.env, localRef);
}

fn Jboolean Jni.isSameObject(Jni* self, Jobject ref1, Jobject ref2) {
	return self.vtable.isSameObjectFn(self.env, ref1, ref2);
}

fn Jobject Jni.newLocalRef(Jni* self, Jobject ref) {
	return self.vtable.newLocalRefFn(self.env, ref);
}

fn Jint Jni.ensureLocalCapacity(Jni* self, Jint capacity) {
	return self.vtable.ensureLocalCapacityFn(self.env, capacity);
}

fn Jobject Jni.allocObject(Jni* self, Jclass cls) {
	return self.vtable.allocObjectFn(self.env, cls);
}

fn Jobject Jni.newObjectV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.newObjectVFn(self.env, cls, methodID, args);
}

fn Jobject Jni.newObjectA(Jni* self, Jclass cls, JmethodID method, JValue* args) {
	return self.vtable.newObjectAFn(self.env, cls, method, args);
}

fn Jclass Jni.getObjectClass(Jni* self, Jobject obj) {
	return self.vtable.getObjectClassFn(self.env, obj);
}

fn Jboolean Jni.isInstanceOf(Jni* self, Jobject obj, Jclass cls) {
	return self.vtable.isInstanceOfFn(self.env, obj, cls);
}

fn JmethodID Jni.getMethodID(Jni* self, Jclass cls, char* name, char* sig) {
	return self.vtable.getMethodIDFn(self.env, cls, name, sig);
}

macro Jobject Jni.newObject(Jni* self, Jclass cls, JmethodID methodID, ...)
{
    JValue[$vacount] args;
    
    $for var $i = 0; $i < $vacount; $i++:
        args[$i] = (JValue)$vaarg[$i];
    $endfor
    
    return self.newObjectA((JNIEnv)&self, cls, methodID, args.ptr);
}

macro Jobject Jni.callObjectMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	VaList args;

    JValue[$vacount] args;
    
    $for var $i = 0; $i < $vacount; $i++:
        args[$i] = (JValue)$vaarg[$i];
    $endfor
    
    return self.callObjectMethodA((JNIEnv)&self, obj, methodID, args.ptr);
}

fn Jobject Jni.callObjectMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	return self.vtable.callObjectMethodVFn(self.env, obj, methodID, args);
}

fn Jobject Jni.callObjectMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	return self.vtable.callObjectMethodAFn(self.env, obj, methodID, args);
}

macro Jboolean Jni.callBooleanMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	VaList args;

	JValue[$vacount] args;
	
	$for var $i = 0; $i < $vacount; $i++:
		args[$i] = (JValue)$vaarg[$i];
	$endfor
	
	return self.vtable.callBooleanMethodAFn(self.env, obj, methodID, args.ptr);
}

fn Jboolean Jni.callBooleanMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	return self.vtable.callBooleanMethodVFn(self.env, obj, methodID, args);
}

fn Jboolean Jni.callBooleanMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	return self.vtable.callBooleanMethodAFn(self.env, obj, methodID, args);
}

macro Jbyte Jni.callByteMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	VaList args;

	JValue[$vacount] args;
	
	$for var $i = 0; $i < $vacount; $i++:
		args[$i] = (JValue)$vaarg[$i];
	$endfor
	
	return self.vtable.callByteMethodAFn(self.env, obj, methodID, args.ptr);
}

fn Jbyte Jni.callByteMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	return self.vtable.callByteMethodVFn(self.env, obj, methodID, args);
}

fn Jbyte Jni.callByteMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	return self.vtable.callByteMethodAFn(self.env, obj, methodID, args);
}

macro Jchar Jni.callCharMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	VaList args;

	JValue[$vacount] args;
	
	$for var $i = 0; $i < $vacount; $i++:
		args[$i] = (JValue)$vaarg[$i];
	$endfor
	
	return self.vtable.callCharMethodAFn(self.env, obj, methodID, args.ptr);
}

fn Jchar Jni.callCharMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	return self.vtable.callCharMethodVFn(self.env, obj, methodID, args);
}

fn Jchar Jni.callCharMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	return self.vtable.callCharMethodAFn(self.env, obj, methodID, args);
}

macro Jshort Jni.callShortMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	VaList args;

	JValue[$vacount] args;
	
	$for var $i = 0; $i < $vacount; $i++:
		args[$i] = (JValue)$vaarg[$i];
	$endfor
	
	return self.vtable.callShortMethodAFn(self.env, obj, methodID, args.ptr);
}

fn Jshort Jni.callShortMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	return self.vtable.callShortMethodVFn(self.env, obj, methodID, args);
}

fn Jshort Jni.callShortMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	return self.vtable.callShortMethodAFn(self.env, obj, methodID, args);
}

macro Jint Jni.callIntMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callIntMethodAFn(self.env, obj, methodID, args.ptr);
    $else
        return self.vtable.callIntMethodAFn(self.env, obj, methodID, null);
    $endif
}

fn Jint Jni.callIntMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	return self.vtable.callIntMethodVFn(self.env, obj, methodID, args);
}

fn Jint Jni.callIntMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	return self.vtable.callIntMethodAFn(self.env, obj, methodID, args);
}

macro Jlong Jni.callLongMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callLongMethodAFn(self.env, obj, methodID, args.ptr);
    $else
        return self.vtable.callLongMethodAFn(self.env, obj, methodID, null);
    $endif
}

fn Jlong Jni.callLongMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	return self.vtable.callLongMethodVFn(self.env, obj, methodID, args);
}

fn Jlong Jni.callLongMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	return self.vtable.callLongMethodAFn(self.env, obj, methodID, args);
}

macro Jfloat Jni.callFloatMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callFloatMethodAFn(self.env, obj, methodID, args.ptr);
    $else
        return self.vtable.callFloatMethodAFn(self.env, obj, methodID, null);
    $endif
}

fn Jfloat Jni.callFloatMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	return self.vtable.callFloatMethodVFn(self.env, obj, methodID, args);
}

fn Jfloat Jni.callFloatMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	return self.vtable.callFloatMethodAFn(self.env, obj, methodID, args);
}

macro Jdouble Jni.callDoubleMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callDoubleMethodAFn(self.env, obj, methodID, args.ptr);
    $else
        return self.vtable.callDoubleMethodAFn(self.env, obj, methodID, null);
    $endif
}

fn Jdouble Jni.callDoubleMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	return self.vtable.callDoubleMethodVFn(self.env, obj, methodID, args);
}

fn Jdouble Jni.callDoubleMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	return self.vtable.callDoubleMethodAFn(self.env, obj, methodID, args);
}

macro void Jni.callVoidMethod(Jni* self, Jobject obj, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        self.vtable.callVoidMethodAFn(self.env, obj, methodID, args.ptr);
    $else
        self.vtable.callVoidMethodAFn(self.env, obj, methodID, null);
    $endif
}

fn void Jni.callVoidMethodV(Jni* self, Jobject obj, JmethodID methodID, VaList args) {
	self.vtable.callVoidMethodVFn(self.env, obj, methodID, args);
}

fn void Jni.callVoidMethodA(Jni* self, Jobject obj, JmethodID methodID, JValue* args) {
	self.vtable.callVoidMethodAFn(self.env, obj, methodID, args);
}

macro Jobject Jni.callNonvirtualObjectMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callNonvirtualObjectMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callNonvirtualObjectMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jobject Jni.callNonvirtualObjectMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callNonvirtualObjectMethodVFn(self.env, obj, cls, methodID, args);
}

fn Jobject Jni.callNonvirtualObjectMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callNonvirtualObjectMethodAFn(self.env, obj, cls, methodID, args);
}

macro Jboolean Jni.callNonvirtualBooleanMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callNonvirtualBooleanMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callNonvirtualBooleanMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jboolean Jni.callNonvirtualBooleanMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callNonvirtualBooleanMethodVFn(self.env, obj, cls, methodID, args);
}

fn Jboolean Jni.callNonvirtualBooleanMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callNonvirtualBooleanMethodAFn(self.env, obj, cls, methodID, args);
}

macro Jbyte Jni.callNonvirtualByteMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callNonvirtualByteMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callNonvirtualByteMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jbyte Jni.callNonvirtualByteMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callNonvirtualByteMethodVFn(self.env, obj, cls, methodID, args);
}

fn Jbyte Jni.callNonvirtualByteMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callNonvirtualByteMethodAFn(self.env, obj, cls, methodID, args);
}

macro Jchar Jni.callNonvirtualCharMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callNonvirtualCharMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callNonvirtualCharMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jchar Jni.callNonvirtualCharMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callNonvirtualCharMethodVFn(self.env, obj, cls, methodID, args);
}

fn Jchar Jni.callNonvirtualCharMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callNonvirtualCharMethodAFn(self.env, obj, cls, methodID, args);
}

macro Jshort Jni.callNonvirtualShortMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callNonvirtualShortMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callNonvirtualShortMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jshort Jni.callNonvirtualShortMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callNonvirtualShortMethodVFn(self.env, obj, cls, methodID, args);
}

fn Jshort Jni.callNonvirtualShortMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callNonvirtualShortMethodAFn(self.env, obj, cls, methodID, args);
}

macro Jint Jni.callNonvirtualIntMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callNonvirtualIntMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callNonvirtualIntMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jint Jni.callNonvirtualIntMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callNonvirtualIntMethodVFn(self.env, obj, cls, methodID, args);
}

fn Jint Jni.callNonvirtualIntMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callNonvirtualIntMethodAFn(self.env, obj, cls, methodID, args);
}

macro Jlong Jni.callNonvirtualLongMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callNonvirtualLongMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callNonvirtualLongMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jlong Jni.callNonvirtualLongMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callNonvirtualLongMethodVFn(self.env, obj, cls, methodID, args);
}

fn Jlong Jni.callNonvirtualLongMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callNonvirtualLongMethodAFn(self.env, obj, cls, methodID, args);
}

macro Jfloat Jni.callNonvirtualFloatMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callNonvirtualFloatMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callNonvirtualFloatMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jfloat Jni.callNonvirtualFloatMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callNonvirtualFloatMethodVFn(self.env, obj, cls, methodID, args);
}

fn Jfloat Jni.callNonvirtualFloatMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callNonvirtualFloatMethodAFn(self.env, obj, cls, methodID, args);
}

macro Jdouble Jni.callNonvirtualDoubleMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callNonvirtualDoubleMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callNonvirtualDoubleMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jdouble Jni.callNonvirtualDoubleMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callNonvirtualDoubleMethodVFn(self.env, obj, cls, methodID, args);
}

fn Jdouble Jni.callNonvirtualDoubleMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callNonvirtualDoubleMethodAFn(self.env, obj, cls, methodID, args);
}

macro void Jni.callNonvirtualVoidMethod(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        self.vtable.callNonvirtualVoidMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        self.vtable.callNonvirtualVoidMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn void Jni.callNonvirtualVoidMethodV(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, VaList args) {
	self.vtable.callNonvirtualVoidMethodVFn(self.env, obj, cls, methodID, args);
}

fn void Jni.callNonvirtualVoidMethodA(Jni* self, Jobject obj, Jclass cls, JmethodID methodID, JValue* args) {
	self.vtable.callNonvirtualVoidMethodAFn(self.env, obj, cls, methodID, args);
}

fn JfieldID Jni.getFieldID(Jni* self, Jclass cls, char* name, char* sig) {
	return self.vtable.getFieldIDFn(self.env, cls, name, sig);
}

fn Jobject Jni.getObjectField(Jni* self, Jobject obj, JfieldID fieldID) {
	return self.vtable.getObjectFieldFn(self.env, obj, fieldID);
}

fn Jboolean Jni.getBooleanField(Jni* self, Jobject obj, JfieldID fieldID) {
	return self.vtable.getBooleanFieldFn(self.env, obj, fieldID);
}

fn Jbyte Jni.getByteField(Jni* self, Jobject obj, JfieldID fieldID) {
	return self.vtable.getByteFieldFn(self.env, obj, fieldID);
}

fn Jchar Jni.getCharField(Jni* self, Jobject obj, JfieldID fieldID) {
	return self.vtable.getCharFieldFn(self.env, obj, fieldID);
}

fn Jshort Jni.getShortField(Jni* self, Jobject obj, JfieldID fieldID) {
	return self.vtable.getShortFieldFn(self.env, obj, fieldID);
}

fn Jint Jni.getIntField(Jni* self, Jobject obj, JfieldID fieldID) {
	return self.vtable.getIntFieldFn(self.env, obj, fieldID);
}

fn Jlong Jni.getLongField(Jni* self, Jobject obj, JfieldID fieldID) {
	return self.vtable.getLongFieldFn(self.env, obj, fieldID);
}

fn Jfloat Jni.getFloatField(Jni* self, Jobject obj, JfieldID fieldID) {
	return self.vtable.getFloatFieldFn(self.env, obj, fieldID);
}

fn Jdouble Jni.getDoubleField(Jni* self, Jobject obj, JfieldID fieldID) {
	return self.vtable.getDoubleFieldFn(self.env, obj, fieldID);
}

fn void Jni.setObjectField(Jni* self, Jobject obj, JfieldID fieldID, Jobject value) {
	self.vtable.setObjectFieldFn(self.env, obj, fieldID, value);
}

fn void Jni.setBooleanField(Jni* self, Jobject obj, JfieldID fieldID, Jboolean value) {
	self.vtable.setBooleanFieldFn(self.env, obj, fieldID, value);
}

fn void Jni.setByteField(Jni* self, Jobject obj, JfieldID fieldID, Jbyte value) {
	self.vtable.setByteFieldFn(self.env, obj, fieldID, value);
}

fn void Jni.setCharField(Jni* self, Jobject obj, JfieldID fieldID, Jchar value) {
	self.vtable.setCharFieldFn(self.env, obj, fieldID, value);
}

fn void Jni.setShortField(Jni* self, Jobject obj, JfieldID fieldID, Jshort value) {
	self.vtable.setShortFieldFn(self.env, obj, fieldID, value);
}

fn void Jni.setIntField(Jni* self, Jobject obj, JfieldID fieldID, Jint value) {
	self.vtable.setIntFieldFn(self.env, obj, fieldID, value);
}

fn void Jni.setLongField(Jni* self, Jobject obj, JfieldID fieldID, Jlong value) {
	self.vtable.setLongFieldFn(self.env, obj, fieldID, value);
}

fn void Jni.setFloatField(Jni* self, Jobject obj, JfieldID fieldID, Jfloat value) {
	self.vtable.setFloatFieldFn(self.env, obj, fieldID, value);
}

fn void Jni.setDoubleField(Jni* self, Jobject obj, JfieldID fieldID, Jdouble value) {
	self.vtable.setDoubleFieldFn(self.env, obj, fieldID, value);
}

fn JmethodID Jni.getStaticMethodID(Jni* self, Jclass cls, char* name, char* sig) {
	return self.vtable.getStaticMethodIDFn(self.env, cls, name, sig);
}

macro Jobject Jni.callStaticObjectMethod(Jni* self, Jclass cls, JmethodID methodID, ...) 
{
    $if $vacount > 0:
        JValue[$vacount] args;
        
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        
        return self.vtable.callStaticObjectMethodAFn(self.env, cls, methodID, args.ptr);
    $else
        return self.vtable.callStaticObjectMethodAFn(self.env, cls, methodID, null);
    $endif
}

fn Jobject Jni.callStaticObjectMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callStaticObjectMethodVFn(self.env, cls, methodID, args);
}

fn Jobject Jni.callStaticObjectMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callStaticObjectMethodAFn(self.env, cls, methodID, args);
}

macro Jboolean Jni.callStaticBooleanMethod(Jni* self, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callStaticBooleanMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callStaticBooleanMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jboolean Jni.callStaticBooleanMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callStaticBooleanMethodVFn(self.env, cls, methodID, args);
}

fn Jboolean Jni.callStaticBooleanMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callStaticBooleanMethodAFn(self.env, cls, methodID, args);
}

macro Jbyte Jni.callStaticByteMethod(Jni* self, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callStaticByteMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callStaticByteMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jbyte Jni.callStaticByteMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callStaticByteMethodVFn(self.env, cls, methodID, args);
}

fn Jbyte Jni.callStaticByteMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callStaticByteMethodAFn(self.env, cls, methodID, args);
}

macro Jchar Jni.callStaticCharMethod(Jni* self, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callStaticCharMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callStaticCharMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jchar Jni.callStaticCharMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callStaticCharMethodVFn(self.env, cls, methodID, args);
}

fn Jchar Jni.callStaticCharMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callStaticCharMethodAFn(self.env, cls, methodID, args);
}

macro Jshort Jni.callStaticShortMethod(Jni* self, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callStaticShortMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callStaticShortMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jshort Jni.callStaticShortMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callStaticShortMethodVFn(self.env, cls, methodID, args);
}

fn Jshort Jni.callStaticShortMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callStaticShortMethodAFn(self.env, cls, methodID, args);
}

macro Jint Jni.callStaticIntMethod(Jni* self, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callStaticIntMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callStaticIntMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jint Jni.callStaticIntMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callStaticIntMethodVFn(self.env, cls, methodID, args);
}

fn Jint Jni.callStaticIntMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callStaticIntMethodAFn(self.env, cls, methodID, args);
}

macro Jlong Jni.callStaticLongMethod(Jni* self, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callStaticLongMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callStaticLongMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jlong Jni.callStaticLongMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callStaticLongMethodVFn(self.env, cls, methodID, args);
}

fn Jlong Jni.callStaticLongMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callStaticLongMethodAFn(self.env, cls, methodID, args);
}

macro Jfloat Jni.callStaticFloatMethod(Jni* self, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callStaticFloatMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callStaticFloatMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jfloat Jni.callStaticFloatMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callStaticFloatMethodVFn(self.env, cls, methodID, args);
}

fn Jfloat Jni.callStaticFloatMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callStaticFloatMethodAFn(self.env, cls, methodID, args);
}

macro Jdouble Jni.callStaticDoubleMethod(Jni* self, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        return self.vtable.callStaticDoubleMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        return self.vtable.callStaticDoubleMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn Jdouble Jni.callStaticDoubleMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	return self.vtable.callStaticDoubleMethodVFn(self.env, cls, methodID, args);
}

fn Jdouble Jni.callStaticDoubleMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	return self.vtable.callStaticDoubleMethodAFn(self.env, cls, methodID, args);
}

macro void Jni.callStaticVoidMethod(Jni* self, Jclass cls, JmethodID methodID, ...) {
	$if $vacount > 0:
        JValue[$vacount] args;
        $for var $i = 0; $i < $vacount; $i++:
            args[$i] = (JValue)$vaarg[$i];
        $endfor
        self.vtable.callStaticVoidMethodAFn(self.env, obj, cls, methodID, args.ptr);
    $else
        self.vtable.callStaticVoidMethodAFn(self.env, obj, cls, methodID, null);
    $endif
}

fn void Jni.callStaticVoidMethodV(Jni* self, Jclass cls, JmethodID methodID, VaList args) {
	self.vtable.callStaticVoidMethodVFn(self.env, cls, methodID, args);
}

fn void Jni.callStaticVoidMethodA(Jni* self, Jclass cls, JmethodID methodID, JValue* args) {
	self.vtable.callStaticVoidMethodAFn(self.env, cls, methodID, args);
}

fn JfieldID Jni.getStaticFieldID(Jni* self, Jclass cls, char* name, char* sig) {
	return self.vtable.getStaticFieldIDFn(self.env, cls, name, sig);
}

fn Jobject Jni.getStaticObjectField(Jni* self, Jclass cls, JfieldID fieldID) {
	return self.vtable.getStaticObjectFieldFn(self.env, cls, fieldID);
}

fn Jboolean Jni.getStaticBooleanField(Jni* self, Jclass cls, JfieldID fieldID) {
	return self.vtable.getStaticBooleanFieldFn(self.env, cls, fieldID);
}

fn Jbyte Jni.getStaticByteField(Jni* self, Jclass cls, JfieldID fieldID) {
	return self.vtable.getStaticByteFieldFn(self.env, cls, fieldID);
}

fn Jchar Jni.getStaticCharField(Jni* self, Jclass cls, JfieldID fieldID) {
	return self.vtable.getStaticCharFieldFn(self.env, cls, fieldID);
}

fn Jshort Jni.getStaticShortField(Jni* self, Jclass cls, JfieldID fieldID) {
	return self.vtable.getStaticShortFieldFn(self.env, cls, fieldID);
}

fn Jint Jni.getStaticIntField(Jni* self, Jclass cls, JfieldID fieldID) {
	return self.vtable.getStaticIntFieldFn(self.env, cls, fieldID);
}

fn Jlong Jni.getStaticLongField(Jni* self, Jclass cls, JfieldID fieldID) {
	return self.vtable.getStaticLongFieldFn(self.env, cls, fieldID);
}

fn Jfloat Jni.getStaticFloatField(Jni* self, Jclass cls, JfieldID fieldID) {
	return self.vtable.getStaticFloatFieldFn(self.env, cls, fieldID);
}

fn Jdouble Jni.getStaticDoubleField(Jni* self, Jclass cls, JfieldID fieldID) {
	return self.vtable.getStaticDoubleFieldFn(self.env, cls, fieldID);
}

fn void Jni.setStaticObjectField(Jni* self, Jclass cls, JfieldID fieldID, Jobject value) {
	self.vtable.setStaticObjectFieldFn(self.env, cls, fieldID, value);
}

fn void Jni.setStaticBooleanField(Jni* self, Jclass cls, JfieldID fieldID, Jboolean value) {
	self.vtable.setStaticBooleanFieldFn(self.env, cls, fieldID, value);
}

fn void Jni.setStaticByteField(Jni* self, Jclass cls, JfieldID fieldID, Jbyte value) {
	self.vtable.setStaticByteFieldFn(self.env, cls, fieldID, value);
}

fn void Jni.setStaticCharField(Jni* self, Jclass cls, JfieldID fieldID, Jchar value) {
	self.vtable.setStaticCharFieldFn(self.env, cls, fieldID, value);
}

fn void Jni.setStaticShortField(Jni* self, Jclass cls, JfieldID fieldID, Jshort value) {
	self.vtable.setStaticShortFieldFn(self.env, cls, fieldID, value);
}

fn void Jni.setStaticIntField(Jni* self, Jclass cls, JfieldID fieldID, Jint value) {
	self.vtable.setStaticIntFieldFn(self.env, cls, fieldID, value);
}

fn void Jni.setStaticLongField(Jni* self, Jclass cls, JfieldID fieldID, Jlong value) {
	self.vtable.setStaticLongFieldFn(self.env, cls, fieldID, value);
}

fn void Jni.setStaticFloatField(Jni* self, Jclass cls, JfieldID fieldID, Jfloat value) {
	self.vtable.setStaticFloatFieldFn(self.env, cls, fieldID, value);
}

fn void Jni.setStaticDoubleField(Jni* self, Jclass cls, JfieldID fieldID, Jdouble value) {
	self.vtable.setStaticDoubleFieldFn(self.env, cls, fieldID, value);
}

fn Jstring Jni.newString(Jni* self, char* bytes) {
	return self.vtable.newStringFn(self.env, bytes);
}

fn Jsize Jni.getStringLength(Jni* self, Jstring str) {
	return self.vtable.getStringLengthFn(self.env, str);
}

fn char* Jni.getStringChars(Jni* self, Jstring str, Jboolean* isCopy) {
	return self.vtable.getStringCharsFn(self.env, str, isCopy);
}

fn void Jni.releaseStringChars(Jni* self, Jstring str, char* chars) {
	self.vtable.releaseStringCharsFn(self.env, str, chars);
}

fn Jstring Jni.newStringUTF(Jni* self, char* bytes) {
	return self.vtable.newStringUTFFn(self.env, bytes);
}

fn Jsize Jni.getStringUTFLength(Jni* self, Jstring str) {
	return self.vtable.getStringUTFLengthFn(self.env, str);
}

fn char* Jni.getStringUTFChars(Jni* self, Jstring str, Jboolean* isCopy) {
	return self.vtable.getStringUTFCharsFn(self.env, str, isCopy);
}

fn void Jni.releaseStringUTFChars(Jni* self, Jstring str, char* chars) {
	self.vtable.releaseStringUTFCharsFn(self.env, str, chars);
}

fn Jsize Jni.getArrayLength(Jni* self, Jarray array) {
	return self.vtable.getArrayLengthFn(self.env, array);
}

fn JobjectArray Jni.newObjectArray(Jni* self, Jsize length, Jclass elementClass, Jobject initialElement) {
	return self.vtable.newObjectArrayFn(self.env, length, elementClass, initialElement);
}

fn Jobject Jni.getObjectArrayElement(Jni* self, JobjectArray array, Jsize index) {
	return self.vtable.getObjectArrayElementFn(self.env, array, index);
}

fn void Jni.setObjectArrayElement(Jni* self, JobjectArray array, Jsize index, Jobject value) {
	self.vtable.setObjectArrayElementFn(self.env, array, index, value);
}

fn JbooleanArray Jni.newBooleanArray(Jni* self, Jsize length) {
	return self.vtable.newBooleanArrayFn(self.env, length);
}

fn JbyteArray Jni.newByteArray(Jni* self, Jsize length) {
	return self.vtable.newByteArrayFn(self.env, length);
}

fn JcharArray Jni.newCharArray(Jni* self, Jsize length) {
	return self.vtable.newCharArrayFn(self.env, length);
}

fn JshortArray Jni.newShortArray(Jni* self, Jsize length) {
	return self.vtable.newShortArrayFn(self.env, length);
}

fn JintArray Jni.newIntArray(Jni* self, Jsize length) {
	return self.vtable.newIntArrayFn(self.env, length);
}

fn JlongArray Jni.newLongArray(Jni* self, Jsize length) {
	return self.vtable.newLongArrayFn(self.env, length);
}

fn JfloatArray Jni.newFloatArray(Jni* self, Jsize length) {
	return self.vtable.newFloatArrayFn(self.env, length);
}

fn JdoubleArray Jni.newDoubleArray(Jni* self, Jsize length) {
	return self.vtable.newDoubleArrayFn(self.env, length);
}

fn Jboolean* Jni.getBooleanArrayElements(Jni* self, JbooleanArray array, Jboolean* isCopy) {
	return self.vtable.getBooleanArrayElementsFn(self.env, array, isCopy);
}

fn Jbyte* Jni.getByteArrayElements(Jni* self, JbyteArray array, Jboolean* isCopy) {
	return self.vtable.getByteArrayElementsFn(self.env, array, isCopy);
}

fn Jchar* Jni.getCharArrayElements(Jni* self, JcharArray array, Jboolean* isCopy) {
	return self.vtable.getCharArrayElementsFn(self.env, array, isCopy);
}

fn Jshort* Jni.getShortArrayElements(Jni* self, JshortArray array, Jboolean* isCopy) {
	return self.vtable.getShortArrayElementsFn(self.env, array, isCopy);
}

fn Jint* Jni.getIntArrayElements(Jni* self, JintArray array, Jboolean* isCopy) {
	return self.vtable.getIntArrayElementsFn(self.env, array, isCopy);
}

fn Jlong* Jni.getLongArrayElements(Jni* self, JlongArray array, Jboolean* isCopy) {
	return self.vtable.getLongArrayElementsFn(self.env, array, isCopy);
}

fn Jfloat* Jni.getFloatArrayElements(Jni* self, JfloatArray array, Jboolean* isCopy) {
	return self.vtable.getFloatArrayElementsFn(self.env, array, isCopy);
}

fn Jdouble* Jni.getDoubleArrayElements(Jni* self, JdoubleArray array, Jboolean* isCopy) {
	return self.vtable.getDoubleArrayElementsFn(self.env, array, isCopy);
}

fn void Jni.releaseBooleanArrayElements(Jni* self, JbooleanArray array, Jboolean* elems, Jint mode) {
	self.vtable.releaseBooleanArrayElementsFn(self.env, array, elems, mode);
}

fn void Jni.releaseByteArrayElements(Jni* self, JbyteArray array, Jbyte* elems, Jint mode) {
	self.vtable.releaseByteArrayElementsFn(self.env, array, elems, mode);
}

fn void Jni.releaseCharArrayElements(Jni* self, JcharArray array, Jchar* elems, Jint mode) {
	self.vtable.releaseCharArrayElementsFn(self.env, array, elems, mode);
}

fn void Jni.releaseShortArrayElements(Jni* self, JshortArray array, Jshort* elems, Jint mode) {
	self.vtable.releaseShortArrayElementsFn(self.env, array, elems, mode);
}

fn void Jni.releaseIntArrayElements(Jni* self, JintArray array, Jint* elems, Jint mode) {
	self.vtable.releaseIntArrayElementsFn(self.env, array, elems, mode);
}

fn void Jni.releaseLongArrayElements(Jni* self, JlongArray array, Jlong* elems, Jint mode) {
	self.vtable.releaseLongArrayElementsFn(self.env, array, elems, mode);
}

fn void Jni.releaseFloatArrayElements(Jni* self, JfloatArray array, Jfloat* elems, Jint mode) {
	self.vtable.releaseFloatArrayElementsFn(self.env, array, elems, mode);
}

fn void Jni.releaseDoubleArrayElements(Jni* self, JdoubleArray array, Jdouble* elems, Jint mode) {
	self.vtable.releaseDoubleArrayElementsFn(self.env, array, elems, mode);
}

fn void Jni.getBooleanArrayRegion(Jni* self, JbooleanArray array, Jsize start, Jsize len, Jboolean *buf) {
	self.vtable.getBooleanArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.getByteArrayRegion(Jni* self, JbyteArray array, Jsize start, Jsize len, Jbyte *buf) {
	self.vtable.getByteArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.getCharArrayRegion(Jni* self, JcharArray array, Jsize start, Jsize len, Jchar *buf) {
	self.vtable.getCharArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.getShortArrayRegion(Jni* self, JshortArray array, Jsize start, Jsize len, Jshort *buf) {
	self.vtable.getShortArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.getIntArrayRegion(Jni* self, JintArray array, Jsize start, Jsize len, Jint *buf) {
	self.vtable.getIntArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.getLongArrayRegion(Jni* self, JlongArray array, Jsize start, Jsize len, Jlong *buf) {
	self.vtable.getLongArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.getFloatArrayRegion(Jni* self, JfloatArray array, Jsize start, Jsize len, Jfloat *buf) {
	self.vtable.getFloatArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.getDoubleArrayRegion(Jni* self, JdoubleArray array, Jsize start, Jsize len, Jdouble *buf) {
	self.vtable.getDoubleArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.setBooleanArrayRegion(Jni* self, JbooleanArray array, Jsize start, Jsize len, Jboolean *buf) {
    self.vtable.setBooleanArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.setByteArrayRegion(Jni* self, JbyteArray array, Jsize start, Jsize len, Jbyte *buf) {
    self.vtable.setByteArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.setCharArrayRegion(Jni* self, JcharArray array, Jsize start, Jsize len, Jchar *buf) {
    self.vtable.setCharArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.setShortArrayRegion(Jni* self, JshortArray array, Jsize start, Jsize len, Jshort *buf) {
    self.vtable.setShortArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.setIntArrayRegion(Jni* self, JintArray array, Jsize start, Jsize len, Jint *buf) {
    self.vtable.setIntArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.setLongArrayRegion(Jni* self, JlongArray array, Jsize start, Jsize len, Jlong *buf) {
    self.vtable.setLongArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.setFloatArrayRegion(Jni* self, JfloatArray array, Jsize start, Jsize len, Jfloat *buf) {
    self.vtable.setFloatArrayRegionFn(self.env, array, start, len, buf);
}

fn void Jni.setDoubleArrayRegion(Jni* self, JdoubleArray array, Jsize start, Jsize len, Jdouble *buf) {
    self.vtable.setDoubleArrayRegionFn(self.env, array, start, len, buf);
}

fn int Jni.registerNatives(Jni* self, Jclass clazz, JNINativeMethod* methods, int nMethods) {
    return self.vtable.registerNativesFn(self.env, clazz, methods, nMethods);
}

fn int Jni.unregisterNatives(Jni* self, Jclass clazz) {
    return self.vtable.unregisterNativesFn(self.env, clazz);
}

fn int Jni.monitorEnter(Jni* self, Jobject obj) {
    return self.vtable.monitorEnterFn(self.env, obj);
}


fn int Jni.monitorExit(Jni* self, Jobject obj) {
    return self.vtable.monitorExitFn(self.env, obj);
}

fn int Jni.getJavaVM(Jni* self, JavaVM** vm) {
    return self.vtable.getJavaVMFn(self.env, vm);
}

fn void Jni.getStringRegion(Jni* self, Jstring str, Jsize start, Jsize len, ushort* buf) {
    self.vtable.getStringRegionFn(self.env, str, start, len, buf);
}

fn void Jni.getStringUTFRegion(Jni* self, Jstring str, Jsize start, Jsize len, char* buf) {
    self.vtable.getStringUTFRegionFn(self.env, str, start, len, buf);
}

fn void* Jni.getPrimitiveArrayCritical(Jni* self, Jarray array, bool* isCopy) {
    return self.vtable.getPrimitiveArrayCriticalFn(self.env, array, isCopy);
}

fn void Jni.releasePrimitiveArrayCritical(Jni* self, Jarray array, void* carray, int mode) {
    self.vtable.releasePrimitiveArrayCriticalFn(self.env, array, carray, mode);
}

fn ushort* Jni.getStringCritical(Jni* self, Jstring string, bool* isCopy) {
    return self.vtable.getStringCriticalFn(self.env, string, isCopy);
}

fn void Jni.releaseStringCritical(Jni* self, Jstring string, ushort* cstring) {
    self.vtable.releaseStringCriticalFn(self.env, string, cstring);
}

fn Jweak Jni.newWeakGlobalRef(Jni* self, Jobject obj) {
    return self.vtable.newWeakGlobalRefFn(self.env, obj);
}

fn void Jni.deleteWeakGlobalRef(Jni* self, Jweak ref) {
    self.vtable.deleteWeakGlobalRefFn(self.env, ref);
}

fn bool Jni.exceptionCheck(Jni* self) {
    return self.vtable.exceptionCheckFn(self.env);
}

fn Jobject Jni.newDirectByteBuffer(Jni* self, void* address, long capacity) {
    return self.vtable.newDirectByteBufferFn(self.env, address, capacity);
}

fn void* Jni.getDirectBufferAddress(Jni* self, Jobject buf) {
    return self.vtable.getDirectBufferAddressFn(self.env, buf);
}

fn long Jni.getDirectBufferCapacity(Jni* self, Jobject buf) {
    return self.vtable.getDirectBufferCapacityFn(self.env, buf);
}

fn JobjectType Jni.getObjectRefType(Jni* self, Jobject obj) {
    return self.vtable.getObjectRefTypeFn(self.env, obj);
}

fn Jobject Jni.getModule(Jni* self, Jclass clazz) {
    return self.vtable.getModuleFn(self.env, clazz);
}

fn bool Jni.isVirtualThread(Jni* self, Jobject obj) {
    return self.vtable.isVirtualThreadFn(self.env, obj);
}