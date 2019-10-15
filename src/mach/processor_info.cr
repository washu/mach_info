lib LibC
    struct ProcessorInfoArray
        value : UInt8*
    end
    PROCESSOR_INFO_MAX = 1024
    PROCESSOR_SET_INFO_MAX = 1024
    PROCESSOR_BASIC_INFO  = 1
    PROCESSOR_CPU_LOAD_INFO = 2
    struct ProcessorBasicInfo
	    cpu_type : CpuTypeT
	    cpu_subtype : CpuSubTypeT
	    running : Bool
	    slot_num : Int
	    is_master : Bool
    end
    PROCESSOR_BASIC_INFO_COUNT = sizeof(ProcessorBasicInfo) / sizeof(NaturalT)
    struct ProcessorCpuLoadInfo
        cpu_ticks : UInt[CPU_STATE_MAX]
    end
    PROCESSOR_CPU_LOAD_INFO_COUNT = sizeof(ProcessorCpuLoadInfo) / sizeof(NaturalT)

    struct ProcessorSetBasicInfo
	    processor_count : Int
	    default_policy : Int
    end
    PROCESSOR_SET_BASIC_INFO_COUNT = sizeof(ProcessorSetBasicInfo) / sizeof(NaturalT)
    PROCESSOR_SET_LOAD_INFO	= 4
    struct ProcessorSetLoadInfo
        task_count : Int
        thread_count : Int
        load_average : Int
        mach_factor : Int
    end
    PROCESSOR_SET_LOAD_INFO_COUNT = sizeof(ProcessorSetLoadInfo) / sizeof(NaturalT)
    fun task_self =  mach_task_self() : TaskT
    fun processor_info_new = host_processor_info(host: HostT, flavor: Int, p_count: NaturalT*, info: ArrayPtr*, count: Int*) : Int
    fun deallocate_task = vm_deallocate(target_task: TaskT, address: ULong, size: ULong);

end
