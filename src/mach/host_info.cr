lib LibC
    HOST_BASIC_INFO  	 = 1
    HOST_SCHED_INFO	     = 3
    HOST_RESOURCE_SIZES	 = 4
    HOST_PRIORITY_INFO	 = 5

    HOST_LOAD_INFO = 1
    HOST_VM_INFO = 2
    HOST_CPU_LOAD_INFO = 3

    HOST_VM_INFO64 = 4
    HOST_EXTMOD_INFO64 = 5
    HOST_EXPIRED_TASK_INFO = 6
    # record types
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
    HOST_BASIC_INFO_COUNT = sizeof(HostBasicInfo) / sizeof(Int)

    struct HostSchedInfo
        min_timeout : Int
        min_quantum : Int
    end
    HOST_SCHED_INFO_COUNT = sizeof(HostSchedInfo) / sizeof(Int)

    struct KernelResourceSizes
	    task : NaturalT
	    thread : NaturalT
	    port : NaturalT
	    memory_region : NaturalT
	    memory_object : NaturalT
    end
    HOST_RESOURCE_SIZES_COUNT = sizeof(KernelResourceSizes) / sizeof(Int)

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
    HOST_PRIORITY_INFO_COUNT =  sizeof(HostPriorityInfo) / sizeof(Int)

    struct HostLoadInfo
	    avenrun : Int[3]
	    mach_factor : Int[3]
    end
    HOST_LOAD_INFO_COUNT = sizeof(HostLoadInfo) / sizeof(Int)

    struct HostCpuLoadInfo
    	cpu_ticks : ULong[CPU_STATE_MAX]
    end
    HOST_CPU_LOAD_INFO_COUNT = sizeof(HostCpuLoadInfo) / sizeof(Int)

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
    HOST_VM_INFO_COUNT = sizeof(VmStatistics) / sizeof(Int)
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
    HOST_VM_INFO64_COUNT = sizeof(VmStatistics64) / sizeof(Int)


    struct HostInfoArray
        value : UInt8*
    end
    type KernelVersion = Char[512];
    fun host_new =  host_self() : HostT
    fun host_info_new = host_info(host: HostT, flavor: Int,info : ArrayPtr* , count: Int*) : Int
    fun host_statistics_new = host_statistics(host_priv: HostT, flavor: Int,info : ArrayPtr* , count: Int*) : Int
    fun host_statistics64_new = host_statistics64(host_priv: HostT, flavor: Int, info64 : VmStatistics64*, count: Int*) : Int
    fun host_kernel_version_new = host_kernel_version(host: HostT, version : KernelVersion*) : Int
end
