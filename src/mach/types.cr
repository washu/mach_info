lib LibC
    alias KernReturnType = Int
    KERN_SUCCESS = 0
    KERN_INVALID_ADDRESS = 1
    KERN_PROTECTION_FAILURE = 2
    KERN_NO_SPACE = 3
    KERN_INVALID_ARGUMENT = 4
    KERN_FAILURE = 5
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
end
