lib LibC
    alias KernReturnType = Int
    KERN_SUCCESS = 0
    KERN_INVALID_ADDRESS = 1
    KERN_PROTECTION_FAILURE = 2
    KERN_NO_SPACE = 3
    KERN_INVALID_ARGUMENT = 4
    KERN_FAILURE = 5
    CPU_STATE_MAX = 3

    # Host info
    alias HostT = UInt
    alias HostPrivT = UInt
    alias HostSecurityT = UInt
    # Processor Info
    alias ProcessorT = UInt
    alias ProcessorSetT = UInt
    alias ProcessorSetControlT = UInt
    # Task Info
    alias TaskT = UInt
    alias TaskNameT = UInt
    alias TaskSuspensionTokenT = UInt
    alias NaturalT = UInt
    alias CpuTypeT = UInt
    alias CpuSubTypeT = UInt
    alias CpuThreadTypeT = UInt
    LOAD_SCALE = 1000
    struct ArrayPtr
        buffer : UInt*
    end
end
class PtrArray(T) < Array(T)
    def initialize(xbuffer : LibC::ArrayPtr, x_size : Int)
        @capacity = x_size.to_i
        @size = x_size.to_i
        @buffer = Pointer(T).malloc(x_size.to_i)
        @buffer.copy_from(xbuffer.buffer.as(Pointer(T)),x_size.to_i)
    end
    def push(value : T)
        raise "Read Only Array"
    end
end
module Mach
    class MachArrayPtrConvertor(T)
        def cast_to(ptr : LibC::ArrayPtr)
            pointerof(ptr).as(Pointer(T)).value
        end
        def cast_to_array(ptr : LibC::ArrayPtr, length : Int = 0)
            PtrArray(T).new(ptr, length)
        end
    end
end
