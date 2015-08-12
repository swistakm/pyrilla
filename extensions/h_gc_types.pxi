cdef extern from "gorilla/common/gc_types.h":
    IF UNAME_SYSNAME == "Windows":
        ctypedef unsigned char     uint8 "gc_uint8"
        ctypedef unsigned short    uint16 "gc_uint16"
        ctypedef unsigned int      uint32 "gc_uint32"
        ctypedef signed char       int8 "gc_int8"
        ctypedef signed short      int16 "gc_int16"
        ctypedef signed int        int32 "gc_int32"
        ctypedef float             float32 "gc_float32"
        ctypedef double            float64 "gc_float64"

        # note: Cython will not accepts that but in the end we
        #       do not need those types in pyrilla and are going to build
        #       withc mingw instead of MSVC
        # ctypedef unsigned __int64  gc_uint64
        # ctypedef signed __int64    gc_int64

    ELSE:
        ctypedef unsigned char          uint8 "gc_uint8";
        ctypedef unsigned short         uint16 "gc_uint16";
        ctypedef unsigned int           uint32 "gc_uint32";
        ctypedef unsigned long long int uint64 "gc_uint64";
        ctypedef signed char            int8 "gc_int8";
        ctypedef signed short           int16 "gc_int16";
        ctypedef signed int             int32 "gc_int32";
        ctypedef signed long long int   int64 "gc_int64";
        ctypedef float                  float32 "gc_float32";
        ctypedef double                 float64 "gc_float64";

    ctypedef int32 result "gc_result"

    cdef int GC_FALSE
    cdef int GC_TRUE
    cdef int GC_SUCCESS
    cdef int GC_ERROR_GENERIC
