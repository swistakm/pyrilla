cdef extern from "gorilla/gau.h":
    ctypedef struct gau_Manager
    ctypedef struct gau_SampleSourceLoop

    ctypedef gau_SampleSourceLoop SampleSourceLoop "gau_SampleSourceLoop"  # prefixless
    ctypedef gau_Manager Manager "gau_Manager"  # prefixless

    cdef int THREAD_POLICY_UNKNOWN "GAU_THREAD_POLICY_UNKNOWN"
    cdef int THREAD_POLICY_SINGLE "GAU_THREAD_POLICY_SINGLE"
    cdef int THREAD_POLICY_MULTI "GAU_THREAD_POLICY_MULTI"
