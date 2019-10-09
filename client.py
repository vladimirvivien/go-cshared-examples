from __future__ import print_function
from ctypes import *

lib = cdll.LoadLibrary("./awesome.so")

# describe and invoke Add()
lib.Add.argtypes = [c_longlong, c_longlong]
lib.Add.restype = c_longlong
print("awesome.Add(12,99) = %d" % lib.Add(12,99))

# describe and invoke Cosine()
lib.Cosine.argtypes = [c_double]
lib.Cosine.restype = c_double
print("awesome.Cosine(1) = %f" % lib.Cosine(1))

# define class GoSlice to map to:
# C type struct { void *data; GoInt len; GoInt cap; }
class GoSlice(Structure):
    _fields_ = [("data", POINTER(c_void_p)), ("len", c_longlong), ("cap", c_longlong)]

nums = GoSlice((c_void_p * 5)(74, 4, 122, 9, 12), 5, 5) 

# call Sort
lib.Sort.argtypes = [GoSlice]
lib.Sort.restype = None
lib.Sort(nums)
print("awesome.Sort(74,4,122,9,12) = %s" % [nums.data[i] for i in range(nums.len)])

# define class GoString to map:
# C type struct { const char *p; GoInt n; }
class GoString(Structure):
    _fields_ = [("p", c_char_p), ("n", c_longlong)]

# describe and call Log()
lib.Log.argtypes = [GoString]
lib.Log.restype = c_longlong
msg = GoString(b"Hello Python!", 13)
print("log id %d"% lib.Log(msg))

