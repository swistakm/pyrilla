include "h_gc_types.pxi"
include "h_ga_types.pxi"
include "h_gau_types.pxi"

cdef extern from "gorilla/gau.h":
    cdef gau_Manager* manager_create "gau_manager_create" ()

    cdef gau_Manager* manager_create_custom "gau_manager_create_custom" (
        gc_int32 in_devType,
        gc_int32 in_threadPolicy,
        gc_int32 in_numBuffers,
        gc_int32 in_bufferSamples
    )

    cdef void manager_update "gau_manager_update" (gau_Manager* in_mgr)
    cdef ga_Mixer* manager_mixer "gau_manager_mixer" (gau_Manager* in_mgr)
    cdef ga_StreamManager* manager_streamManager "gau_manager_streamManager" (gau_Manager* in_mgr)
    cdef ga_Device* manager_device "gau_manager_device" (gau_Manager* in_mgr)

    cdef void manager_destroy "gau_manager_destroy" (gau_Manager* in_mgr)
    cdef ga_DataSource* data_source_create_file "gau_data_source_create_file" (const char* in_filename)
    cdef ga_DataSource* data_source_create_file_arc "gau_data_source_create_file_arc" (
        const char* in_filename,
        gc_int32 in_offset,
        gc_int32 in_size
    )

    cdef ga_DataSource* data_source_create_memory "gau_data_source_create_memory" (
        ga_Memory* in_memory
    )

    cdef ga_SampleSource* sample_source_create_wav "gau_sample_source_create_wav" (
        ga_DataSource* in_dataSrc
    )

    cdef ga_SampleSource* sample_source_create_ogg "gau_sample_source_create_ogg" (
        ga_DataSource* in_dataSrc
    )

    cdef ga_SampleSource* sample_source_create_buffered "gau_sample_source_create_buffered" (
        ga_StreamManager* in_mgr,
        ga_SampleSource* in_sampleSrc,
        gc_int32 in_bufferSamples
    )

    cdef ga_SampleSource* sample_source_create_sound "gau_sample_source_create_sound" (
        ga_Sound* in_sound
    )

    cdef gau_SampleSourceLoop* sample_source_create_loop "gau_sample_source_create_loop" (
        ga_SampleSource* in_sampleSrc
    )

    cdef void sample_source_loop_set "gau_sample_source_loop_set" (
        gau_SampleSourceLoop* in_sampleSrc,
        gc_int32 in_triggerSample,
        gc_int32 in_targetSample
    )

    cdef void sample_source_loop_clear "gau_sample_source_loop_clear" (gau_SampleSourceLoop* in_sampleSrc)

    cdef gc_int32 sample_source_loop_count "gau_sample_source_loop_count" (
        gau_SampleSourceLoop* in_sampleSrc
    )

    cdef void on_finish_destroy "gau_on_finish_destroy" (
        ga_Handle* in_finishedHandle,
        void* in_context
    )

    cdef ga_Memory* load_memory_file "gau_load_memory_file" (const char* in_filename)
    cdef ga_Sound* load_sound_file "gau_load_sound_file" (
        const char* in_filename,
        const char* in_format
    )

    cdef ga_Handle* create_handle_memory "gau_create_handle_memory" (
        ga_Mixer* in_mixer, ga_Memory* in_memory, const char* in_format,
        ga_FinishCallback in_callback, void* in_context,
        gau_SampleSourceLoop** out_loopSrc
    )

    cdef ga_Handle* create_handle_sound "gau_create_handle_sound" (
        ga_Mixer* in_mixer,
        ga_Sound* in_sound,
        ga_FinishCallback in_callback,
        void* in_context,
        gau_SampleSourceLoop** out_loopSrc
    )

    cdef ga_Handle* create_handle_buffered_data "gau_create_handle_buffered_data" (
        ga_Mixer* in_mixer,
        ga_StreamManager* in_streamMgr,
        ga_DataSource* in_dataSrc,
        const char* in_format,
        ga_FinishCallback in_callback,
        void* in_context,
        gau_SampleSourceLoop** out_loopSrc
    )

    cdef ga_Handle* create_handle_buffered_file "gau_create_handle_buffered_file" (
        ga_Mixer* in_mixer,
        ga_StreamManager* in_streamMgr,
        const char* in_filename,
        const char* in_format,
        ga_FinishCallback in_callback,
        void* in_context,
        gau_SampleSourceLoop** out_loopSrc
    )
