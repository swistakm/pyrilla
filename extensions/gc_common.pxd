include "h_gc_types.pxi"

cdef extern from 'gorilla/common/gc_common.h':
    ctypedef struct gc_SystemOps:
        void* (*allocFunc)(uint32 in_size)
        void* (*reallocFunc)(void* in_ptr, uint32 in_size)
        void (*freeFunc)(void* in_ptr)

    cdef result initialize "gc_initialize" (gc_SystemOps* in_callbacks)

    cdef result shutdown "gc_shutdown" ()

    ctypedef struct gc_CircBuffer:
        uint8* data
        uint32 dataSize
        # note: no volatile modifiers here
        uint32 nextAvail
        uint32 nextFree

    cdef gc_CircBuffer* buffer_create "gc_buffer_create" (uint32 in_size)
    cdef result buffer_destroy "gc_buffer_destroy" (gc_CircBuffer* in_buffer)
    cdef uint32 buffer_bytesAvail "gc_buffer_bytesAvail" (gc_CircBuffer* in_buffer)
    cdef uint32 buffer_bytesFree "gc_buffer_bytesFree" (gc_CircBuffer* in_buffer)

    cdef result buffer_getFree "gc_buffer_getFree" (
        gc_CircBuffer* in_buffer,
        uint32 in_numBytes,
        void** out_dataA,
        uint32* out_sizeA,
        void** out_dataB,
        uint32* out_sizeB
    )

    cdef result buffer_write "gc_buffer_write" (
        gc_CircBuffer* in_buffer,
        void* in_data,
        uint32 in_numBytes
    )

    cdef result buffer_getAvail "gc_buffer_getAvail" (
        gc_CircBuffer* in_buffer,
        uint32 in_numBytes,
        void** out_dataA,
        uint32* out_sizeA,
        void** out_dataB,
        uint32* out_sizeB
    )

    cdef void buffer_read "gc_buffer_read" (
        gc_CircBuffer* in_buffer,
        void* in_data,
        uint32 in_numBytes
    )

    cdef void buffer_produce "gc_buffer_produce" (
        gc_CircBuffer* in_buffer,
        uint32 in_numBytes
    )

    cdef void buffer_consume "gc_buffer_consume" (
        gc_CircBuffer* in_buffer,
        uint32 in_numBytes
    )

    ctypedef struct gc_Link:
        gc_Link* next
        gc_Link* prev
        void* data

    cdef void list_head "gc_list_head" (gc_Link* in_head)
    cdef void list_link "gc_list_link" (gc_Link* in_head, gc_Link* in_link, void* in_data)
    cdef void list_unlink "gc_list_unlink" (gc_Link* in_link)
