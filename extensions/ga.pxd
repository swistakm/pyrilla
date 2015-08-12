include "h_gc_types.pxi"
include "h_ga_types.pxi"

cdef extern from "gorilla/ga.h":
    cdef int32 version_check "ga_version_check" (
        int32 in_major, int32 in_minor, int32 in_rev
    )

    cdef int32 format_sample "ga_format_sampleSize" (Format* in_format)

    cdef float32 format_toSeconds "ga_format_toSeconds" (
        Format* in_format, int32 in_samples
    )

    cdef int32 format_toSamples "ga_format_toSamples" (
        Format* in_format, float32 in_seconds
    )

    cdef Device* device_open "ga_device_open" (
        int32 in_type,
        int32 in_numBuffers,
        int32 in_numSamples,
        Format* in_format
    )

    cdef int32 device_check "ga_device_check" (Device* in_device)
    cdef result device_queue "ga_device_queue" (Device* in_device, void* in_buffer)
    cdef result device_close "ga_device_close" (Device* in_device)

    cdef int32 data_source_read "ga_data_source_read" (
        DataSource* in_dataSrc,
        void* in_dst,
        int32 in_size,
        int32 in_count
    )

    cdef int32 data_source_seek "ga_data_source_seek" (
        DataSource* in_dataSrc,
        int32 in_offset,
        int32 in_origin
    )

    cdef int32 data_source_tell "ga_data_source_tell" (DataSource* in_dataSrc)
    cdef int32 data_source_flags "ga_data_source_flags" (DataSource* in_dataSrc)
    cdef void data_source_acquire "ga_data_source_acquire" (DataSource* in_dataSrc)
    cdef void data_source_release "ga_data_source_release" (DataSource* in_dataSrc)

    cdef int32 sample_source_read "ga_sample_source_read" (
        SampleSource* in_sampleSrc,
        void* in_dst,
        int32 in_numSamples,
        tOnSeekFunc in_onSeekFunc,
        void* in_seekContext
    )

    cdef int32 sample_source_end "ga_sample_source_end" (SampleSource* in_sampleSrc)
    cdef int32 sample_source_ready "ga_sample_source_ready" (
        SampleSource* in_sampleSrc,
        int32 in_numSamples
    )

    cdef int32 sample_source_seek "ga_sample_source_seek" (
        SampleSource* in_sampleSrc,
        int32 in_sampleOffset
    )

    cdef int32 sample_source_tell "ga_sample_source_tell" (
        SampleSource* in_sampleSrc,
        int32* out_totalSamples
    )

    cdef int32 sample_source_flags "ga_sample_source_flags" (SampleSource* in_sampleSrc)
    cdef void sample_source_format "ga_sample_source_format" (
        SampleSource* in_sampleSrc,
        Format* out_format
    )

    cdef void sample_source_acquire "ga_sample_source_acquire" (SampleSource* in_sampleSrc)
    cdef void sample_source_release "ga_sample_source_release" (SampleSource* in_sampleSrc)

    cdef Memory* memory_create "ga_memory_create" (void* in_data, int32 in_size)
    cdef Memory* memory_create_data_source "ga_memory_create_data_source" (DataSource* in_dataSource)
    cdef int32 memory_size "ga_memory_size" (Memory* in_mem)

    cdef void* memory_data "ga_memory_data" (Memory* in_mem)

    cdef void memory_acquire "ga_memory_acquire" (Memory* in_mem)
    cdef void memory_release "ga_memory_release" (Memory* in_mem)

    cdef Sound* sound_create "ga_sound_create" (Memory* in_memory, Format* in_format)
    cdef Sound* sound_create_sample_source "ga_sound_create_sample_source" (SampleSource* in_sampleSrc)
    cdef void* sound_data "ga_sound_data" (Sound* in_sound)
    cdef int32 sound_size "ga_sound_size" (Sound* in_sound)

    cdef int32 sound_numSamples "ga_sound_numSamples" (Sound* in_sound)
    cdef void sound_format "ga_sound_format"(Sound* in_sound, Format* out_format)
    cdef void sound_acquire "ga_sound_acquire" (Sound* in_sound)
    cdef void sound_release "ga_sound_release"(Sound* in_sound)

    cdef Mixer* mixer_create "ga_mixer_create" (Format* in_format, int32 in_numSamples)
    cdef Format* mixer_format "ga_mixer_format" (Mixer* in_mixer)
    cdef int32 mixer_numSamples "ga_mixer_numSamples" (Mixer* in_mixer)
    cdef result mixer_mix "ga_mixer_mix" (Mixer* in_mixer, void* out_buffer)

    cdef result mixer_dispatch "ga_mixer_dispatch" (Mixer* in_mixer)
    cdef result mixer_destroy "ga_mixer_destroy" (Mixer* in_mixer)


    cdef Handle* handle_create "ga_handle_create" (Mixer* in_mixer, SampleSource* in_sampleSrc)
    cdef result handle_destroy "ga_handle_destroy" (Handle* in_handle)
    cdef result handle_play "ga_handle_play" (Handle* in_handle)
    cdef result handle_stop "ga_handle_stop" (Handle* in_handle)

    cdef int32 handle_playing "ga_handle_playing" (Handle* in_handle)
    cdef int32 handle_stopped "ga_handle_stopped" (Handle* in_handle)
    cdef int32 handle_finished "ga_handle_finished" (Handle* in_handle)
    cdef int32 handle_destroyed "ga_handle_destroyed" (Handle* in_handle)

    cdef result handle_setCallback "ga_handle_setCallback" (
        Handle* in_handle,
        FinishCallback in_callback,
        void* in_context
    )

    cdef result handle_setParamf "ga_handle_setParamf" (
        Handle* in_handle,
        int32 in_param,
        float32 in_value
    )

    cdef result handle_getParamf "ga_handle_getParamf" (
        Handle* in_handle,
        int32 in_param,
        float32* out_value
    )

    cdef result handle_setParami "ga_handle_setParami" (
        Handle* in_handle,
        int32 in_param,
        int32 in_value
    )

    cdef result handle_getParami "ga_handle_getParami" (
        Handle* in_handle,
        int32 in_param,
        int32* out_value
    )

    cdef result handle_seek "ga_handle_seek" (
        Handle* in_handle,
        int32 in_sampleOffset
    )

    cdef int32 handle_tell "ga_handle_tell" (
        Handle* in_handle,
        int32 in_param
    )

    cdef int32 handle_ready "ga_handle_ready" (
        Handle* in_handle,
        int32 in_numSamples
    )

    cdef void handle_format "ga_handle_format" (
        Handle* in_handle,
        Format* out_format
    )

    cdef StreamManager* stream_manager_create "ga_stream_manager_create" ()
    cdef void stream_manager_buffer "ga_stream_manager_buffer" (StreamManager* in_mgr)
    cdef void stream_manager_destroy "ga_stream_manager_destroy" (StreamManager* in_mgr)

    cdef BufferedStream* stream_create "ga_stream_create" (
        StreamManager* in_mgr,
        SampleSource* in_sampleSrc,
        int32 in_bufferSize
    )

    cdef void stream_produce "ga_stream_produce" (
        BufferedStream* in_stream
    )
    cdef int32 stream_read "ga_stream_read" (
        BufferedStream* in_stream,
        void* in_dst,
        int32 in_numSamples
    )

    cdef int32 stream_end "ga_stream_end" (BufferedStream* in_stream)

    cdef int32 stream_ready "ga_stream_ready" (
        BufferedStream* in_stream,
        int32 in_numSamples
    )

    cdef int32 stream_seek "ga_stream_seek" (
        BufferedStream* in_stream,
        int32 in_sampleOffset
    )

    cdef int32 stream_tell "ga_stream_tell" (
        BufferedStream* in_stream,
        int32* out_totalSamples
    )
    cdef int32 stream_flags "ga_stream_flags" (BufferedStream* in_stream)

    cdef void stream_acquire "ga_stream_acquire" (BufferedStream* in_stream)
    cdef void stream_release "ga_stream_release" (BufferedStream* in_stream)
