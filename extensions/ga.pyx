cimport c_ga
cimport c_gau
cimport c_gc_common
cimport c_gc_thread


def initialize():
    c_gc_common.gc_initialize(NULL)

# note: we initialize on start for simplicity, in future there may be
#       an option to specify memory allocation methods
# note: no need to case for shutdown
initialize()


cdef class Sound():
    cdef c_ga.ga_Sound* sound

    def __init__(self):
        pass

    def __del__(self):
        """Release sound (gorilla uses refcounting for that)"""
        c_ga.ga_sound_release(self.sound)
