include "h_gc_types.pxi"

cdef extern from 'gorilla/common/gc_thread.h':
    cdef int GC_THREAD_PRIORITY_NORMAL
    cdef int GC_THREAD_PRIORITY_LOW
    cdef int GC_THREAD_PRIORITY_HIGH
    cdef int GC_THREAD_PRIORITY_HIGHEST

    ctypedef int32 (*gc_ThreadFunc)(void* in_context);

    ctypedef struct gc_Thread:
        gc_ThreadFunc threadFunc
        void* threadObj
        void* context
        int32 id
        int32 priority
        int32 stackSize

    cdef gc_Thread* thread_create "gc_thread_create" (
        gc_ThreadFunc in_threadFunc,
        void* in_context,
        int32 in_priority,
        int32 in_stackSize
    )

    cdef void thread_run "gc_thread_run" (gc_Thread* in_thread)
    cdef void thread_join "gc_thread_join" (gc_Thread* in_thread)
    cdef void thread_sleep "gc_thread_sleep" (uint32 in_ms)
    cdef void thread_destroy "gc_thread_destroy" (gc_Thread* in_thread)

    ctypedef struct gc_Mutex:
        void* mutex

    cdef gc_Mutex* mutex_create "gc_mutex_create" ()
    cdef void mutex_lock "gc_mutex_lock" (gc_Mutex* in_mutex)
    cdef void mutex_unlock "gc_mutex_unlock" (gc_Mutex* in_mutex)
    cdef void mutex_destroy "gc_mutex_destroy" (gc_Mutex* in_mutex)
