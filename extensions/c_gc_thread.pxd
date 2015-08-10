include "h_gc_types.pxi"

cdef extern from 'gorilla/common/gc_thread.h':
    cdef int GC_THREAD_PRIORITY_NORMAL
    cdef int GC_THREAD_PRIORITY_LOW
    cdef int GC_THREAD_PRIORITY_HIGH
    cdef int GC_THREAD_PRIORITY_HIGHEST

    ctypedef gc_int32 (*gc_ThreadFunc)(void* in_context);

    ctypedef struct gc_Thread:
        gc_ThreadFunc threadFunc
        void* threadObj
        void* context
        gc_int32 id
        gc_int32 priority
        gc_int32 stackSize

    cdef gc_Thread* gc_thread_create(
        gc_ThreadFunc in_threadFunc,
        void* in_context,
        gc_int32 in_priority,
        gc_int32 in_stackSize
    )

    cdef void gc_thread_run(gc_Thread* in_thread)
    cdef void gc_thread_join(gc_Thread* in_thread)
    cdef void gc_thread_sleep(gc_uint32 in_ms)
    cdef void gc_thread_destroy(gc_Thread* in_thread)

    ctypedef struct gc_Mutex:
        void* mutex

    cdef gc_Mutex* gc_mutex_create()
    cdef void gc_mutex_lock(gc_Mutex* in_mutex)
    cdef void gc_mutex_unlock(gc_Mutex* in_mutex)
    cdef void gc_mutex_destroy(gc_Mutex* in_mutex)
