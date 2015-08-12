include "h_gc_types.pxi"

cdef extern from 'gorilla/common/gc_common.h':
    ctypedef struct gc_SystemOps:
        void* (*allocFunc)(uint32 in_size)
        void* (*reallocFunc)(void* in_ptr, uint32 in_size)
        void (*freeFunc)(void* in_ptr)
    ctypedef gc_SystemOps SystemOps "gc_SystemOps"  # prefixless

    cdef result initialize "gc_initialize" (SystemOps* in_callbacks)

    cdef result shutdown "gc_shutdown" ()

    ctypedef struct gc_CircBuffer:
        uint8* data
        uint32 dataSize
        # note: no volatile modifiers here
        uint32 nextAvail
        uint32 nextFree
    ctypedef gc_CircBuffer CircBuffer "gc_CircBuffer"

    cdef CircBuffer* buffer_create "gc_buffer_create" (uint32 in_size)
    cdef result buffer_destroy "gc_buffer_destroy" (CircBuffer* in_buffer)
    cdef uint32 buffer_bytesAvail "gc_buffer_bytesAvail" (CircBuffer* in_buffer)
    cdef uint32 buffer_bytesFree "gc_buffer_bytesFree" (CircBuffer* in_buffer)

    cdef result buffer_getFree "gc_buffer_getFree" (
        CircBuffer* in_buffer,
        uint32 in_numBytes,
        void** out_dataA,
        uint32* out_sizeA,
        void** out_dataB,
        uint32* out_sizeB
    )

    cdef result buffer_write "gc_buffer_write" (
        CircBuffer* in_buffer,
        void* in_data,
        uint32 in_numBytes
    )

    cdef result buffer_getAvail "gc_buffer_getAvail" (
        CircBuffer* in_buffer,
        uint32 in_numBytes,
        void** out_dataA,
        uint32* out_sizeA,
        void** out_dataB,
        uint32* out_sizeB
    )

    cdef void buffer_read "gc_buffer_read" (
        CircBuffer* in_buffer,
        void* in_data,
        uint32 in_numBytes
    )

    cdef void buffer_produce "gc_buffer_produce" (
        CircBuffer* in_buffer,
        uint32 in_numBytes
    )

    cdef void buffer_consume "gc_buffer_consume" (
        CircBuffer* in_buffer,
        uint32 in_numBytes
    )

    ctypedef struct gc_Link:
        gc_Link* next
        gc_Link* prev
        void* data
    ctypedef gc_Link Link "gc_Link"  # prefixless

    cdef void list_head "gc_list_head" (Link* in_head)
    cdef void list_link "gc_list_link" (Link* in_head, Link* in_link, void* in_data)
    cdef void list_unlink "gc_list_unlink" (Link* in_link)
