lib LibC
    fun host_new =  host_self() : HostT
    fun host_priv_new = host_priv_self() : HostT
    fun host_info_new = host_info(host: HostT, flavor: Int,info : ArrayPtr* , count: Int*) : Int
    fun host_statistics_new = host_statistics(host_priv: HostT, flavor: Int,info : ArrayPtr* , count: Int*) : Int
    fun host_statistics64_new = host_statistics64(host_priv: HostT, flavor: Int, info64 : VmStatistics64*, count: Int*) : Int
    fun host_kernel_version_new = host_kernel_version(host: HostT, version : KernelVersion*) : Int
end
