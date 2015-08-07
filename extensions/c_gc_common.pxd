include "h_gc_types.pxi"

cdef extern from 'gorilla/common/gc_common.h':
    ctypedef struct gc_SystemOps:
        void* (*allocFunc)(gc_uint32 in_size)
        void* (*reallocFunc)(void* in_ptr, gc_uint32 in_size)
        void (*freeFunc)(void* in_ptr)

    cdef gc_result gc_initialize(gc_SystemOps* in_callbacks)

    cdef gc_result gc_shutdown()

    ctypedef struct gc_CircBuffer:
        gc_uint8* data
        gc_uint32 dataSize
        # note: no volatile modifiers here
        gc_uint32 nextAvail
        gc_uint32 nextFree

    cdef gc_CircBuffer* gc_buffer_create(gc_uint32 in_size)
    cdef gc_result gc_buffer_destroy(gc_CircBuffer* in_buffer)
    cdef gc_uint32 gc_buffer_bytesAvail(gc_CircBuffer* in_buffer)
    cdef gc_uint32 gc_buffer_bytesFree(gc_CircBuffer* in_buffer)

    cdef gc_result gc_buffer_getFree(
        gc_CircBuffer* in_buffer,
        gc_uint32 in_numBytes,
        void** out_dataA,
        gc_uint32* out_sizeA,
        void** out_dataB,
        gc_uint32* out_sizeB
    )

    cdef gc_result gc_buffer_write(
        gc_CircBuffer* in_buffer,
        void* in_data,
        gc_uint32 in_numBytes
    )

    cdef gc_result gc_buffer_getAvail(
        gc_CircBuffer* in_buffer,
        gc_uint32 in_numBytes,
        void** out_dataA,
        gc_uint32* out_sizeA,
        void** out_dataB,
        gc_uint32* out_sizeB
    )

    cdef void gc_buffer_read(
        gc_CircBuffer* in_buffer,
        void* in_data,
        gc_uint32 in_numBytes
    )

    cdef void gc_buffer_produce(
        gc_CircBuffer* in_buffer,
        gc_uint32 in_numBytes
    )

    cdef void gc_buffer_consume(
        gc_CircBuffer* in_buffer,
        gc_uint32 in_numBytes
    )

    ctypedef struct gc_Link:
        gc_Link* next
        gc_Link* prev
        void* data

    cdef void gc_list_head(gc_Link* in_head)
    cdef void gc_list_link(gc_Link* in_head, gc_Link* in_link, void* in_data)
    cdef void gc_list_unlink(gc_Link* in_link)
