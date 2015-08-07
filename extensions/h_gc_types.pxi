cdef extern from "gorilla/common/gc_types.h":

    IF UNAME_SYSNAME == "Windows":
        ctypedef unsigned char     gc_uint8
        ctypedef unsigned short    gc_uint16
        ctypedef unsigned int      gc_uint32
        ctypedef signed char       gc_int8
        ctypedef signed short      gc_int16
        ctypedef signed int        gc_int32
        ctypedef float             gc_float32
        ctypedef double            gc_float64

        # note: Cython will not accepts that but in the end we
        #       do not need those types in pyrilla and are going to build
        #       withc mingw instead of MSVC
        # ctypedef unsigned __int64  gc_uint64
        # ctypedef signed __int64    gc_int64

    ELSE:
        ctypedef unsigned char          gc_uint8;
        ctypedef unsigned short         gc_uint16;
        ctypedef unsigned int           gc_uint32;
        ctypedef unsigned long long int gc_uint64;
        ctypedef signed char            gc_int8;
        ctypedef signed short           gc_int16;
        ctypedef signed int             gc_int32;
        ctypedef signed long long int   gc_int64;
        ctypedef float                  gc_float32;
        ctypedef double                 gc_float64;

    ctypedef gc_int32 gc_result

    DEF GC_FALSE = 0
    DEF GC_TRUE = 1
    DEF GC_SUCCESS = 1
    DEF GC_ERROR_GENERIC = -1
