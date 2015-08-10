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


cdef setFlagAndDestroyOnFinish(c_ga.ga_Handle* in_handle, void* in_context):
    cdef c_ga.gc_int32* flag = <c_ga.gc_int32*>(in_context)

    flag[0] = 1
    c_ga.ga_handle_destroy(in_handle)


def play(filename, ext):
    """ example sound play
    :param filename:
    :param ext:
    :return:
    """
    cdef c_gau.gau_Manager* mgr
    cdef c_ga.ga_Mixer* mixer
    cdef c_ga.ga_Sound* sound
    cdef c_ga.ga_Handle* handle
    cdef c_gau.gau_SampleSourceLoop* loopSrc = NULL
    cdef c_gau.gau_SampleSourceLoop** pLoopSrc = &loopSrc
    cdef c_ga.gc_int32 loop = 0
    cdef c_ga.gc_int32 quit = 0


    mgr = c_gau.gau_manager_create()
    mixer = c_gau.gau_manager_mixer(mgr)

    if not loop:
        pLoopSrc = NULL

    sound = c_gau.gau_load_sound_file(filename, ext)

    handle = c_gau.gau_create_handle_sound(
        mixer, sound, <c_ga.ga_FinishCallback>&setFlagAndDestroyOnFinish, &quit, pLoopSrc)
    c_ga.ga_handle_play(handle)

    while not quit:
        c_gau.gau_manager_update(mgr)

        print(
            "%s / %s" % (
                c_ga.ga_handle_tell(handle, c_ga.GA_TELL_PARAM_CURRENT),
                c_ga.ga_handle_tell(handle, c_ga.GA_TELL_PARAM_TOTAL)
            )
        )
        c_gc_thread.gc_thread_sleep(1)

    c_ga.ga_sound_release(sound)
    c_gau.gau_manager_destroy(mgr)


cdef class Sound(object):
   cdef c_ga.ga_Sound* sound

   def __init__(self):
       pass

   def __del__(self):
       """Release sound (gorilla uses refcounting for that)"""
       c_ga.ga_sound_release(self.sound)
