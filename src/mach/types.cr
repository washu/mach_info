lib LibC
    alias KernReturnType = Int
    CPU_STATE_MAX = 3
    LOAD_SCALE = 1000


    KERN_SUCCESS = 0
    KERN_INVALID_ADDRESS = 1
    KERN_PROTECTION_FAILURE = 2
    KERN_NO_SPACE = 3
    KERN_INVALID_ARGUMENT = 4
    KERN_FAILURE = 5

    enum HostInfoFlavor
        HOST_BASIC_INFO  	 = 1
        HOST_SCHED_INFO	     = 3
        HOST_RESOURCE_SIZES	 = 4
        HOST_PRIORITY_INFO	 = 5
    end

    enum HostStatisticsFlavor
        HOST_LOAD_INFO = 1
        HOST_VM_INFO = 2
        HOST_CPU_LOAD_INFO = 3
    end

    enum HostStatistics64Flavor
        HOST_VM_INFO64 = 4
        HOST_EXTMOD_INFO64 = 5
    end

    enum ProcessorInfoFlavor
        PROCESSOR_BASIC_INFO     = 1
        PROCESSOR_CPU_LOAD_INFO  = 2
    end

    enum ProcessorSetInfoFlavor
        PROCESSOR_SET_SCHED_INFO = 3
        PROCESSOR_SET_BASIC_INFO = 5
    end

    type MachPortT = UInt
    # Host info
    alias HostT = MachPortT
    alias HostPrivT = MachPortT
    # Processor Info
    alias ProcessorT = MachPortT
    alias ProcessorSetT = MachPortT

    alias NaturalT = UInt
    alias CpuTypeT = UInt
    alias CpuSubTypeT = UInt
    alias CpuThreadTypeT = UInt
    type KernelVersion = Char[512];

    struct ArrayPtr
        buffer : UInt*
    end

    alias HostInfoArrayPtr = ArrayPtr
    alias ProcessInfoArrayPtr = ArrayPtr
    alias ProcessSetInfoArrayPtr = ArrayPtr

    struct ProcessorBasicInfo
	    cpu_type : CpuTypeT
	    cpu_subtype : CpuSubTypeT
	    running : Bool
	    slot_num : Int
	    is_master : Bool
    end

    struct ProcessorCpuLoadInfo
        cpu_ticks : UInt[CPU_STATE_MAX]
    end

    struct ProcessorSetSchedInfo
	    policies : Int
	    max_priority : Int
    end

    struct ProcessorSetBasicInfo
        processor_count : Int
        task_count : Int
        thread_count : Int
        load_average : Int
        mach_factor : Int
    end

    struct HostBasicInfo
        max_cpus : Int
        avail_cpus : Int
        memory_size: NaturalT
        cpu_type: CpuTypeT
        cpu_subtype: CpuSubTypeT
        cpu_threadtype : CpuThreadTypeT
        physical_cpu : Int
        physical_cpu_max : Int
        logical_cpu : Int
        logical_cpu_max : Int
        max_mem : UInt64
    end

    struct HostSchedInfo
        min_timeout : Int
        min_quantum : Int
    end

    struct KernelResourceSizes
	    task : NaturalT
	    thread : NaturalT
	    port : NaturalT
	    memory_region : NaturalT
	    memory_object : NaturalT
    end

    struct HostPriorityInfo
    	kernel_priority : Int
    	system_priority : Int
    	server_priority : Int
    	user_priority : Int
    	depress_priority : Int
    	idle_priority : Int
    	minimum_priority : Int
	    maximum_priority : Int
    end

    struct HostLoadInfo
	    avenrun : Int[3]
	    mach_factor : Int[3]
    end

    struct HostCpuLoadInfo
    	cpu_ticks : ULong[CPU_STATE_MAX]
    end

    struct VmStatistics
       free_count : Int
       active_count : Int
       inactive_count : Int
       wire_count : Int
       zero_fill_count : Int
       reactivations : Int
       pageins : Int
       pageouts : Int
       faults : Int
       cow_faults : Int
       lookups : Int
       hits : Int
    end

    struct VmStatistics64
	    free_count : Int
	    active_count : Int
	    inactive_count : Int
	    wire_count : Int
	    zero_fill_count : UInt64
	    reactivations : UInt64
	    pageins : UInt64
	    pageouts : UInt64
	    faults : UInt64
	    cow_faults : UInt64
	    lookups : UInt64
	    hits : UInt64
	    purges : UInt64
	    purgeable_count : Int
	    speculative_count : Int
        decompressions : UInt64
	    compressions : UInt64
	    swapins : UInt64
	    swapouts : UInt64
	    compressor_page_count : Int
	    throttled_count : Int
	    external_page_count : Int
	    internal_page_count : Int
	    total_uncompressed_pages_in_compressor : UInt64
    end

    struct VmExtmodStatistics
        task_for_pid_count : Int64
        task_for_pid_caller_count : Int64
        thread_creation_count : Int64
        thread_creation_caller_count : Int64
        thread_set_state_count : Int64
        thread_set_state_caller_count : Int64
    end

    HOST_BASIC_INFO_COUNT = sizeof(HostBasicInfo) / sizeof(Int)
    HOST_SCHED_INFO_COUNT = sizeof(HostSchedInfo) / sizeof(Int)
    HOST_RESOURCE_SIZES_COUNT = sizeof(KernelResourceSizes) / sizeof(Int)
    PROCESSOR_SET_BASIC_INFO_COUNT = sizeof(ProcessorSetBasicInfo) / sizeof(Int)
    PROCESSOR_SET_SCHED_INFO_COUNT = sizeof(ProcessorSetSchedInfo) / sizeof(Int)
    PROCESSOR_CPU_LOAD_INFO_COUNT = sizeof(ProcessorCpuLoadInfo) / sizeof(NaturalT)
    HOST_PRIORITY_INFO_COUNT =  sizeof(HostPriorityInfo) / sizeof(Int)
    HOST_LOAD_INFO_COUNT = sizeof(HostLoadInfo) / sizeof(Int)
    HOST_CPU_LOAD_INFO_COUNT = sizeof(HostCpuLoadInfo) / sizeof(Int)
    HOST_VM_INFO_COUNT = sizeof(VmStatistics) / sizeof(Int)
    PROCESSOR_BASIC_INFO_COUNT = sizeof(ProcessorBasicInfo) / sizeof(NaturalT)
    HOST_VM_INFO64_COUNT = sizeof(VmStatistics64) / sizeof(Int)
    HOST_EXTMOD_INFO64_COUNT = sizeof(VmExtmodStatistics) / sizeof(Int)
    fun task_self =  mach_task_self() : MachPortT
    fun deallocate_task = vm_deallocate(target_task: MachPortT, address: ULong, size: ULong);
end

module MachInfo
    # Pointer Helper Class
    # This class performs some memory management for out array pointers. The convertor ensures
    # we dont leak kernel memory, but copying the array to our own pointer, and calling vm_deallocate
    # back on the orignal pointer, yes this is a copy and used more ram than needed, but it ensures
    # vm alocated memory is properly freed.
    class MachArrayPtrConvertor(T)
        # cast routine will ensure the passed in pointer is de-allocated and a copy made for the return value
        def self.cast_to(ptr : LibC::ArrayPtr)
            m = T.new
            x = pointerof(m)
            yptr = pointerof(ptr).as(Pointer(T))
            x.copy_from(yptr,1)
            LibC.deallocate_task(LibC.task_self(),ptr.buffer.as(Pointer(T)).address, sizeof(T))
            m
        end
        def self.cast_to_array(ptr : LibC::ArrayPtr, length : Int = 0)
            x =Array(T).new(length)
            x.to_unsafe.copy_from(ptr.buffer.as(Pointer(T)),length)
            x
        end
    end
end
