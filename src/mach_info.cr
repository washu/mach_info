# Module to provide api interface to the user-space mach kernel api
{% skip_file unless flag?(:darwin) || flag?(:freebsd) %}
require "./mach/*"
module MachInfo
  VERSION = "0.1.0"

  # fetch the basic host info from mach
  # returns as LibC::HostBasicInfo struct
  def self.basic_host_info
    port = LibC.host_new
    count = LibC::HOST_BASIC_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HOST_BASIC_INFO,out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::HostBasicInfo).new.cast_to(host_info_array)
  end

  # fetch the host sched info from mach
  # returns as LibC::HostSchedInfo struct
  def self.host_scheduling_info
    port = LibC.host_new
    count = LibC::HOST_SCHED_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HOST_SCHED_INFO,out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::HostSchedInfo).new.cast_to(host_info_array)
  end

  # fetch the kernel version from mach
  # returns versiona s astring
  def self.kernel_version
    port = LibC.host_new
    rc = LibC.host_kernel_version_new(port,out version_string)
    raise "Mach Error:#{rc}" unless rc == 0
    String.new(version_string.to_unsafe)
  end


  # fetch the host load info from mach
  # returns as LibC::HostLoadInfo struct
  def self.host_load_info
    port = LibC.host_new
    count = LibC::HOST_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HOST_LOAD_INFO, out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::HostLoadInfo).new.cast_to(host_info_array)
  end

  # fetch the host vm info from mach
  # returns as LibC::VmStatistics struct
  def self.vm_info
    port = LibC.host_new
    count = LibC::HOST_VM_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HOST_VM_INFO, out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::VmStatistics).new.cast_to(host_info_array)
  end

  # fetch the host cpu load info from mach
  # returns as LibC::HostCpuLoadInfo struct
  def self.host_cpu_load_info
    port = LibC.host_new
    count = LibC::HOST_CPU_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HOST_CPU_LOAD_INFO, out info, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::HostCpuLoadInfo).new.cast_to(info)
  end

  # fetch the host vm statistics64 info from mach
  # returns as LibC::VmStatistics64 struct
  def self.vm_info_64
    port = LibC.host_new
    count = LibC::HOST_VM_INFO64_COUNT
    rc = LibC.host_statistics64_new(port,LibC::HOST_VM_INFO64,out host_info_array,pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::VmStatistics64).new.cast_to(pointerof(host_info_array).as(Pointer(LibC::ArrayPtr)).value)
  end

  # fetch the basic processor info list from mach
  # returns an array of LibC::ProcessorBasicInfo struct
  def self.basic_processor_info
    port = LibC.host_new
    count = 0
    rc = LibC.processor_info_new(port,LibC::PROCESSOR_BASIC_INFO, out pCount, out plist,pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::ProcessorBasicInfo).new.cast_to_array(plist,pCount)
  end

  # fetch the processor load info from mach
  # returns an array of LibC::ProcessorCpuLoadInfo struct
  def self.processor_load_info
    port = LibC.host_new
    count = 0
    rc = LibC.processor_info_new(port,LibC::PROCESSOR_CPU_LOAD_INFO, out pCount, out plist,pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::ProcessorCpuLoadInfo).new.cast_to_array(plist,pCount)
  end

  # fetch the bsaic processor set info from mach
  # returns a LibC::ProcessorSetBasicInfo struct
  def self.basic_processor_set_info
    port = LibC.host_new
    count = LibC::PROCESSOR_SET_BASIC_INFO_COUNT
    LibC.get_default_processor_set(port, out h_port)
    rc = LibC.processor_set_info_new(h_port,LibC::PROCESSOR_SET_BASIC_INFO, out kport,out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::ProcessorSetBasicInfo).new.cast_to(host_info_array)
  end

  # fetch the processor set sched info from mach
  # returns a LibC::ProcessorSetSchedInfo struct
  def self.processor_set_schedu_info
    port = LibC.host_new
    count = LibC::PROCESSOR_SET_SCHED_INFO_COUNT
    LibC.get_default_processor_set(port, out h_port)
    rc = LibC.processor_set_info_new(h_port,LibC::PROCESSOR_SET_SCHED_INFO, out kport,out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    MachInfo::MachArrayPtrConvertor(LibC::ProcessorSetSchedInfo).new.cast_to(host_info_array)
  end

end
