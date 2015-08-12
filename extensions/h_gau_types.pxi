cdef extern from "gorilla/gau.h":
    ctypedef struct gau_Manager
    ctypedef struct gau_SampleSourceLoop

    # rename to avoid prefixes
    ctypedef gau_SampleSourceLoop SampleSourceLoop "gau_SampleSourceLoop"
    ctypedef gau_Manager Manager "gau_Manager"
