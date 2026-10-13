RawGenerateReport :: (instance: Instance, report: *GlobalReport) #foreign libwgpu "wgpuGenerateReport";
RawInstanceEnumerateAdapters :: (instance: Instance, /* NULLABLE */ options: /* const */ *InstanceEnumerateAdapterOptions, adapters: *Adapter) -> u64 #foreign libwgpu "wgpuInstanceEnumerateAdapters";

RawQueueSubmitForIndex :: (queue: Queue, commandCount: u64, commands: /* const */ *CommandBuffer) -> SubmissionIndex #foreign libwgpu "wgpuQueueSubmitForIndex";

QueueGetTimestampPeriod :: (queue: Queue) -> float32 #foreign libwgpu "wgpuQueueGetTimestampPeriod";

// Returns true if the queue is empty, or false if there are more queue submissions still in flight.
DevicePoll :: (device: Device, wait: Bool, /* NULLABLE */ submissionIndex: /* const */ *SubmissionIndex = null) -> Bool #foreign libwgpu "wgpuDevicePoll";
DeviceCreateShaderModuleSpirV :: (device: Device, descriptor: /* const */ *ShaderModuleDescriptorSpirV) -> ShaderModule #foreign libwgpu "wgpuDeviceCreateShaderModuleSpirV";

SetLogCallback :: (callback: LogCallback, userdata: *void) #foreign libwgpu "wgpuSetLogCallback";

SetLogLevel :: (level: LogLevel) #foreign libwgpu "wgpuSetLogLevel";

GetVersion :: () -> u32 #foreign libwgpu "wgpuGetVersion";

DeviceGetNativeMetalDevice :: (device: Device) -> *void #foreign libwgpu "wgpuDeviceGetNativeMetalDevice";
QueueGetNativeMetalCommandQueue :: (queue: Queue) -> *void #foreign libwgpu "wgpuQueueGetNativeMetalCommandQueue";
TextureGetNativeMetalTexture :: (texture: Texture) -> *void #foreign libwgpu "wgpuTextureGetNativeMetalTexture";

RenderPassEncoderMultiDrawIndirect :: (encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count: u32) #foreign libwgpu "wgpuRenderPassEncoderMultiDrawIndirect";
RenderPassEncoderMultiDrawIndexedIndirect :: (encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count: u32) #foreign libwgpu "wgpuRenderPassEncoderMultiDrawIndexedIndirect";

RenderPassEncoderMultiDrawIndirectCount :: (encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count_buffer: Buffer, count_buffer_offset: u64, max_count: u32) #foreign libwgpu "wgpuRenderPassEncoderMultiDrawIndirectCount";
RenderPassEncoderMultiDrawIndexedIndirectCount :: (encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count_buffer: Buffer, count_buffer_offset: u64, max_count: u32) #foreign libwgpu "wgpuRenderPassEncoderMultiDrawIndexedIndirectCount";

ComputePassEncoderBeginPipelineStatisticsQuery :: (computePassEncoder: ComputePassEncoder, querySet: QuerySet, queryIndex: u32) #foreign libwgpu "wgpuComputePassEncoderBeginPipelineStatisticsQuery";
ComputePassEncoderEndPipelineStatisticsQuery :: (computePassEncoder: ComputePassEncoder) #foreign libwgpu "wgpuComputePassEncoderEndPipelineStatisticsQuery";
RenderPassEncoderBeginPipelineStatisticsQuery :: (renderPassEncoder: RenderPassEncoder, querySet: QuerySet, queryIndex: u32) #foreign libwgpu "wgpuRenderPassEncoderBeginPipelineStatisticsQuery";
RenderPassEncoderEndPipelineStatisticsQuery :: (renderPassEncoder: RenderPassEncoder) #foreign libwgpu "wgpuRenderPassEncoderEndPipelineStatisticsQuery";

ComputePassEncoderWriteTimestamp :: (computePassEncoder: ComputePassEncoder, querySet: QuerySet, queryIndex: u32) #foreign libwgpu "wgpuComputePassEncoderWriteTimestamp";
RenderPassEncoderWriteTimestamp :: (renderPassEncoder: RenderPassEncoder, querySet: QuerySet, queryIndex: u32) #foreign libwgpu "wgpuRenderPassEncoderWriteTimestamp";

DeviceStartGraphicsDebuggerCapture :: (device: Device) -> Bool #foreign libwgpu "wgpuDeviceStartGraphicsDebuggerCapture";
DeviceStopGraphicsDebuggerCapture :: (device: Device) #foreign libwgpu "wgpuDeviceStopGraphicsDebuggerCapture";

CommandEncoderClearTexture :: (commandEncoder: CommandEncoder, texture: Texture, range: /* const */ *ImageSubresourceRange = null) #foreign libwgpu "wgpuCommandEncoderClearTexture";

DeviceCreateShaderModuleTrusted :: (device: Device, descriptor: /* const */ *ShaderModuleDescriptor, runtimeChecks: ShaderRuntimeChecks) -> ShaderModule #foreign libwgpu "wgpuDeviceCreateShaderModuleTrusted";

GenerateReport :: (instance: Instance) -> report: GlobalReport {
    report: GlobalReport;
    RawGenerateReport(instance, *report);
    return report;
}

InstanceEnumerateAdapters :: (instance: Instance, options: *InstanceEnumerateAdapterOptions = null, allocator := context.allocator) -> adapters: [] Adapter {
    count := RawInstanceEnumerateAdapters(instance, options, null);
    adapters: [] Adapter;
    {
        push_allocator(allocator);
        adapters = NewArray(cast(s64) count, Adapter, initialized = false);
    }
    RawInstanceEnumerateAdapters(instance, options, adapters.data);
    return adapters;
}

QueueSubmitForIndex :: (queue: Queue, commands: [] CommandBuffer) -> SubmissionIndex {
    return RawQueueSubmitForIndex(queue, cast(u64) commands.count, commands.data);
}
