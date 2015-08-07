cdef extern from "gorilla/ga.h":
    # these are likely to change so define using cdef
    cdef int GA_VERSION_MAJOR
    cdef int GA_VERSION_MINOR
    cdef int GA_VERSION_REV

    DEF GA_FLAG_SEEKABLE = 1
    DEF GA_FLAG_THREADSAFE = 2

    ctypedef struct ga_Format:
        gc_int32 sampleRate
        gc_int32 bitsPerSample
        gc_int32 numChannels

    DEF GA_DEVICE_TYPE_DEFAULT = -1
    DEF GA_DEVICE_TYPE_UNKNOWN = 0
    DEF GA_DEVICE_TYPE_OPENAL = 1
    DEF GA_DEVICE_TYPE_DIRECTSOUND = 2
    DEF GA_DEVICE_TYPE_XAUDIO2 = 3

    ctypedef struct ga_Device
    ctypedef struct ga_DataSource
    ctypedef struct ga_SampleSource

    ctypedef void (*tOnSeekFunc)(
        gc_int32 in_sample, gc_int32 in_delta, void* in_seekContext
    )
    ctypedef struct ga_Memory
    ctypedef struct ga_Sound

    ctypedef struct ga_Mixer
    ctypedef struct ga_Handle

    DEF GA_HANDLE_PARAM_UNKNOWN = 0
    DEF GA_HANDLE_PARAM_PAN = 1
    DEF GA_HANDLE_PARAM_PITCH = 2
    DEF GA_HANDLE_PARAM_GAIN = 3

    DEF GA_TELL_PARAM_CURRENT = 0
    DEF GA_TELL_PARAM_TOTAL = 1

    ctypedef void (*ga_FinishCallback)(
        ga_Handle* in_finishedHandle, void* in_context
    )

    ctypedef struct ga_StreamManager
    ctypedef struct ga_BufferedStream

