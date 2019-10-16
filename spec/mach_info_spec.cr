require "./spec_helper"

describe MachInfo do
  # TODO: Write tests
  it "can lookup basic host information" do
    port = LibC.host_new
    count = LibC::HOST_BASIC_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HostInfoFlavor::HOST_BASIC_INFO,out host_info_array, pointerof(count))
    rc.should eq LibC::KERN_SUCCESS
    info = pointerof(host_info_array).as(Pointer(LibC::HostBasicInfo)).value
    info.nil?.should eq(false)
    info.max_cpus.should be > 1
  end
  it "can lookup schedu host information" do
    port = LibC.host_new
    count = LibC::HOST_SCHED_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HostInfoFlavor::HOST_SCHED_INFO,out host_info_array, pointerof(count))
    rc.should eq LibC::KERN_SUCCESS
    info = pointerof(host_info_array).as(Pointer(LibC::HostSchedInfo)).value
    info.nil?.should eq(false)
    info.min_timeout.should be > 0
  end
  it "can lookup kernel resources information" do
    port = LibC.host_new
    count = LibC::HOST_RESOURCE_SIZES_COUNT
    rc = LibC.host_info_new(port,LibC::HostInfoFlavor::HOST_RESOURCE_SIZES,out host_info_array, pointerof(count))
    rc.should eq LibC::KERN_INVALID_ARGUMENT
    info = pointerof(host_info_array).as(Pointer(LibC::KernelResourceSizes)).value
    info.nil?.should eq(false)
    info.task.should eq(0)
  end

  it "can lookup kernel version" do
    port = LibC.host_new
    rc = LibC.host_kernel_version_new(port,out version_string)
    rc.should eq LibC::KERN_SUCCESS
    vs = String.new(version_string.to_unsafe).inspect
    vs.includes?("Darwin").should eq(true)
  end

  it "can lookup vm statistics load_info" do
    port = LibC.host_new
    count = LibC::HOST_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HostStatisticsFlavor::HOST_LOAD_INFO, out host_info_array, pointerof(count))
    rc.should eq LibC::KERN_SUCCESS
    info = pointerof(host_info_array).as(Pointer(LibC::HostLoadInfo)).value
    info.nil?.should eq(false)
    info.mach_factor.size.should eq(3)
  end

  it "can lookup vm statistics vm_statistics" do
    port = LibC.host_new
    count = LibC::HOST_VM_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HostStatisticsFlavor::HOST_VM_INFO, out host_info_array, pointerof(count))
    rc.should eq LibC::KERN_SUCCESS
    info = pointerof(host_info_array).as(Pointer(LibC::VmStatistics)).value
    info.nil?.should eq(false)
    info.free_count > 0
  end

  it "can lookup vm statistics cpu_load_info" do
    port = LibC.host_new
    count = LibC::HOST_CPU_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HostStatisticsFlavor::HOST_CPU_LOAD_INFO, out host_info_array, pointerof(count))
    rc.should eq LibC::KERN_SUCCESS
    info = pointerof(host_info_array).as(Pointer(LibC::HostCpuLoadInfo)).value
    info.nil?.should eq(false)
    info.cpu_ticks.sum.should be > 100
  end

  it "can lookup vmstatistics64" do
    port = LibC.host_new
    count = LibC::HOST_VM_INFO64_COUNT
    info = LibC::VmStatistics64.new
    rc = LibC.host_statistics64_new(port,LibC::HostStatistics64Flavor::HOST_VM_INFO64,pointerof(info),pointerof(count))
    rc.should eq LibC::KERN_SUCCESS
    info.free_count.should be > 0
  end

  it "should provide a top level api for basic_host_info" do
    info = MachInfo.basic_host_info
    info.max_cpus.should be > 1
  end

  it "should provide a top level api for host_page_size" do
    info = MachInfo.host_page_size
    info.should be > 100
  end

  it "should provide a top level api for sched info" do
    info = MachInfo.host_scheduling_info
    info.min_timeout.should be > 1
  end
  it "should provide a top level api for basic_host_info" do
    info = MachInfo.basic_host_info
    info.max_cpus.should eq(6)
  end
  it "should provide a top level api for kernel_version" do
    info = MachInfo.kernel_version
    info.includes?("Darwin").should eq(true)
  end
  it "should provide a top level api for host_load_info" do
    info = MachInfo.host_load_info
    info.avenrun[0].should be > 0
  end

  it "should provide a top level api for vm_info" do
    info = MachInfo.vm_info
    info.free_count.should be > 1
  end

  it "should provide a top level api for vm_info_64" do
    info = MachInfo.vm_info_64
    info.free_count.should be > 1
  end

  it "should provide a top level api for cpu_laod_info" do
    info = MachInfo.host_cpu_load_info
    info.cpu_ticks[0].should be > 1
  end

  it "should get a list of processors" do
    port = LibC.host_new
    count = 0
    rc = LibC.processor_info_new(port,LibC::PROCESSOR_BASIC_INFO, out pCount, out plist,pointerof(count))
    rc.should eq 0
    list = MachInfo::MachArrayPtrConvertor(LibC::ProcessorBasicInfo).cast_to_array(plist,pCount)
    (0..list.size-1).each do |i|
        list[i].running.should eq(true)
    end
  end

  it "should get a list of cpu load by processor" do
    port = LibC.host_new
    count = 0
    rc = LibC.processor_info_new(port,LibC::PROCESSOR_CPU_LOAD_INFO, out pCount, out plist,pointerof(count))
    rc.should eq 0
    list = MachInfo::MachArrayPtrConvertor(LibC::ProcessorCpuLoadInfo).cast_to_array(plist,pCount)
    (0..list.size-1).each do |i|
        list[i].cpu_ticks.sum.should be > 100
    end
  end

  it "should get processor set information" do
    port = LibC.host_new
    count = LibC::PROCESSOR_SET_BASIC_INFO_COUNT
    LibC.get_default_processor_set(port, out h_port)
    rc = LibC.processor_set_info_new(h_port,LibC::PROCESSOR_SET_BASIC_INFO, out kport,out host_info_array, pointerof(count))
    info = MachInfo::MachArrayPtrConvertor(LibC::ProcessorSetBasicInfo).cast_to(host_info_array)
    info.nil?.should eq(false)
    rc.should eq 0
    info.processor_count.should be > 1
  end

  it "should get processor set sched information" do
    port = LibC.host_new
    count = LibC::PROCESSOR_SET_SCHED_INFO_COUNT
    LibC.get_default_processor_set(port, out h_port)
    rc = LibC.processor_set_info_new(h_port,LibC::PROCESSOR_SET_SCHED_INFO, out kport,out host_info_array, pointerof(count))
    info = MachInfo::MachArrayPtrConvertor(LibC::ProcessorSetSchedInfo).cast_to(host_info_array)
    rc.should eq 0
    info.policies.should be > 1
  end

end
