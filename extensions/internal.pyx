cimport ga
cimport gau
cimport gc_common
cimport gc_thread

def initialize():
    gc_common.initialize(NULL)

# note: we initialize on start for simplicity, in future there may be
#       an option to specify memory allocation methods
# note: no need to case for shutdown
initialize()


cdef setFlagAndDestroyOnFinish(ga.ga_Handle* in_handle, void* in_context):
    cdef ga.gc_int32* flag = <ga.gc_int32*>(in_context)

    flag[0] = 1
    ga.handle_destroy(in_handle)


def play(filename, ext):
    """ example sound play
    :param filename:
    :param ext:
    :return:
    """
    cdef gau.gau_Manager* mgr
    cdef ga.ga_Mixer* mixer
    cdef ga.ga_Sound* sound
    cdef ga.ga_Handle* handle
    cdef gau.gau_SampleSourceLoop* loopSrc = NULL
    cdef gau.gau_SampleSourceLoop** pLoopSrc = &loopSrc
    cdef ga.gc_int32 loop = 0
    cdef ga.gc_int32 quit = 0


    mgr = gau.manager_create()
    mixer = gau.manager_mixer(mgr)

    if not loop:
        pLoopSrc = NULL

    sound = gau.load_sound_file(filename, ext)

    handle = gau.create_handle_sound(
        mixer, sound, <ga.ga_FinishCallback>&setFlagAndDestroyOnFinish, &quit, pLoopSrc)
    ga.handle_play(handle)

    while not quit:
        gau.manager_update(mgr)

        print(
            "%s / %s" % (
                ga.handle_tell(handle, ga.GA_TELL_PARAM_CURRENT),
                ga.handle_tell(handle, ga.GA_TELL_PARAM_TOTAL)
            )
        )
        gc_thread.thread_sleep(1)

    ga.sound_release(sound)
    gau.manager_destroy(mgr)


cdef class Sound(object):
   cdef ga.ga_Sound* sound

   def __init__(self):
       pass

   def __del__(self):
       """Release sound (gorilla uses refcounting for that)"""
       ga.sound_release(self.sound)
