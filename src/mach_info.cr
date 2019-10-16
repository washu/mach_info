# Module to provide api interface to the user-space mach kernel api
{% skip_file unless flag?(:darwin) || flag?(:freebsd) %}
require "./mach/*"
module MachInfo
  VERSION = "0.1.0"
  class KernelErrorException < Exception
  end
  # fetch the basic host info from mach
  # returns as LibC::HostBasicInfo struct
  def self.basic_host_info
    port = LibC.host_new
    count = LibC::HOST_BASIC_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HostInfoFlavor::HOST_BASIC_INFO,out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == LibC::KERN_SUCCESS
    MachInfo::MachArrayPtrConvertor(LibC::HostBasicInfo).cast_to(host_info_array)
  end

  # fetch the host sched info from mach
  # returns as LibC::HostSchedInfo struct
  def self.host_scheduling_info
    port = LibC.host_new
    count = LibC::HOST_SCHED_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HostInfoFlavor::HOST_SCHED_INFO,out host_info_array, pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    MachInfo::MachArrayPtrConvertor(LibC::HostSchedInfo).cast_to(host_info_array)
  end

  # fetch the kernel version from mach
  # returns versiona s astring
  def self.kernel_version
    port = LibC.host_new
    rc = LibC.host_kernel_version_new(port,out version_string)
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    String.new(version_string.to_unsafe)
  end


  def self.host_page_size
    port = LibC.host_new
    rc = LibC.host_page_size_new(port, out page_size)
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    page_size
  end

  # fetch the host load info from mach
  # returns as LibC::HostLoadInfo struct
  def self.host_load_info
    port = LibC.host_new
    count = LibC::HOST_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HostStatisticsFlavor::HOST_LOAD_INFO, out host_info_array, pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    MachInfo::MachArrayPtrConvertor(LibC::HostLoadInfo).cast_to(host_info_array)
  end

  # fetch the host priority info from mach
  # returns as LibC::HostPriorityInfo struct
  def self.host_priority_info
    port = LibC.host_new
    count = LibC::HOST_PRIORITY_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HostInfoFlavor::HOST_PRIORITY_INFO, out host_info_array, pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    MachInfo::MachArrayPtrConvertor(LibC::HostPriorityInfo).cast_to(host_info_array)
  end

  # fetch the host vm info from mach
  # returns as LibC::VmStatistics struct
  def self.vm_info
    port = LibC.host_new
    count = LibC::HOST_VM_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HostStatisticsFlavor::HOST_VM_INFO, out host_info_array, pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    puts count
    MachInfo::MachArrayPtrConvertor(LibC::VmStatistics).cast_to(host_info_array)
  end

  # fetch the host cpu load info from mach
  # returns as LibC::HostCpuLoadInfo struct
  def self.host_cpu_load_info
    port = LibC.host_new
    count = LibC::HOST_CPU_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HostStatisticsFlavor::HOST_CPU_LOAD_INFO, out info, pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    MachInfo::MachArrayPtrConvertor(LibC::HostCpuLoadInfo).cast_to(info)
  end

  # fetch the host vm statistics64 info from mach
  # returns as LibC::VmStatistics64 struct
  def self.vm_info_64
    port = LibC.host_new
    count = LibC::HOST_VM_INFO64_COUNT
    results = LibC::VmStatistics64.new
    rc = LibC.host_statistics64_new(port,LibC::HostStatistics64Flavor::HOST_VM_INFO64,pointerof(results),pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    # we stack allocated the struct, no need to de-allocate
    results
    #MachInfo::MachArrayPtrConvertor(LibC::VmStatistics64).cast_to()
  end

  # fetch the host vm statistics64 info from mach
  # returns as LibC::VmStatistics64 struct
  def self.vm_info_64_extended
    port = LibC.host_new
    count = LibC::HOST_EXTMOD_INFO64_COUNT
    results = LibC::VmStatistics64.new
    converted = LibC::VmExtmodStatistics.new
    rc = LibC.host_statistics64_new(port,LibC::HostStatistics64Flavor::HOST_EXTMOD_INFO64,pointerof(results),pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    # we stack allocated the struct, no need to de-allocate
    pointerof(converted).copy_from(pointerof(results).as(Pointer(LibC::VmExtmodStatistics)),1)
    converted
    #MachInfo::MachArrayPtrConvertor(LibC::VmStatistics64).cast_to()
  end

  # fetch the basic processor info list from mach
  # returns an array of LibC::ProcessorBasicInfo struct
  def self.basic_processor_info
    port = LibC.host_new
    count = 0
    rc = LibC.processor_info_new(port,LibC::ProcessorInfoFlavor::PROCESSOR_BASIC_INFO, out pCount, out plist,pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    MachInfo::MachArrayPtrConvertor(LibC::ProcessorBasicInfo).cast_to_array(plist,pCount)
  end

  # fetch the processor load info from mach
  # returns an array of LibC::ProcessorCpuLoadInfo struct
  def self.processor_load_info
    port = LibC.host_new
    count = 0
    rc = LibC.processor_info_new(port,LibC::ProcessorInfoFlavor::PROCESSOR_CPU_LOAD_INFO, out pCount, out plist,pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    MachInfo::MachArrayPtrConvertor(LibC::ProcessorCpuLoadInfo).cast_to_array(plist,pCount)
  end

  # fetch the bsaic processor set info from mach
  # returns a LibC::ProcessorSetBasicInfo struct
  def self.basic_processor_set_info
    port = LibC.host_new
    count = LibC::PROCESSOR_SET_BASIC_INFO_COUNT
    LibC.get_default_processor_set(port, out h_port)
    rc = LibC.processor_set_info_new(h_port,LibC::ProcessorSetInfoFlavor::PROCESSOR_SET_BASIC_INFO, out kport,out host_info_array, pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    MachInfo::MachArrayPtrConvertor(LibC::ProcessorSetBasicInfo).cast_to(host_info_array)
  end

  # fetch the processor set sched info from mach
  # returns a LibC::ProcessorSetSchedInfo struct
  def self.processor_set_schedu_info
    port = LibC.host_new
    count = LibC::PROCESSOR_SET_SCHED_INFO_COUNT
    LibC.get_default_processor_set(port, out h_port)
    rc = LibC.processor_set_info_new(h_port,LibC::ProcessorSetInfoFlavor::PROCESSOR_SET_SCHED_INFO, out kport,out host_info_array, pointerof(count))
    raise KernelErrorException.new("Mach Error:#{rc}") unless rc == LibC::KERN_SUCCESS
    MachInfo::MachArrayPtrConvertor(LibC::ProcessorSetSchedInfo).cast_to(host_info_array)
  end

end
