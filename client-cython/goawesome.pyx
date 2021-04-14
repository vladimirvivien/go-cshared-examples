# cython: language_level=3
from cpython.mem cimport PyMem_Malloc, PyMem_Free
cimport awesome

cdef class _GoSlice:
    cdef awesome.GoSlice _slice
    cdef awesome.GoInt64* array
    def __init__(self, list data):
        cdef int count = 0
        self.array = <awesome.GoInt64*>PyMem_Malloc(len(data) * sizeof(awesome.GoInt64))
        if not self.array:
            raise MemoryError
        for i in data:
            self.array[count] = i
            count += 1
        self._slice.data = <void*> self.array
        self._slice.len = <awesome.GoInt> len(data)
        self._slice.cap = <awesome.GoInt> len(data)

    def __dealloc__(self):
        PyMem_Free(self.array)
        self.array == NULL

    @property
    def data(self):
        ret = []
        cdef int i
        for i in range(self._slice.len):
            ret.append((<awesome.GoInt64*> self._slice.data)[i])

        return ret

    @property
    def len(self):
        return self._slice.len

    @property
    def cap(self):
        return self._slice.cap

cdef class _GoString:
    cdef awesome.GoString _str
    def __init__(self, s):
        s = s.encode()
        self._str.p = <char*> s
        self._str.n = len(s)

def add(a, b):
    return awesome.Add(a, b)

def cosine(p0):
    return awesome.Cosine(p0)

def sort(p0):
    p = _GoSlice(p0)
    awesome.Sort(p._slice)
    return p.data

def log(p0):
    return awesome.Log(_GoString(p0)._str)
