require "./spec_helper"

describe LibcMach do
  # TODO: Write tests
  it "can lookup basic host information" do
    port = LibC.host_new
    count = LibC::HOST_BASIC_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HOST_BASIC_INFO,out host_info_array, pointerof(count))
    rc.should eq 0
    info = pointerof(host_info_array).as(Pointer(LibC::HostBasicInfo)).value
    info.nil?.should eq(false)
    info.max_cpus.should be > 1
  end
  it "can lookup schedu host information" do
    port = LibC.host_new
    count = LibC::HOST_SCHED_INFO_COUNT
    rc = LibC.host_info_new(port,LibC::HOST_SCHED_INFO,out host_info_array, pointerof(count))
    rc.should eq 0
    info = pointerof(host_info_array).as(Pointer(LibC::HostSchedInfo)).value
    info.nil?.should eq(false)
    info.min_timeout.should be > 0
  end
  it "can lookup kernel resources information" do
    port = LibC.host_new
    count = LibC::HOST_RESOURCE_SIZES_COUNT
    rc = LibC.host_info_new(port,LibC::HOST_RESOURCE_SIZES,out host_info_array, pointerof(count))
    rc.should eq 4
    info = pointerof(host_info_array).as(Pointer(LibC::KernelResourceSizes)).value
    info.nil?.should eq(false)
    info.task.should eq(0)
  end

  it "can lookup kernel version" do
    port = LibC.host_new
    rc = LibC.host_kernel_version_new(port,out version_string)
    rc.should eq 0
    vs = String.new(version_string.to_unsafe).inspect
    vs.includes?("Darwin").should eq(true)
  end

  it "can lookup vm statistics load_info" do
    port = LibC.host_new
    count = LibC::HOST_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HOST_LOAD_INFO, out host_info_array, pointerof(count))
    rc.should eq 0
    info = pointerof(host_info_array).as(Pointer(LibC::HostLoadInfo)).value
    info.nil?.should eq(false)
    info.mach_factor.size.should eq(3)
  end

  it "can lookup vm statistics vm_statistics" do
    port = LibC.host_new
    count = LibC::HOST_VM_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HOST_VM_INFO, out host_info_array, pointerof(count))
    rc.should eq 0
    info = pointerof(host_info_array).as(Pointer(LibC::VmStatistics)).value
    info.nil?.should eq(false)
    info.free_count > 0
  end

  it "can lookup vm statistics cpu_load_info" do
    port = LibC.host_new
    count = LibC::HOST_CPU_LOAD_INFO_COUNT
    rc = LibC.host_statistics_new(port,LibC::HOST_CPU_LOAD_INFO, out host_info_array, pointerof(count))
    rc.should eq 0
    info = pointerof(host_info_array).as(Pointer(LibC::HostCpuLoadInfo)).value
    info.nil?.should eq(false)
    info.cpu_ticks.size.should eq(3)
  end

  it "can lookup vmstatistics64" do
    port = LibC.host_new
    count = LibC::HOST_VM_INFO64_COUNT
    rc = LibC.host_statistics64_new(port,LibC::HOST_VM_INFO64,out info,pointerof(count))
    rc.should eq 0
    info.nil?.should eq(false)
    info.free_count.should be > 0
  end
end