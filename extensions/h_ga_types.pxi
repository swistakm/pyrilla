cdef extern from "gorilla/ga.h":
    ctypedef struct ga_Format:
        int32 sampleRate
        int32 bitsPerSample
        int32 numChannels

    ctypedef struct ga_Device
    ctypedef struct ga_DataSource
    ctypedef struct ga_SampleSource

    ctypedef void (*tOnSeekFunc)(
        int32 in_sample, int32 in_delta, void* in_seekContext
    )
    ctypedef struct ga_Memory
    ctypedef struct ga_Sound

    ctypedef struct ga_Mixer
    ctypedef struct ga_Handle

    ctypedef void (*ga_FinishCallback)(
        ga_Handle* in_finishedHandle, void* in_context
    )

    ctypedef struct ga_StreamManager
    ctypedef struct ga_BufferedStream

    # constants declared with #define
    cdef int GA_VERSION_MAJOR
    cdef int GA_VERSION_MINOR
    cdef int GA_VERSION_REV

    cdef int GA_HANDLE_PARAM_UNKNOWN
    cdef int GA_HANDLE_PARAM_PAN
    cdef int GA_HANDLE_PARAM_PITCH
    cdef int GA_HANDLE_PARAM_GAIN

    cdef int GA_TELL_PARAM_CURRENT
    cdef int GA_TELL_PARAM_TOTAL

    cdef int GA_DEVICE_TYPE_DEFAULT
    cdef int GA_DEVICE_TYPE_UNKNOWN
    cdef int GA_DEVICE_TYPE_OPENAL
    cdef int GA_DEVICE_TYPE_DIRECTSOUND
    cdef int GA_DEVICE_TYPE_XAUDIO2

    cdef int GA_FLAG_SEEKABLE
    cdef int GA_FLAG_THREADSAFE
