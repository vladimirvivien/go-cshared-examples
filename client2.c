#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>

// type def
typedef long long go_int;
typedef double go_float64;
typedef struct{void *arr; go_int len; go_int cap;} go_slice;
typedef struct{const char *p; go_int len;} go_str;

int main(int argc, char **argv) {
    void *handle;
    char *error;

    // use dlopen to load shared object
    handle = dlopen ("awesomelib/awesome.so", RTLD_LAZY);
    if (!handle) {
        fputs (dlerror(), stderr);
        exit(1);
    }
    
    // lookup function symbols by name
    // and call the functions

    // Call  Add()
    go_int (*add)(go_int, go_int)  = dlsym(handle, "Add");
    if ((error = dlerror()) != NULL)  {
        fputs(error, stderr);
        exit(1);
    }
    go_int sum = (*add)(12, 99);
    printf("awesome.Add(12, 99) = %d\n", sum);

    // Call  Cosine()
    go_float64 (*cosine)(go_float64) = dlsym(handle, "Cosine");
    if ((error = dlerror()) != NULL)  {
        fputs(error, stderr);
        exit(1);
    }
    go_float64 cos = (*cosine)(1.0);
    printf("awesome.Cosine(1) = %f\n", cos);

    // Call Sort
    void (*sort)(go_slice) = dlsym(handle, "Sort");
    if ((error = dlerror()) != NULL)  {
        fputs(error, stderr);
        exit(1);
    }
    go_int data[5] = {44,23,7,66,2};
    go_slice nums = {data, 5, 5};
    sort(nums);
    printf("awesome.Sort(44,23,7,66,2): ");
    for (int i = 0; i < 5; i++){
        printf("%d,", ((go_int *)data)[i]);
    }
    printf("\n");

    // Call Log
    go_int (*log)(go_str) = dlsym(handle, "Log");
    if ((error = dlerror()) != NULL)  {
        fputs(error, stderr);
        exit(1);
    }
    go_str msg = {"Hello from C!", 13};
    log(msg);
    
    // close file handle when done
    dlclose(handle);
}
