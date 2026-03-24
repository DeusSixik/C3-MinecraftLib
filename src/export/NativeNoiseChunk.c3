module mc_export::native_noise_chunk;

import jni;
import minecraft::noise;

fn void fillNoiseArrayDirectly(
    jni::JNIEnv env, 
    jni::Jobject obj, 
    long noise_ptr, 
    jni::JdoubleArray j_double_array, 
    int startX, 
    int startY, 
    int startZ, 
    int cellWidth, 
    int cellHeight, 
    double xzScale, 
    double yScale
) @export("Java_dev_sixik_generator_1accelerator_math_c3_NativeNoiseChunk_fillNoiseArrayDirectly") {
    
    if (noise_ptr == 0) return; 
    if (j_double_array == null) return;
    
    jni::Jni jni_context = { .env = env, .vtable = *env };
    
    int arr_len = jni_context.getArrayLength(j_double_array);
    int expected_len = cellHeight * cellWidth * cellWidth;
    
    if (expected_len <= 0 || expected_len > arr_len) {
        return; 
    }

    bool isCopy = false;
    double* ds = (double*)jni_context.getPrimitiveArrayCritical(j_double_array, &isCopy);
    if (ds == null) return; 
    
    noise::NormalNoise* noise = (noise::NormalNoise*)noise_ptr;
    
    int arrayIndex = 0;
    double base_x = (double)startX * xzScale;
    double base_y = (double)startY * yScale;
    double base_z = (double)startZ * xzScale;

    for (int i = cellHeight - 1; i >= 0; --i) {
        double currentY = base_y + (double)i * yScale;
        
        for (int j = 0; j < cellWidth; ++j) {
            double currentX = base_x + (double)j * xzScale;
            
            for (int k = 0; k < cellWidth; k += 4) {
                
                double[<4>] currentZ = {
                    base_z + (double)k * xzScale,
                    base_z + (double)(k + 1) * xzScale,
                    base_z + (double)(k + 2) * xzScale,
                    base_z + (double)(k + 3) * xzScale
                };
                
                double[<4>] results = noise.getValue4Z(currentX, currentY, currentZ);
                
                ds[arrayIndex++] = results[0];
                ds[arrayIndex++] = results[1];
                ds[arrayIndex++] = results[2];
                ds[arrayIndex++] = results[3];
            }
        }
    }
    
    jni_context.releasePrimitiveArrayCritical(j_double_array, ds, 0);
}