
#ifndef H_MODULE_ONE
#define H_MODULE_ONE

// Put all your non-function header content here. Function declarations go
// below between the "#ifdef __cplusplus", so that this module is usable
// from a C++ project.

#define MODULE_ONE_VERSION       ("v1.1.1")

#ifdef __cplusplus
extern "C" {
#endif

   // Returns x * x
   int module_one_example (int x);


#ifdef __cplusplus
};
#endif

#endif

