include "h_gc_types.pxi"
include "h_ga_types.pxi"

cdef extern from "gorilla/ga.h":
    cdef gc_int32 ga_version_check(
        gc_int32 in_major, gc_int32 in_minor, gc_int32 in_rev
    )

    cdef gc_int32 ga_format_sampleSize(ga_Format* in_format)

    cdef gc_float32 ga_format_toSeconds(
        ga_Format* in_format, gc_int32 in_samples
    )

    cdef gc_int32 ga_format_toSamples(
        ga_Format* in_format, gc_float32 in_seconds
    )

    cdef ga_Device* ga_device_open(
        gc_int32 in_type,
        gc_int32 in_numBuffers,
        gc_int32 in_numSamples,
        ga_Format* in_format
    )

    cdef gc_int32 ga_device_check(ga_Device* in_device)
    cdef gc_result ga_device_queue(ga_Device* in_device, void* in_buffer)
    cdef gc_result ga_device_close(ga_Device* in_device)

    cdef gc_int32 ga_data_source_read(
        ga_DataSource* in_dataSrc,
        void* in_dst,
        gc_int32 in_size,
        gc_int32 in_count
    )

    cdef gc_int32 ga_data_source_seek(
        ga_DataSource* in_dataSrc,
        gc_int32 in_offset,
        gc_int32 in_origin
    )

    cdef gc_int32 ga_data_source_tell(ga_DataSource* in_dataSrc)
    cdef gc_int32 ga_data_source_flags(ga_DataSource* in_dataSrc)
    cdef void ga_data_source_acquire(ga_DataSource* in_dataSrc)
    cdef void ga_data_source_release(ga_DataSource* in_dataSrc)

    cdef gc_int32 ga_sample_source_read(
        ga_SampleSource* in_sampleSrc,
        void* in_dst,
        gc_int32 in_numSamples,
        tOnSeekFunc in_onSeekFunc,
        void* in_seekContext
    )

    cdef gc_int32 ga_sample_source_end(ga_SampleSource* in_sampleSrc)
    cdef gc_int32 ga_sample_source_ready(
        ga_SampleSource* in_sampleSrc,
        gc_int32 in_numSamples
    )

    cdef gc_int32 ga_sample_source_seek(
        ga_SampleSource* in_sampleSrc,
        gc_int32 in_sampleOffset
    )

    cdef gc_int32 ga_sample_source_tell(
        ga_SampleSource* in_sampleSrc,
        gc_int32* out_totalSamples
    )

    cdef gc_int32 ga_sample_source_flags(ga_SampleSource* in_sampleSrc)
    cdef void ga_sample_source_format(
        ga_SampleSource* in_sampleSrc,
        ga_Format* out_format
    )

    cdef void ga_sample_source_acquire(ga_SampleSource* in_sampleSrc)
    cdef void ga_sample_source_release(ga_SampleSource* in_sampleSrc)

    cdef ga_Memory* ga_memory_create(void* in_data, gc_int32 in_size)
    cdef ga_Memory* ga_memory_create_data_source(ga_DataSource* in_dataSource)
    cdef gc_int32 ga_memory_size(ga_Memory* in_mem)

    cdef void* ga_memory_data(ga_Memory* in_mem)

    cdef void ga_memory_acquire(ga_Memory* in_mem)
    cdef void ga_memory_release(ga_Memory* in_mem)

    cdef ga_Sound* ga_sound_create(ga_Memory* in_memory, ga_Format* in_format)
    cdef ga_Sound* ga_sound_create_sample_source(ga_SampleSource* in_sampleSrc)
    cdef void* ga_sound_data(ga_Sound* in_sound)
    cdef gc_int32 ga_sound_size(ga_Sound* in_sound)

    cdef gc_int32 ga_sound_numSamples(ga_Sound* in_sound)
    cdef void ga_sound_format(ga_Sound* in_sound, ga_Format* out_format)
    cdef void ga_sound_acquire(ga_Sound* in_sound)
    cdef void ga_sound_release(ga_Sound* in_sound)

    cdef ga_Mixer* ga_mixer_create(ga_Format* in_format, gc_int32 in_numSamples)
    cdef ga_Format* ga_mixer_format(ga_Mixer* in_mixer)
    cdef gc_int32 ga_mixer_numSamples(ga_Mixer* in_mixer)
    cdef gc_result ga_mixer_mix(ga_Mixer* in_mixer, void* out_buffer)

    cdef gc_result ga_mixer_dispatch(ga_Mixer* in_mixer)
    cdef gc_result ga_mixer_destroy(ga_Mixer* in_mixer)


    cdef ga_Handle* ga_handle_create(ga_Mixer* in_mixer, ga_SampleSource* in_sampleSrc)
    cdef gc_result ga_handle_destroy(ga_Handle* in_handle)
    cdef gc_result ga_handle_play(ga_Handle* in_handle)
    cdef gc_result ga_handle_stop(ga_Handle* in_handle)

    cdef gc_int32 ga_handle_playing(ga_Handle* in_handle)
    cdef gc_int32 ga_handle_stopped(ga_Handle* in_handle)
    cdef gc_int32 ga_handle_finished(ga_Handle* in_handle)
    cdef gc_int32 ga_handle_destroyed(ga_Handle* in_handle)

    cdef gc_result ga_handle_setCallback(
        ga_Handle* in_handle,
        ga_FinishCallback in_callback,
        void* in_context
    )

    cdef gc_result ga_handle_setParamf(
        ga_Handle* in_handle,
        gc_int32 in_param,
        gc_float32 in_value
    )

    cdef gc_result ga_handle_getParamf(
        ga_Handle* in_handle,
        gc_int32 in_param,
        gc_float32* out_value
    )

    cdef gc_result ga_handle_setParami(
        ga_Handle* in_handle,
        gc_int32 in_param,
        gc_int32 in_value
    )

    cdef gc_result ga_handle_getParami(
        ga_Handle* in_handle,
        gc_int32 in_param,
        gc_int32* out_value
    )

    cdef gc_result ga_handle_seek(
        ga_Handle* in_handle,
        gc_int32 in_sampleOffset
    )

    cdef gc_int32 ga_handle_tell(
        ga_Handle* in_handle,
        gc_int32 in_param
    )

    cdef gc_int32 ga_handle_ready(
        ga_Handle* in_handle,
        gc_int32 in_numSamples
    )

    cdef void ga_handle_format(
        ga_Handle* in_handle,
        ga_Format* out_format
    )

    cdef ga_StreamManager* ga_stream_manager_create()
    cdef void ga_stream_manager_buffer(ga_StreamManager* in_mgr)
    cdef void ga_stream_manager_destroy(ga_StreamManager* in_mgr)

    cdef ga_BufferedStream* ga_stream_create(
        ga_StreamManager* in_mgr,
        ga_SampleSource* in_sampleSrc,
        gc_int32 in_bufferSize
    )

    cdef void ga_stream_produce(
        ga_BufferedStream* in_stream
    )
    cdef gc_int32 ga_stream_read(
        ga_BufferedStream* in_stream,
        void* in_dst,
        gc_int32 in_numSamples
    )

    cdef gc_int32 ga_stream_end(ga_BufferedStream* in_stream)

    cdef gc_int32 ga_stream_ready(
        ga_BufferedStream* in_stream,
        gc_int32 in_numSamples
    )

    cdef gc_int32 ga_stream_seek(
        ga_BufferedStream* in_stream,
        gc_int32 in_sampleOffset
    )

    cdef gc_int32 ga_stream_tell(
        ga_BufferedStream* in_stream,
        gc_int32* out_totalSamples
    )
    cdef gc_int32 ga_stream_flags(ga_BufferedStream* in_stream)

    cdef void ga_stream_acquire(ga_BufferedStream* in_stream)
    cdef void ga_stream_release(ga_BufferedStream* in_stream)
