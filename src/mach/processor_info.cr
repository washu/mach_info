lib LibC
    fun get_default_processor_set = processor_set_default(host: HostT,default_set_name: ProcessorSetT*) : Int
    fun processor_info_new = host_processor_info(host: HostT, flavor: Int, p_count: NaturalT*, info: ArrayPtr*, count: Int*) : Int
    fun processor_set_info_new = processor_set_info(set_name : ProcessorSetT, flavor: Int, host : HostT*, processor_set_info : ArrayPtr*, count: Int*) : Int
end
