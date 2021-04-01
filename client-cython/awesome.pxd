# cython: language_level=3
cdef extern from "awesome.h" nogil:
    ctypedef signed char GoInt8
    ctypedef unsigned char GoUint8
    ctypedef short GoInt16
    ctypedef unsigned short GoUint16
    ctypedef int GoInt32
    ctypedef unsigned int GoUint32
    ctypedef long long GoInt64
    ctypedef unsigned long long GoUint64
    ctypedef GoInt64 GoInt
    ctypedef GoUint64 GoUint
    ctypedef float GoFloat32
    ctypedef double GoFloat64

    ctypedef struct GoString:
        const char *p
        GoInt n

    ctypedef void *GoMap
    ctypedef void *GoChan
    ctypedef struct GoInterface:
        void *t
        void *v

    ctypedef struct GoSlice:
        void *data
        GoInt len
        GoInt cap

    GoInt Add(GoInt p0, GoInt p1)

    GoFloat64 Cosine(GoFloat64 p0)

    void Sort(GoSlice p0)

    GoInt Log(GoString p0)