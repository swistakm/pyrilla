include "h_gc_types.pxi"
include "h_ga_types.pxi"
include "h_gau_types.pxi"

cdef extern from "gorilla/gau.h":
    cdef Manager* manager_create "gau_manager_create" ()

    cdef Manager* manager_create_custom "gau_manager_create_custom" (
        int32 in_devType,
        int32 in_threadPolicy,
        int32 in_numBuffers,
        int32 in_bufferSamples
    )

    cdef void manager_update "gau_manager_update" (Manager* in_mgr)
    cdef Mixer* manager_mixer "gau_manager_mixer" (Manager* in_mgr)
    cdef StreamManager* manager_streamManager "gau_manager_streamManager" (Manager* in_mgr)
    cdef Device* manager_device "gau_manager_device" (Manager* in_mgr)

    cdef void manager_destroy "gau_manager_destroy" (Manager* in_mgr)
    cdef DataSource* data_source_create_file "gau_data_source_create_file" (const char* in_filename)
    cdef DataSource* data_source_create_file_arc "gau_data_source_create_file_arc" (
        const char* in_filename,
        int32 in_offset,
        int32 in_size
    )

    cdef DataSource* data_source_create_memory "gau_data_source_create_memory" (
        Memory* in_memory
    )

    cdef SampleSource* sample_source_create_wav "gau_sample_source_create_wav" (
        DataSource* in_dataSrc
    )

    cdef SampleSource* sample_source_create_ogg "gau_sample_source_create_ogg" (
        DataSource* in_dataSrc
    )

    cdef SampleSource* sample_source_create_buffered "gau_sample_source_create_buffered" (
        StreamManager* in_mgr,
        SampleSource* in_sampleSrc,
        int32 in_bufferSamples
    )

    cdef SampleSource* sample_source_create_sound "gau_sample_source_create_sound" (
        Sound* in_sound
    )

    cdef SampleSourceLoop* sample_source_create_loop "gau_sample_source_create_loop" (
        SampleSource* in_sampleSrc
    )

    cdef void sample_source_loop_set "gau_sample_source_loop_set" (
        SampleSourceLoop* in_sampleSrc,
        int32 in_triggerSample,
        int32 in_targetSample
    )

    cdef void sample_source_loop_clear "gau_sample_source_loop_clear" (SampleSourceLoop* in_sampleSrc)

    cdef int32 sample_source_loop_count "gau_sample_source_loop_count" (
        SampleSourceLoop* in_sampleSrc
    )

    cdef void on_finish_destroy "gau_on_finish_destroy" (
        Handle* in_finishedHandle,
        void* in_context
    )

    cdef Memory* load_memory_file "gau_load_memory_file" (const char* in_filename)
    cdef Sound* load_sound_file "gau_load_sound_file" (
        const char* in_filename,
        const char* in_format
    )

    cdef Handle* create_handle_memory "gau_create_handle_memory" (
        Mixer* in_mixer, Memory* in_memory, const char* in_format,
        FinishCallback in_callback, void* in_context,
        SampleSourceLoop** out_loopSrc
    )

    cdef Handle* create_handle_sound "gau_create_handle_sound" (
        Mixer* in_mixer,
        Sound* in_sound,
        FinishCallback in_callback,
        void* in_context,
        SampleSourceLoop** out_loopSrc
    )

    cdef Handle* create_handle_buffered_data "gau_create_handle_buffered_data" (
        Mixer* in_mixer,
        StreamManager* in_streamMgr,
        DataSource* in_dataSrc,
        const char* in_format,
        FinishCallback in_callback,
        void* in_context,
        SampleSourceLoop** out_loopSrc
    )

    cdef Handle* create_handle_buffered_file "gau_create_handle_buffered_file" (
        Mixer* in_mixer,
        StreamManager* in_streamMgr,
        const char* in_filename,
        const char* in_format,
        FinishCallback in_callback,
        void* in_context,
        SampleSourceLoop** out_loopSrc
    )
