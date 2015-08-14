from cpython cimport Py_DECREF, Py_INCREF

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

def update():
    default_manager.update()


cdef on_finish_callback(ga.Handle* in_handle, void* in_context):
    cdef CallbackContext context = <CallbackContext> in_context
    context.callback(context.sound)
    # note: it was casted on void* so we need to manually decrease
    #       reference counter
    Py_DECREF(context)
    ga.handle_destroy(in_handle)


cdef class CallbackContext(object):
    cdef object callback
    cdef Sound sound

    def __cinit__(self, object callback, Sound sound):
        self.callback = callback
        self.sound = sound


cdef class Manager(object):
    # c types
    cdef gau.Manager* p_manager
    DEF DEFAULT_BUFFERS_NUMBER = 4
    DEF DEFAULT_BUFFER_SAMPLES = 512

    def __cinit__(
            self,
            int device=ga.DEVICE_TYPE_DEFAULT,
            int thread_policy=gau.THREAD_POLICY_SINGLE,
            int buffers_number=DEFAULT_BUFFERS_NUMBER,
            int buffer_samples=DEFAULT_BUFFER_SAMPLES
    ):
        # note: we do not use gau.manager_create()
        #       instead of that we use the same defaults
        self.p_manager = gau.manager_create_custom(
            device,
            thread_policy,
            buffers_number,
            buffer_samples,
        )

    def update(self):
        gau.manager_update(self.p_manager)

    def __del__(self):
        gau.manager_destroy(self.p_manager)


cdef class Mixer(object):
    # c types
    cdef gau.Mixer* p_mixer
    # cython objects
    cdef Manager manager

    def __cinit__(self, Manager manager):
        self.manager = manager
        self.p_mixer = gau.manager_mixer(manager.p_manager)

    def __del__(self):
        ga.mixer_destroy(self.p_mixer)


cdef class Voice(object):
    # c types
    cdef int loop
    cdef gau.SampleSourceLoop* loop_src
    cdef ga.Handle* handle

    # cython types
    cdef Sound sound
    cdef Mixer mixer

    def __cinit__(
            self,
            Sound sound,
            object on_finish=None,
            int loop=False,
            Mixer mixer=None,
    ):
        cdef CallbackContext context

        self.sound = sound
        self.loop = loop

        self.mixer = mixer or default_mixer

        if on_finish:
            context = CallbackContext(on_finish, self.sound)

            # note: we are going to cast on void* so we need to manually
            #       control reference counters
            Py_INCREF(context)

            self.handle = gau.create_handle_sound(
               self.mixer.p_mixer,
               self.sound.sound,
               <ga.FinishCallback>&on_finish_callback,
               <void*>context,
               &self.loop_src if self.loop else NULL
            )

        else:
            self.handle = gau.create_handle_sound(
               self.mixer.p_mixer,
               self.sound.sound,
               <ga.FinishCallback>&gau.on_finish_destroy,
               NULL,
               &self.loop_src if self.loop else NULL
            )

    def play(self):
        ga.handle_play(self.handle)

    @property
    def playing(self):
        return bool(ga.handle_playing(self.handle))

    def stop(self):
        ga.handle_stop(self.handle)

    @property
    def stopped(self):
        return bool(ga.handle_stopped(self.handle))

    def __del__(self):
        ga.handle_destroy(self.handle)

    def toggle(self):
        if self.playing:
            self.stop()
        else:
            self.play()

    property pitch:
        def __get__(self):
            cdef ga.float32 value

            ga.handle_getParamf(self.handle, ga.HANDLE_PARAM_PITCH, &value)
            return value

        def __set__(self, ga.float32 value):
            ga.handle_setParamf(self.handle, ga.HANDLE_PARAM_PITCH, value)

    property gain:
        def __get__(self):
            cdef ga.float32 value

            ga.handle_getParamf(self.handle, ga.HANDLE_PARAM_GAIN, &value)
            return value

        def __set__(self, ga.float32 value):
            ga.handle_setParamf(self.handle, ga.HANDLE_PARAM_GAIN, value)

    property pan:
        def __get__(self):
            cdef ga.float32 value

            ga.handle_getParamf(self.handle, ga.HANDLE_PARAM_PAN, &value)
            return value

        def __set__(self, ga.float32 value):
            ga.handle_setParamf(self.handle, ga.HANDLE_PARAM_PAN, value)

cdef class Sound(object):
    cdef ga.Sound* sound

    def __cinit__(self):
        self.sound = NULL

    def __init__(self, filename, ext, stream=False):
        if not stream:
            self.sound = gau.load_sound_file(filename, ext)
        else:
            raise NotImplementedError("streams not implemented yet")

    def play(self, on_finish=None, mixer=None):
        cdef Voice voice

        voice = Voice(self, on_finish, 0, mixer)
        voice.play()

        return voice

    def __del__(self):
        """Release sound (gorilla uses refcounting for that)"""
        ga.sound_release(self.sound)

# default manager and mixer
default_manager = Manager()
default_mixer = Mixer(default_manager)

DEVICE_XAUDIO2 = ga.DEVICE_TYPE_XAUDIO2
DEVICE_DIRECTSOUND = ga.DEVICE_TYPE_DIRECTSOUND
DEVICE_OPENAL = ga.DEVICE_TYPE_OPENAL
DEVICE_DEFAULT = ga.DEVICE_TYPE_DEFAULT

THREAD_SINGLE = gau.THREAD_POLICY_SINGLE
THREAD_MULTI = gau.THREAD_POLICY_MULTI
