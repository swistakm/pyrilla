from cython.operator cimport dereference as deref
from python_ref cimport Py_DECREF, Py_INCREF

cimport ga
cimport gau
cimport gc_common

def initialize():
    gc_common.initialize(NULL)

# note: we initialize on start for simplicity, in future there may be
#       an option to specify memory allocation methods
# note: no need to case for shutdown
initialize()

cdef gau.Manager* global_manager = gau.manager_create()
cdef gau.Mixer* global_mixer = gau.manager_mixer(global_manager)

def update():
    gau.manager_update(global_manager)


cdef on_finish_callback(ga.Handle* in_handle, void* in_context):
    (<object>in_context)()
    print "after callback"
    ga.handle_destroy(in_handle)


ctypedef struct CallbackContext:
    void* callback
    void* sound


cdef class Sound(object):
    cdef ga.Sound* sound
    cdef ga.Handle* handle

    def __cinit__(self):
        self.sound = NULL
        self.handle = NULL

    def __init__(
        self,
        filename,
        ext,
        stream=False,
    ):
        if not stream:
            self.sound = gau.load_sound_file(filename, ext)
        else:
            raise NotImplementedError("streams ntt implemented yet")

    def play(self, on_finish=None):
        cdef ga.Handle* handle

        if on_finish:
            handle = gau.create_handle_sound(
               global_mixer,
               self.sound,
               <ga.FinishCallback>&on_finish_callback,
               <void*>on_finish,
               NULL
            )
        else:
            handle = gau.create_handle_sound(
               global_mixer,
               self.sound,
               <ga.FinishCallback>&gau.on_finish_destroy,
               NULL,
               NULL
            )

        ga.handle_play(handle)

    def __del__(self):
        """Release sound (gorilla uses refcounting for that)"""
        ga.sound_release(self.sound)
