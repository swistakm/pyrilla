cdef extern from "gorilla/gau.h":
    ctypedef struct gau_Manager
    ctypedef struct gau_SampleSourceLoop

    ctypedef gau_SampleSourceLoop SampleSourceLoop "gau_SampleSourceLoop"  # prefixless
    ctypedef gau_Manager Manager "gau_Manager"  # prefixless
