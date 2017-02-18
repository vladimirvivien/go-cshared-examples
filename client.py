from ctypes import *

lib = cdll.LoadLibrary("awesomelib/awesome.so")

# call Add
lib.Add.argtypes = [c_longlong, c_longlong] # proper param types 
print "awesome.Add(12,99) = %d" % lib.Add(12,99)

# call Cosine
lib.Cosine.argtypes = [c_double]
lib.Cosine.restype = c_double # specify return type, assumes int
print "awesome.Cosine(1) = %f" % lib.Cosine(1)

# call Sort
# define GoSlice class from 
# C typedef struct { void *data; GoInt len; GoInt cap; } GoSlice;
class GoSlice(Structure):
    _fields_ = [("data", POINTER(c_void_p)), ("len", c_longlong), ("cap", c_longlong)]

nums = GoSlice((c_void_p * 5)(74, 4, 122, 9, 12), 5, 5) 

lib.Sort.argtypes = [GoSlice]
lib.Sort.restype = None
lib.Sort(nums)
print "awesome.Sort(74,4,122,9,12) = [",
for i in range(nums.len):
    print "%d "% nums.data[i],
print "]"

# call Log
# define GoString from
# C typedef struct { const char *p; GoInt n; } GoString;
class GoString(Structure):
    _fields_ = [("p", c_char_p), ("n", c_longlong)]

lib.Log.argtypes = [GoString]
msg = GoString(b"Hello Python!", 13)
print "log id %d"% lib.Log(msg)

