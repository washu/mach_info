# Module to provide api interface to the user-space mach kernel api
{% if flag?(:darwin) %}
require "./mach/*"
{% end %}
module Mach
  VERSION = "0.1.0"

  # fetch the basic host info from mach
  # returns as LibC::HostBasicInfo struct
  def self.basic_host_info
    port = LibC.host_new
    count = LibC::HOST_BASIC_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HOST_BASIC_INFO,out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    pointerof(host_info_array).as(Pointer(LibC::HostBasicInfo)).value
  end

  def self.host_scheduling_info
    port = LibC.host_new
    count = LibC::HOST_SCHED_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HOST_SCHED_INFO,out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    pointerof(host_info_array).as(Pointer(LibC::HostSchedInfo)).value
  end

  def self.kernel_version
    port = LibC.host_new
    rc = LibC.host_kernel_version_new(port,out version_string)
    raise "Mach Error:#{rc}" unless rc == 0
    String.new(version_string.to_unsafe)
  end

  def self.host_load_info
    port = LibC.host_new
    count = LibC::HOST_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HOST_LOAD_INFO, out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    pointerof(host_info_array).as(Pointer(LibC::HostLoadInfo)).value
  end

  def self.vm_info
    port = LibC.host_new
    count = LibC::HOST_VM_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HOST_VM_INFO, out host_info_array, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    pointerof(host_info_array).as(Pointer(LibC::VmStatistics)).value
  end

  def self.host_cpu_load_info
    port = LibC.host_new
    count = LibC::HOST_CPU_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HOST_CPU_LOAD_INFO, out info, pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    pointerof(info).as(Pointer(LibC::HostCpuLoadInfo)).value
  end

  def self.vm_info_64
    port = LibC.host_new
    count = LibC::HOST_VM_INFO64_COUNT
    rc = LibC.host_statistics64_new(port,LibC::HOST_VM_INFO64,out host_info_array,pointerof(count))
    raise "Mach Error:#{rc}" unless rc == 0
    host_info_array
  end

end
