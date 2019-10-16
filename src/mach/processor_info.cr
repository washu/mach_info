lib LibC
    fun get_default_processor_set = processor_set_default(host: HostT,default_set_name: ProcessorSetT*) : Int
    fun processor_info_new = host_processor_info(host: HostT, flavor: ProcessorInfoFlavor, p_count: NaturalT*, info: ProcessInfoArrayPtr*, count: Int*) : Int
    fun processor_set_info_new = processor_set_info(set_name : ProcessorSetT, flavor: ProcessorSetInfoFlavor, host : HostT*, processor_set_info : ProcessSetInfoArrayPtr*, count: Int*) : Int
end
