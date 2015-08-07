include "h_gc_types.pxi"
include "h_ga_types.pxi"
include "h_gau_types.pxi"

cdef extern from "gorilla/gau.h":
    cdef gau_Manager* gau_manager_create()

    cdef gau_Manager* gau_manager_create_custom(
        gc_int32 in_devType,
        gc_int32 in_threadPolicy,
        gc_int32 in_numBuffers,
        gc_int32 in_bufferSamples
    )

    cdef void gau_manager_update(gau_Manager* in_mgr)
    cdef ga_Mixer* gau_manager_mixer(gau_Manager* in_mgr)
    cdef ga_StreamManager* gau_manager_streamManager(gau_Manager* in_mgr)
    cdef ga_Device* gau_manager_device(gau_Manager* in_mgr)

    cdef void gau_manager_destroy(gau_Manager* in_mgr)
    cdef ga_DataSource* gau_data_source_create_file(const char* in_filename)
    cdef ga_DataSource* gau_data_source_create_file_arc(
        const char* in_filename,
        gc_int32 in_offset,
        gc_int32 in_size
    )

    cdef ga_DataSource* gau_data_source_create_memory(
        ga_Memory* in_memory
    )

    cdef ga_SampleSource* gau_sample_source_create_wav(
        ga_DataSource* in_dataSrc
    )

    cdef ga_SampleSource* gau_sample_source_create_ogg(
        ga_DataSource* in_dataSrc
    )

    cdef ga_SampleSource* gau_sample_source_create_buffered(
        ga_StreamManager* in_mgr,
        ga_SampleSource* in_sampleSrc,
        gc_int32 in_bufferSamples
    )

    cdef ga_SampleSource* gau_sample_source_create_sound(
        ga_Sound* in_sound
    )

    cdef gau_SampleSourceLoop* gau_sample_source_create_loop(
        ga_SampleSource* in_sampleSrc
    )

    cdef void gau_sample_source_loop_set(
        gau_SampleSourceLoop* in_sampleSrc,
        gc_int32 in_triggerSample,
        gc_int32 in_targetSample
    )

    cdef void gau_sample_source_loop_clear(gau_SampleSourceLoop* in_sampleSrc)

    cdef gc_int32 gau_sample_source_loop_count(
        gau_SampleSourceLoop* in_sampleSrc
    )

    cdef void gau_on_finish_destroy(
        ga_Handle* in_finishedHandle,
        void* in_context
    )

    cdef ga_Memory* gau_load_memory_file(const char* in_filename)
    cdef ga_Sound* gau_load_sound_file(
        const char* in_filename,
        const char* in_format
    )

    cdef ga_Handle* gau_create_handle_memory(
        ga_Mixer* in_mixer, ga_Memory* in_memory, const char* in_format,
        ga_FinishCallback in_callback, void* in_context,
        gau_SampleSourceLoop** out_loopSrc
    )

    cdef ga_Handle* gau_create_handle_sound(
        ga_Mixer* in_mixer,
        ga_Sound* in_sound,
        ga_FinishCallback in_callback,
        void* in_context,
        gau_SampleSourceLoop** out_loopSrc
    )

    cdef ga_Handle* gau_create_handle_buffered_data(
        ga_Mixer* in_mixer,
        ga_StreamManager* in_streamMgr,
        ga_DataSource* in_dataSrc,
        const char* in_format,
        ga_FinishCallback in_callback,
        void* in_context,
        gau_SampleSourceLoop** out_loopSrc
    )

    cdef ga_Handle* gau_create_handle_buffered_file(
        ga_Mixer* in_mixer,
        ga_StreamManager* in_streamMgr,
        const char* in_filename,
        const char* in_format,
        ga_FinishCallback in_callback,
        void* in_context,
        gau_SampleSourceLoop** out_loopSrc
    )
