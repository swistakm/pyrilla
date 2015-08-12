cdef extern from "gorilla/ga.h":
    ctypedef struct ga_Format:
        int32 sampleRate
        int32 bitsPerSample
        int32 numChannels
    ctypedef ga_Format Format "ga_Format"  # prefixless

    ctypedef struct ga_Device
    ctypedef ga_Device Device "ga_Device"  # prefixless

    ctypedef struct ga_DataSource
    ctypedef ga_DataSource DataSource "ga_DataSource"  # prefixless

    ctypedef struct ga_SampleSource
    ctypedef ga_SampleSource SampleSource "ga_SampleSource"  # prefixless

    ctypedef void (*tOnSeekFunc)(
        int32 in_sample, int32 in_delta, void* in_seekContext
    )

    ctypedef struct ga_Memory
    ctypedef ga_Memory Memory "ga_Memory"  # prefixless

    ctypedef struct ga_Sound
    ctypedef ga_Sound Sound "ga_Sound"  # prefixless

    ctypedef struct ga_Mixer
    ctypedef ga_Mixer Mixer "ga_Mixer"  # prefixless

    ctypedef struct ga_Handle
    ctypedef ga_Handle Handle "ga_Handle"  # prefixless

    ctypedef void (*ga_FinishCallback)(
        Handle* in_finishedHandle, void* in_context
    )
    ctypedef ga_FinishCallback FinishCallback "ga_FinishCallback"  # prefixless

    ctypedef struct ga_StreamManager
    ctypedef ga_StreamManager StreamManager "ga_StreamManager"  # prefixless

    ctypedef struct ga_BufferedStream
    ctypedef ga_BufferedStream BufferedStream "ga_BufferedStream"  # prefixless

    # constants declared with #define in prefixless versions
    cdef int VERSION_MAJOR "GA_VERSION_MAJOR"
    cdef int VERSION_MINOR "GA_VERSION_MINOR"
    cdef int VERSION_REV "GA_VERSION_REV"

    cdef int HANDLE_PARAM_UNKNOWN "GA_HANDLE_PARAM_UNKNOWN"
    cdef int HANDLE_PARAM_PAN "GA_HANDLE_PARAM_PAN"
    cdef int HANDLE_PARAM_PITCH "GA_HANDLE_PARAM_PITCH"
    cdef int HANDLE_PARAM_GAIN "GA_HANDLE_PARAM_GAIN"

    cdef int TELL_PARAM_CURRENT "GA_TELL_PARAM_CURRENT"
    cdef int TELL_PARAM_TOTAL "GA_TELL_PARAM_TOTAL"

    cdef int DEVICE_TYPE_DEFAULT "GA_DEVICE_TYPE_DEFAULT"
    cdef int DEVICE_TYPE_UNKNOWN "GA_DEVICE_TYPE_UNKNOWN"
    cdef int DEVICE_TYPE_OPENAL "GA_DEVICE_TYPE_OPENAL"
    cdef int DEVICE_TYPE_DIRECTSOUND "GA_DEVICE_TYPE_DIRECTSOUND"
    cdef int DEVICE_TYPE_XAUDIO2 "GA_DEVICE_TYPE_XAUDIO2"

    cdef int FLAG_SEEKABLE "GA_FLAG_SEEKABLE"
    cdef int FLAG_THREADSAFE "GA_FLAG_THREADSAFE"
