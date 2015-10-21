from cpython cimport Py_DECREF, Py_INCREF

cimport ga
cimport gau
cimport gc_common


class SoundIOError(IOError):
    """
    Raised when gorilla-audio can not load the sound from some reason
    (e.g. wrong format, file does not exist)
    """


class DeviceNotSupportedError(RuntimeError):
    """
    Raised on attempt to access not supported device type
    """


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
    # python objects
    cdef object callback
    cdef Sound sound

    def __cinit__(self, object callback, Sound sound):
        self.callback = callback
        self.sound = sound


cdef class Manager(object):
    # c types
    cdef gau.gau_Manager* p_manager
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
        #       as this function
        self.p_manager = <gau.Manager*> gau.manager_create_custom(
            device,
            thread_policy,
            buffers_number,
            buffer_samples,
        )

        if gau.manager_device(self.p_manager) == NULL:
            raise DeviceNotSupportedError("This device is not supoprted")

    def update(self):
        gau.manager_update(self.p_manager)

    def __del__(self):
        gau.manager_destroy(self.p_manager)


cdef class Mixer(object):
    # c types
    cdef gau.Mixer* p_mixer

    # python objects
    cdef Manager manager

    def __cinit__(self, Manager manager):
        self.manager = manager
        self.p_mixer = gau.manager_mixer(manager.p_manager)

    def __del__(self):
        ga.mixer_destroy(self.p_mixer)


cdef class Voice(object):
    """
    ``Voice()`` class represents single playback of given sound. There may be
    many ``Voice()`` instances  for single sound playing at any time but one
    file/stream should be (mostly) represented by only single ``Sound()``
    object.

    Voice's pitch, gain and pan can be controlled by adequate attributes.
    It also can be stopped/played at any time.

    Looping parameter changes the life-cycle of a voice handle:

    * ``loop=False``: it is a single one-shot voice that when finished
      cannot be replayed again. ``on_finish`` callback can be attached
      to such sound and it will be fired when voice ends to play.
    * ``loop=True``: voice loops indefinitely. ``on_finish`` callback will
      be never fired.

    Args:

        sound (pyrilla.Sound): sound instance as a data source of voice.
        on_finish (callable): callback to be fired when voice finishes
            to play (only if ``loop=False``). Callback must accept single
            argument that is sound instance.
        loop (bool): set to ``True`` if voice should be looped indefinitely.
        mixer (pyrilla.Mixer): Mixer that should be used to play new
            voice. ``None`` value means the default mixer created
            on module nitialization.

    Example:

    .. code-block:: python

        from pyrilla import core

        sound = core.Sound("soundfile.ogg", "ogg")
        voice = core.Voice(sound, loop=True)
        voice.play()

        while True:
            # update internal state of default audio manager and mixer
            # this mixes all currently played sounds, pushes buffers etc.
            core.update()
    """
    # c types
    cdef int loop
    cdef gau.SampleSourceLoop* p_loop_src
    cdef ga.Handle* p_handle

    # python objects
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

            self.p_handle = gau.create_handle_sound(
               self.mixer.p_mixer,
               self.sound.p_sound,
               <ga.FinishCallback>&on_finish_callback,
               <void*>context,
               &self.p_loop_src if self.loop else NULL
            )

        else:
            self.p_handle = gau.create_handle_sound(
               self.mixer.p_mixer,
               self.sound.p_sound,
               <ga.FinishCallback>&gau.on_finish_destroy,
               NULL,
               &self.p_loop_src if self.loop else NULL
            )

    def play(self):
        """
        Set state of this voice to "playing" no matter of current state.
        """
        ga.handle_play(self.p_handle)

    @property
    def playing(self):
        """
        ``True`` if sound is currently in "playing" state otherwise ``False``.
        """
        return bool(ga.handle_playing(self.p_handle))

    def stop(self):
        """
        Set state of this voice to "stopped" no matter of current state.
        """
        ga.handle_stop(self.p_handle)

    @property
    def stopped(self):
        """
        ``True`` if sound is currently in stopped state otherwise ``False``.
        """
        return bool(ga.handle_stopped(self.p_handle))

    def __del__(self):
        ga.handle_destroy(self.p_handle)

    def toggle(self):
        """
        Toggle between "playing/stopped" states.
        """
        if self.playing:
            self.stop()
        else:
            self.play()

    property pitch:
        """
        Voice pitch as a ``[0.0, 1.0]`` float value.
        """
        def __get__(self):
            cdef ga.float32 value

            ga.handle_getParamf(self.p_handle, ga.HANDLE_PARAM_PITCH, &value)
            return value

        def __set__(self, ga.float32 value):
            ga.handle_setParamf(self.p_handle, ga.HANDLE_PARAM_PITCH, value)

    property gain:
        """
        Voice gain as a ``[0.0, 1.0]`` float value.
        """
        def __get__(self):
            """fab"""
            cdef ga.float32 value

            ga.handle_getParamf(self.p_handle, ga.HANDLE_PARAM_GAIN, &value)
            return value

        def __set__(self, ga.float32 value):
            ga.handle_setParamf(self.p_handle, ga.HANDLE_PARAM_GAIN, value)

    property pan:
        """
        Voice pan as a ``[-1.0, 1.0]`` float value.
        """
        def __get__(self):
            cdef ga.float32 value

            ga.handle_getParamf(self.p_handle, ga.HANDLE_PARAM_PAN, &value)
            return value

        def __set__(self, ga.float32 value):
            ga.handle_setParamf(self.p_handle, ga.HANDLE_PARAM_PAN, value)


cdef class Sound(object):
    """
    ``Sound()`` class represents single instance of audio file/stream in
    program's memory. It is also capable of one-shot playback (i.e. without
    ability to loop).

    Args:

        filename (str): filename of file to load
        ext (str): audio file extension (only ``ogg`` and ``wav`` at
            the moment)
        stream (bool): set to ``True`` if this should be streamed instead
            of loaded as a whole to memery (useful for long audio playbacks)

    Example:

    .. code-block:: python

        from pyrilla import core

        sound = core.Sound("soundfile.ogg", "ogg")
        sound.play()

        while True:
            # update internal state of default audio manager and mixer
            # this mixes all currently played sounds, pushes buffers etc.
            core.update()

    """
    cdef ga.Sound* p_sound

    def __cinit__(self):
        self.p_sound = NULL

    def __init__(self, filename, ext, stream=False):
        if not stream:
            self.p_sound = gau.load_sound_file(filename, ext)
        else:
            raise NotImplementedError("streams not implemented yet")

        if self.p_sound == NULL:
            raise SoundIOError("could not load sound file %s as %s" % (filename, ext))

    def play(self, on_finish=None, mixer=None):
        """
        Create and return new playback handle (``Voice()`` class instance).
        This voice is already submitted to default or given mixer and will
        start playing with next audio manager update.

        Returned voice can be controlled (pitch/gain/pan or pause/play) as any
        other ``Voice()`` class instance.

        Args:

            on_finish (callable): callback to be fired when voice finishes
                to play. Callback must accept single argument that is sound
                instance.
            mixer (pyrilla.Mixer): Mixer that should be used to play new
                voice. ``None`` value means the default mixer created
                on module nitialization.

        Returns:

             ``pyrilla.Voice`` instance
        """
        cdef Voice voice

        voice = Voice(self, on_finish, 0, mixer)
        voice.play()

        return voice

    def __del__(self):
        """Release sound (gorilla-audio uses refcounting for that)"""
        ga.sound_release(self.p_sound)

# default manager and mixer
default_manager = Manager()
default_mixer = Mixer(default_manager)

DEVICE_XAUDIO2 = ga.DEVICE_TYPE_XAUDIO2
DEVICE_DIRECTSOUND = ga.DEVICE_TYPE_DIRECTSOUND
DEVICE_OPENAL = ga.DEVICE_TYPE_OPENAL
DEVICE_DEFAULT = ga.DEVICE_TYPE_DEFAULT

THREAD_SINGLE = gau.THREAD_POLICY_SINGLE
THREAD_MULTI = gau.THREAD_POLICY_MULTI
