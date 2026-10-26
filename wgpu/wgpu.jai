ARRAY_LAYER_COUNT_UNDEFINED: u32 : 0xFFFF_FFFF;
COPY_STRIDE_UNDEFINED: u32 : 0xFFFF_FFFF;
DEPTH_SLICE_UNDEFINED: u32 : 0xFFFF_FFFF;
LIMIT_U32_UNDEFINED: u32 : 0xFFFF_FFFF;
LIMIT_U64_UNDEFINED: u64 : 0xFFFF_FFFF_FFFF_FFFF;
MIP_LEVEL_COUNT_UNDEFINED: u32 : 0xFFFF_FFFF;
QUERY_SET_INDEX_UNDEFINED: u32 : 0xFFFF_FFFF;
WHOLE_MAP_SIZE: u64 : 0xFFFF_FFFF_FFFF_FFFF;
WHOLE_SIZE: u64 : 0xFFFF_FFFF_FFFF_FFFF;

Flags :: u64;
Bool :: u32;

TRUE: Bool : 1;
FALSE: Bool : 0;

// WGPUStringView. Unlike Jai's string which is {count, data} the pointer comes first.
// data does not need to be null-terminated, unless 'length' is STRLEN.
StringView :: struct {
    data: *u8;
    length: u64;
}

STRLEN: u64 : 0xFFFF_FFFF_FFFF_FFFF;

to_string_view :: (s: string) -> StringView {
    return .{ data = s.data, length = cast(u64) s.count };
}

// Does not copy. A null StringView results in an empty string. A length of STRLEN means 'data' is null-terminated.
to_string :: (v: StringView) -> string {
    if v.data == null return "";

    result: string = ---;
    result.data = v.data;
    if v.length == STRLEN {
        result.count = c_style_strlen(v.data);
    } else {
        result.count = cast(s64) v.length;
    }
    return result;
}

AdapterImpl :: struct {}
BindGroupImpl :: struct {}
BindGroupLayoutImpl :: struct {}
BufferImpl :: struct {}
CommandBufferImpl :: struct {}
CommandEncoderImpl :: struct {}
ComputePassEncoderImpl :: struct {}
ComputePipelineImpl :: struct {}
DeviceImpl :: struct {}
InstanceImpl :: struct {}
PipelineLayoutImpl :: struct {}
QuerySetImpl :: struct {}
QueueImpl :: struct {}
RenderBundleImpl :: struct {}
RenderBundleEncoderImpl :: struct {}
RenderPassEncoderImpl :: struct {}
RenderPipelineImpl :: struct {}
SamplerImpl :: struct {}
ShaderModuleImpl :: struct {}
SurfaceImpl :: struct {}
TextureImpl :: struct {}
TextureViewImpl :: struct {}
ExternalTextureImpl :: struct {}

Adapter :: *AdapterImpl;
BindGroup :: *BindGroupImpl;
BindGroupLayout :: *BindGroupLayoutImpl;
Buffer :: *BufferImpl;
CommandBuffer :: *CommandBufferImpl;
CommandEncoder :: *CommandEncoderImpl;
ComputePassEncoder :: *ComputePassEncoderImpl;
ComputePipeline :: *ComputePipelineImpl;
Device :: *DeviceImpl;
Instance :: *InstanceImpl;
PipelineLayout :: *PipelineLayoutImpl;
QuerySet :: *QuerySetImpl;
Queue :: *QueueImpl;
RenderBundle :: *RenderBundleImpl;
RenderBundleEncoder :: *RenderBundleEncoderImpl;
RenderPassEncoder :: *RenderPassEncoderImpl;
RenderPipeline :: *RenderPipelineImpl;
Sampler :: *SamplerImpl;
ShaderModule :: *ShaderModuleImpl;
Surface :: *SurfaceImpl;
Texture :: *TextureImpl;
TextureView :: *TextureViewImpl;
ExternalTexture :: *ExternalTextureImpl;

AdapterType :: enum s32 {
    DiscreteGPU :: 0x00000001;
    IntegratedGPU :: 0x00000002;
    CPU :: 0x00000003;
    Unknown :: 0x00000004;
}

AddressMode :: enum s32 {
    Undefined :: 0x00000000;
    ClampToEdge :: 0x00000001;
    Repeat :: 0x00000002;
    MirrorRepeat :: 0x00000003;

    // Native.

    ClampToBorder :: 0x00000004;
}

BackendType :: enum s32 {
    Undefined :: 0x00000000;
    Null :: 0x00000001;
    WebGPU :: 0x00000002;
    D3D11 :: 0x00000003;
    D3D12 :: 0x00000004;
    Metal :: 0x00000005;
    Vulkan :: 0x00000006;
    OpenGL :: 0x00000007;
    OpenGLES :: 0x00000008;
}

BlendFactor :: enum s32 {
    Undefined :: 0x00000000;
    Zero :: 0x00000001;
    One :: 0x00000002;
    Src :: 0x00000003;
    OneMinusSrc :: 0x00000004;
    SrcAlpha :: 0x00000005;
    OneMinusSrcAlpha :: 0x00000006;
    Dst :: 0x00000007;
    OneMinusDst :: 0x00000008;
    DstAlpha :: 0x00000009;
    OneMinusDstAlpha :: 0x0000000A;
    SrcAlphaSaturated :: 0x0000000B;
    Constant :: 0x0000000C;
    OneMinusConstant :: 0x0000000D;
    Src1 :: 0x0000000E;
    OneMinusSrc1 :: 0x0000000F;
    Src1Alpha :: 0x00000010;
    OneMinusSrc1Alpha :: 0x00000011;
}

BlendOperation :: enum s32 {
    Undefined :: 0x00000000;
    Add :: 0x00000001;
    Subtract :: 0x00000002;
    ReverseSubtract :: 0x00000003;
    Min :: 0x00000004;
    Max :: 0x00000005;
}

BufferBindingType :: enum s32 {
    BindingNotUsed :: 0x00000000;
    Undefined :: 0x00000001;
    Uniform :: 0x00000002;
    Storage :: 0x00000003;
    ReadOnlyStorage :: 0x00000004;
}

BufferMapState :: enum s32 {
    Unmapped :: 0x00000001;
    Pending :: 0x00000002;
    Mapped :: 0x00000003;
}

CallbackMode :: enum s32 {
    WaitAnyOnly :: 0x00000001;
    AllowProcessEvents :: 0x00000002;
    AllowSpontaneous :: 0x00000003;
}

CompareFunction :: enum s32 {
    Undefined :: 0x00000000;
    Never :: 0x00000001;
    Less :: 0x00000002;
    Equal :: 0x00000003;
    LessEqual :: 0x00000004;
    Greater :: 0x00000005;
    NotEqual :: 0x00000006;
    GreaterEqual :: 0x00000007;
    Always :: 0x00000008;
}

CompilationInfoRequestStatus :: enum s32 {
    Success :: 0x00000001;
    CallbackCancelled :: 0x00000002;
}

CompilationMessageType :: enum s32 {
    Error :: 0x00000001;
    Warning :: 0x00000002;
    Info :: 0x00000003;
}

ComponentSwizzle :: enum s32 {
    Undefined :: 0x00000000;
    Zero :: 0x00000001;
    One :: 0x00000002;
    R :: 0x00000003;
    G :: 0x00000004;
    B :: 0x00000005;
    A :: 0x00000006;
}

CompositeAlphaMode :: enum s32 {
    Auto :: 0x00000000;
    Opaque :: 0x00000001;
    Premultiplied :: 0x00000002;
    Unpremultiplied :: 0x00000003;
    Inherit :: 0x00000004;
}

CreatePipelineAsyncStatus :: enum s32 {
    Success :: 0x00000001;
    CallbackCancelled :: 0x00000002;
    ValidationError :: 0x00000003;
    InternalError :: 0x00000004;
}

CullMode :: enum s32 {
    Undefined :: 0x00000000;
    None :: 0x00000001;
    Front :: 0x00000002;
    Back :: 0x00000003;
}

DeviceLostReason :: enum s32 {
    Undefined :: 0x00000000;
    Unknown :: 0x00000001;
    Destroyed :: 0x00000002;
    CallbackCancelled :: 0x00000003;
    FailedCreation :: 0x00000004;
}

ErrorFilter :: enum s32 {
    Validation :: 0x00000001;
    OutOfMemory :: 0x00000002;
    Internal :: 0x00000003;
}

ErrorType :: enum s32 {
    NoError :: 0x00000001;
    Validation :: 0x00000002;
    OutOfMemory :: 0x00000003;
    Internal :: 0x00000004;
    Unknown :: 0x00000005;
}

FeatureLevel :: enum s32 {
    Undefined :: 0x00000000;
    Compatibility :: 0x00000001;
    Core :: 0x00000002;
}

FeatureName :: enum s32 {
    // WebGPU.
    Undefined :: 0x00000000;
    CoreFeaturesAndLimits :: 0x00000001;
    DepthClipControl :: 0x00000002;
    Depth32FloatStencil8 :: 0x00000003;
    TextureCompressionBC :: 0x00000004;
    TextureCompressionBCSliced3D :: 0x00000005;
    TextureCompressionETC2 :: 0x00000006;
    TextureCompressionASTC :: 0x00000007;
    TextureCompressionASTCSliced3D :: 0x00000008;
    TimestampQuery :: 0x00000009;
    IndirectFirstInstance :: 0x0000000A;
    ShaderF16 :: 0x0000000B;
    RG11B10UfloatRenderable :: 0x0000000C;
    BGRA8UnormStorage :: 0x0000000D;
    Float32Filterable :: 0x0000000E;
    Float32Blendable :: 0x0000000F;
    ClipDistances :: 0x00000010;
    DualSourceBlending :: 0x00000011;
    Subgroups :: 0x00000012;
    TextureFormatsTier1 :: 0x00000013;
    TextureFormatsTier2 :: 0x00000014;
    PrimitiveIndex :: 0x00000015;
    TextureComponentSwizzle :: 0x00000016;

    // Native.
    Immediates :: 0x00030001;
    TextureAdapterSpecificFormatFeatures :: 0x00030002;
    MultiDrawIndirectCount :: 0x00030004;
    VertexWritableStorage :: 0x00030005;
    TextureBindingArray :: 0x00030006;
    SampledTextureAndStorageBufferArrayNonUniformIndexing :: 0x00030007;
    PipelineStatisticsQuery :: 0x00030008;
    StorageResourceBindingArray :: 0x00030009;
    PartiallyBoundBindingArray :: 0x0003000A;
    TextureFormat16bitNorm :: 0x0003000B;
    TextureCompressionAstcHdr :: 0x0003000C;
    MappablePrimaryBuffers :: 0x0003000E;
    BufferBindingArray :: 0x0003000F;
    StorageTextureArrayNonUniformIndexing :: 0x00030010;
    AddressModeClampToZero :: 0x00030011;
    AddressModeClampToBorder :: 0x00030012;
    PolygonModeLine :: 0x00030013;
    PolygonModePoint :: 0x00030014;
    ConservativeRasterization :: 0x00030015;
    ClearTexture :: 0x00030016;
    Multiview :: 0x00030018;
    VertexAttribute64bit :: 0x00030019;
    TextureFormatNv12 :: 0x0003001A;
    RayQuery :: 0x0003001C;
    ShaderF64 :: 0x0003001D;
    ShaderI16 :: 0x0003001E;
    ShaderEarlyDepthTest :: 0x00030020;
    Subgroup :: 0x00030021;
    SubgroupVertex :: 0x00030022;
    SubgroupBarrier :: 0x00030023;
    TimestampQueryInsideEncoders :: 0x00030024;
    TimestampQueryInsidePasses :: 0x00030025;
    ShaderInt64 :: 0x00030026;
    ShaderFloat32Atomic :: 0x00030027;
    TextureAtomic :: 0x00030028;
    TextureFormatP010 :: 0x00030029;
    // TODO: requires wgpu.h api change
    // ExternalTexture,
    PipelineCache :: 0x0003002B;
    ShaderInt64AtomicMinMax :: 0x0003002C;
    ShaderInt64AtomicAllOps :: 0x0003002D;
    // TODO: requires wgpu.h api change
    // VulkanGoogleDisplayTiming,
    // VulkanExternalMemoryWin32,
    TextureInt64Atomic :: 0x00030030;
    // TODO: not implemented yet, see https://github.com/gfx-rs/wgpu/issues/7149
    UniformBufferBindingArrays :: 0x00030031;
    // TODO: requires wgpu.h api change
    // MeshShader,
    // RayHitVertexReturn,
    // MeshShaderMultiview,
    // ExtendedAccelerationStructureVertexFormat,
    // PassThroughShaders,
    ShaderBarycentrics :: 0x00030037;
    SelectiveMultiview :: 0x00030038;
    // TODO: requires wgpu.h api change
    // MeshShaderPoints,
    MultisampleArray :: 0x0003003A;
    CooperativeMatrix :: 0x0003003B;
    ShaderPerVertex :: 0x0003003C;
    ShaderDrawIndex :: 0x0003003D;
    AccelerationStructureBindingArray :: 0x0003003E;
    MemoryDecorationCoherent :: 0x0003003F;
    MemoryDecorationVolatile :: 0x00030040;
}

FilterMode :: enum s32 {
    Undefined :: 0x00000000;
    Nearest :: 0x00000001;
    Linear :: 0x00000002;
}

FrontFace :: enum s32 {
    Undefined :: 0x00000000;
    CCW :: 0x00000001;
    CW :: 0x00000002;
}

IndexFormat :: enum s32 {
    Undefined :: 0x00000000;
    Uint16 :: 0x00000001;
    Uint32 :: 0x00000002;
}

InstanceFeatureName :: enum s32 {
    TimedWaitAny :: 0x00000001;
    ShaderSourceSPIRV :: 0x00000002;
    MultipleDevicesPerAdapter :: 0x00000003;
}

LoadOp :: enum s32 {
    Undefined :: 0x00000000;
    Load :: 0x00000001;
    Clear :: 0x00000002;
}

MapAsyncStatus :: enum s32 {
    Success :: 0x00000001;
    CallbackCancelled :: 0x00000002;
    Error :: 0x00000003;
    Aborted :: 0x00000004;
}

MipmapFilterMode :: enum s32 {
    Undefined :: 0x00000000;
    Nearest :: 0x00000001;
    Linear :: 0x00000002;
}

OptionalBool :: enum s32 {
    False :: 0x00000000;
    True :: 0x00000001;
    Undefined :: 0x00000002;
}

PopErrorScopeStatus :: enum s32 {
    Success :: 0x00000001;
    CallbackCancelled :: 0x00000002;
    Error :: 0x00000003;
}

PowerPreference :: enum s32 {
    Undefined :: 0x00000000;
    LowPower :: 0x00000001;
    HighPerformance :: 0x00000002;
}

PredefinedColorSpace :: enum s32 {
    SRGB :: 0x00000001;
    DisplayP3 :: 0x00000002;
}

PresentMode :: enum s32 {
    Undefined :: 0x00000000;
    Fifo :: 0x00000001;
    FifoRelaxed :: 0x00000002;
    Immediate :: 0x00000003;
    Mailbox :: 0x00000004;
}

PrimitiveTopology :: enum s32 {
    Undefined :: 0x00000000;
    PointList :: 0x00000001;
    LineList :: 0x00000002;
    LineStrip :: 0x00000003;
    TriangleList :: 0x00000004;
    TriangleStrip :: 0x00000005;
}

QueryType :: enum s32 {
    // WebGPU.
    Occlusion :: 0x00000001;
    Timestamp :: 0x00000002;

    // Native.
    PipelineStatistics :: 0x00030000;
}

QueueWorkDoneStatus :: enum s32 {
    Success :: 0x00000001;
    CallbackCancelled :: 0x00000002;
    Error :: 0x00000003;
}

RequestAdapterStatus :: enum s32 {
    Success :: 0x00000001;
    CallbackCancelled :: 0x00000002;
    Unavailable :: 0x00000003;
    Error :: 0x00000004;
}

RequestDeviceStatus :: enum s32 {
    Success :: 0x00000001;
    CallbackCancelled :: 0x00000002;
    Error :: 0x00000003;
}

SamplerBindingType :: enum s32 {
    BindingNotUsed :: 0x00000000;
    Undefined :: 0x00000001;
    Filtering :: 0x00000002;
    NonFiltering :: 0x00000003;
    Comparison :: 0x00000004;
}

Status :: enum s32 {
    Success :: 0x00000001;
    Error :: 0x00000002;
}

StencilOperation :: enum s32 {
    Undefined :: 0x00000000;
    Keep :: 0x00000001;
    Zero :: 0x00000002;
    Replace :: 0x00000003;
    Invert :: 0x00000004;
    IncrementClamp :: 0x00000005;
    DecrementClamp :: 0x00000006;
    IncrementWrap :: 0x00000007;
    DecrementWrap :: 0x00000008;
}

StorageTextureAccess :: enum s32 {
    BindingNotUsed :: 0x00000000;
    Undefined :: 0x00000001;
    WriteOnly :: 0x00000002;
    ReadOnly :: 0x00000003;
    ReadWrite :: 0x00000004;
}

StoreOp :: enum s32 {
    Undefined :: 0x00000000;
    Store :: 0x00000001;
    Discard :: 0x00000002;
}

SType :: enum s32 {
    // WebGPU.
    ShaderSourceSPIRV :: 0x00000001;
    ShaderSourceWGSL :: 0x00000002;
    RenderPassMaxDrawCount :: 0x00000003;
    SurfaceSourceMetalLayer :: 0x00000004;
    SurfaceSourceWindowsHWND :: 0x00000005;
    SurfaceSourceXlibWindow :: 0x00000006;
    SurfaceSourceWaylandSurface :: 0x00000007;
    SurfaceSourceAndroidNativeWindow :: 0x00000008;
    SurfaceSourceXCBWindow :: 0x00000009;
    SurfaceColorManagement :: 0x0000000A;
    RequestAdapterWebXROptions :: 0x0000000B;
    TextureComponentSwizzleDescriptor :: 0x0000000C;
    ExternalTextureBindingLayout :: 0x0000000D;
    ExternalTextureBindingEntry :: 0x0000000E;
    CompatibilityModeLimits :: 0x0000000F;
    TextureBindingViewDimension :: 0x00000010;

    // Native.
    DeviceExtras :: 0x00030001;
    NativeLimits :: 0x00030002;
    ShaderSourceGLSL :: 0x00030003;
    InstanceExtras :: 0x00030004;
    BindGroupEntryExtras :: 0x00030005;
    BindGroupLayoutEntryExtras :: 0x00030006;
    QuerySetDescriptorExtras :: 0x00030007;
    SurfaceConfigurationExtras :: 0x00030008;
    SurfaceSourceSwapChainPanel :: 0x00030009;
    PrimitiveStateExtras :: 0x0003000A;
    SamplerDescriptorExtras :: 0x0003000B;
}

SurfaceGetCurrentTextureStatus :: enum s32 {
    SuccessOptimal :: 0x00000001;
    SuccessSuboptimal :: 0x00000002;
    Timeout :: 0x00000003;
    Outdated :: 0x00000004;
    Lost :: 0x00000005;
    Error :: 0x00000006;

    // Native.
    Occluded :: 0x00030001;
}

TextureAspect :: enum s32 {
    Undefined :: 0x00000000;
    All :: 0x00000001;
    StencilOnly :: 0x00000002;
    DepthOnly :: 0x00000003;
}

TextureDimension :: enum s32 {
    Undefined :: 0x00000000;
    _1D :: 0x00000001;
    _2D :: 0x00000002;
    _3D :: 0x00000003;
}

TextureFormat :: enum s32 {
    Undefined :: 0x00000000;
    R8Unorm :: 0x00000001;
    R8Snorm :: 0x00000002;
    R8Uint :: 0x00000003;
    R8Sint :: 0x00000004;
    R16Unorm :: 0x00000005;
    R16Snorm :: 0x00000006;
    R16Uint :: 0x00000007;
    R16Sint :: 0x00000008;
    R16Float :: 0x00000009;
    RG8Unorm :: 0x0000000A;
    RG8Snorm :: 0x0000000B;
    RG8Uint :: 0x0000000C;
    RG8Sint :: 0x0000000D;
    R32Float :: 0x0000000E;
    R32Uint :: 0x0000000F;
    R32Sint :: 0x00000010;
    RG16Unorm :: 0x00000011;
    RG16Snorm :: 0x00000012;
    RG16Uint :: 0x00000013;
    RG16Sint :: 0x00000014;
    RG16Float :: 0x00000015;
    RGBA8Unorm :: 0x00000016;
    RGBA8UnormSrgb :: 0x00000017;
    RGBA8Snorm :: 0x00000018;
    RGBA8Uint :: 0x00000019;
    RGBA8Sint :: 0x0000001A;
    BGRA8Unorm :: 0x0000001B;
    BGRA8UnormSrgb :: 0x0000001C;
    RGB10A2Uint :: 0x0000001D;
    RGB10A2Unorm :: 0x0000001E;
    RG11B10Ufloat :: 0x0000001F;
    RGB9E5Ufloat :: 0x00000020;
    RG32Float :: 0x00000021;
    RG32Uint :: 0x00000022;
    RG32Sint :: 0x00000023;
    RGBA16Unorm :: 0x00000024;
    RGBA16Snorm :: 0x00000025;
    RGBA16Uint :: 0x00000026;
    RGBA16Sint :: 0x00000027;
    RGBA16Float :: 0x00000028;
    RGBA32Float :: 0x00000029;
    RGBA32Uint :: 0x0000002A;
    RGBA32Sint :: 0x0000002B;
    Stencil8 :: 0x0000002C;
    Depth16Unorm :: 0x0000002D;
    Depth24Plus :: 0x0000002E;
    Depth24PlusStencil8 :: 0x0000002F;
    Depth32Float :: 0x00000030;
    Depth32FloatStencil8 :: 0x00000031;
    BC1RGBAUnorm :: 0x00000032;
    BC1RGBAUnormSrgb :: 0x00000033;
    BC2RGBAUnorm :: 0x00000034;
    BC2RGBAUnormSrgb :: 0x00000035;
    BC3RGBAUnorm :: 0x00000036;
    BC3RGBAUnormSrgb :: 0x00000037;
    BC4RUnorm :: 0x00000038;
    BC4RSnorm :: 0x00000039;
    BC5RGUnorm :: 0x0000003A;
    BC5RGSnorm :: 0x0000003B;
    BC6HRGBUfloat :: 0x0000003C;
    BC6HRGBFloat :: 0x0000003D;
    BC7RGBAUnorm :: 0x0000003E;
    BC7RGBAUnormSrgb :: 0x0000003F;
    ETC2RGB8Unorm :: 0x00000040;
    ETC2RGB8UnormSrgb :: 0x00000041;
    ETC2RGB8A1Unorm :: 0x00000042;
    ETC2RGB8A1UnormSrgb :: 0x00000043;
    ETC2RGBA8Unorm :: 0x00000044;
    ETC2RGBA8UnormSrgb :: 0x00000045;
    EACR11Unorm :: 0x00000046;
    EACR11Snorm :: 0x00000047;
    EACRG11Unorm :: 0x00000048;
    EACRG11Snorm :: 0x00000049;
    ASTC4x4Unorm :: 0x0000004A;
    ASTC4x4UnormSrgb :: 0x0000004B;
    ASTC5x4Unorm :: 0x0000004C;
    ASTC5x4UnormSrgb :: 0x0000004D;
    ASTC5x5Unorm :: 0x0000004E;
    ASTC5x5UnormSrgb :: 0x0000004F;
    ASTC6x5Unorm :: 0x00000050;
    ASTC6x5UnormSrgb :: 0x00000051;
    ASTC6x6Unorm :: 0x00000052;
    ASTC6x6UnormSrgb :: 0x00000053;
    ASTC8x5Unorm :: 0x00000054;
    ASTC8x5UnormSrgb :: 0x00000055;
    ASTC8x6Unorm :: 0x00000056;
    ASTC8x6UnormSrgb :: 0x00000057;
    ASTC8x8Unorm :: 0x00000058;
    ASTC8x8UnormSrgb :: 0x00000059;
    ASTC10x5Unorm :: 0x0000005A;
    ASTC10x5UnormSrgb :: 0x0000005B;
    ASTC10x6Unorm :: 0x0000005C;
    ASTC10x6UnormSrgb :: 0x0000005D;
    ASTC10x8Unorm :: 0x0000005E;
    ASTC10x8UnormSrgb :: 0x0000005F;
    ASTC10x10Unorm :: 0x00000060;
    ASTC10x10UnormSrgb :: 0x00000061;
    ASTC12x10Unorm :: 0x00000062;
    ASTC12x10UnormSrgb :: 0x00000063;
    ASTC12x12Unorm :: 0x00000064;
    ASTC12x12UnormSrgb :: 0x00000065;

    // Native.

    NV12 :: 0x00030007;
    P010 :: 0x00030008;
}

TextureSampleType :: enum s32 {
    BindingNotUsed :: 0x00000000;
    Undefined :: 0x00000001;
    Float :: 0x00000002;
    UnfilterableFloat :: 0x00000003;
    Depth :: 0x00000004;
    Sint :: 0x00000005;
    Uint :: 0x00000006;
}

TextureViewDimension :: enum s32 {
    Undefined :: 0x00000000;
    _1D :: 0x00000001;
    _2D :: 0x00000002;
    _2DArray :: 0x00000003;
    Cube :: 0x00000004;
    CubeArray :: 0x00000005;
    _3D :: 0x00000006;
}

ToneMappingMode :: enum s32 {
    Standard :: 0x00000001;
    Extended :: 0x00000002;
}

VertexFormat :: enum s32 {
    Uint8 :: 0x00000001;
    Uint8x2 :: 0x00000002;
    Uint8x4 :: 0x00000003;
    Sint8 :: 0x00000004;
    Sint8x2 :: 0x00000005;
    Sint8x4 :: 0x00000006;
    Unorm8 :: 0x00000007;
    Unorm8x2 :: 0x00000008;
    Unorm8x4 :: 0x00000009;
    Snorm8 :: 0x0000000A;
    Snorm8x2 :: 0x0000000B;
    Snorm8x4 :: 0x0000000C;
    Uint16 :: 0x0000000D;
    Uint16x2 :: 0x0000000E;
    Uint16x4 :: 0x0000000F;
    Sint16 :: 0x00000010;
    Sint16x2 :: 0x00000011;
    Sint16x4 :: 0x00000012;
    Unorm16 :: 0x00000013;
    Unorm16x2 :: 0x00000014;
    Unorm16x4 :: 0x00000015;
    Snorm16 :: 0x00000016;
    Snorm16x2 :: 0x00000017;
    Snorm16x4 :: 0x00000018;
    Float16 :: 0x00000019;
    Float16x2 :: 0x0000001A;
    Float16x4 :: 0x0000001B;
    Float32 :: 0x0000001C;
    Float32x2 :: 0x0000001D;
    Float32x3 :: 0x0000001E;
    Float32x4 :: 0x0000001F;
    Uint32 :: 0x00000020;
    Uint32x2 :: 0x00000021;
    Uint32x3 :: 0x00000022;
    Uint32x4 :: 0x00000023;
    Sint32 :: 0x00000024;
    Sint32x2 :: 0x00000025;
    Sint32x3 :: 0x00000026;
    Sint32x4 :: 0x00000027;
    Unorm10_10_10_2 :: 0x00000028;
    Unorm8x4BGRA :: 0x00000029;
}

VertexStepMode :: enum s32 {
    Undefined :: 0x00000000;
    Vertex :: 0x00000001;
    Instance :: 0x00000002;
}

WaitStatus :: enum s32 {
    Success :: 0x00000001;
    TimedOut :: 0x00000002;
    Error :: 0x00000003;
}

WGSLLanguageFeatureName :: enum s32 {
    ReadonlyAndReadwriteStorageTextures :: 0x00000001;
    Packed4x8IntegerDotProduct :: 0x00000002;
    UnrestrictedPointerParameters :: 0x00000003;
    PointerCompositeAccess :: 0x00000004;
    UniformBufferStandardLayout :: 0x00000005;
    SubgroupId :: 0x00000006;
    TextureAndSamplerLet :: 0x00000007;
    SubgroupUniformity :: 0x00000008;
    TextureFormatsTier1 :: 0x00000009;
    LinearIndexing :: 0x0000000A;
}

// Flags. These are 'bit_set's in Odin and 'WGPUFlags' (u64) constants in C.

BufferUsage :: enum_flags u64 {
    None :: 0x0000000000000000;
    MapRead :: 0x0000000000000001;
    MapWrite :: 0x0000000000000002;
    CopySrc :: 0x0000000000000004;
    CopyDst :: 0x0000000000000008;
    Index :: 0x0000000000000010;
    Vertex :: 0x0000000000000020;
    Uniform :: 0x0000000000000040;
    Storage :: 0x0000000000000080;
    Indirect :: 0x0000000000000100;
    QueryResolve :: 0x0000000000000200;
}

BufferUsageFlags :: BufferUsage;

ColorWriteMask :: enum_flags u64 {
    None :: 0x0000000000000000;
    Red :: 0x0000000000000001;
    Green :: 0x0000000000000002;
    Blue :: 0x0000000000000004;
    Alpha :: 0x0000000000000008;
    All :: 0x000000000000000F;
}

ColorWriteMaskFlags :: ColorWriteMask;
ColorWriteMaskFlags_All :: ColorWriteMaskFlags.All;

MapMode :: enum_flags u64 {
    None :: 0x0000000000000000;
    Read :: 0x0000000000000001;
    Write :: 0x0000000000000002;
}

MapModeFlags :: MapMode;

ShaderStage :: enum_flags u64 {
    None :: 0x0000000000000000;
    Vertex :: 0x0000000000000001;
    Fragment :: 0x0000000000000002;
    Compute :: 0x0000000000000004;
}

ShaderStageFlags :: ShaderStage;

TextureUsage :: enum_flags u64 {
    None :: 0x0000000000000000;
    CopySrc :: 0x0000000000000001;
    CopyDst :: 0x0000000000000002;
    TextureBinding :: 0x0000000000000004;
    StorageBinding :: 0x0000000000000008;
    RenderAttachment :: 0x0000000000000010;
    TransientAttachment :: 0x0000000000000020;
}

TextureUsageFlags :: TextureUsage;

Proc :: #type () -> void #c_call;

BufferMapCallback :: #type (status: MapAsyncStatus, message: StringView, userdata1: *void, userdata2: *void) #c_call;
CompilationInfoCallback :: #type (status: CompilationInfoRequestStatus, compilationInfo: *CompilationInfo, userdata1: *void, userdata2: *void) #c_call;
CreateComputePipelineAsyncCallback :: #type (status: CreatePipelineAsyncStatus, pipeline: ComputePipeline, message: StringView, userdata1: *void, userdata2: *void) #c_call;
CreateRenderPipelineAsyncCallback :: #type (status: CreatePipelineAsyncStatus, pipeline: RenderPipeline, message: StringView, userdata1: *void, userdata2: *void) #c_call;
DeviceLostCallback :: #type (device: *Device, reason: DeviceLostReason, message: StringView, userdata1: *void, userdata2: *void) #c_call;
PopErrorScopeCallback :: #type (status: PopErrorScopeStatus, type: ErrorType, message: StringView, userdata1: *void, userdata2: *void) #c_call;
QueueWorkDoneCallback :: #type (status: QueueWorkDoneStatus, message: StringView, userdata1: *void, userdata2: *void) #c_call;
RequestAdapterCallback :: #type (status: RequestAdapterStatus, adapter: Adapter, message: StringView, userdata1: *void, userdata2: *void) #c_call;
RequestDeviceCallback :: #type (status: RequestDeviceStatus, device: Device, message: StringView, userdata1: *void, userdata2: *void) #c_call;
UncapturedErrorCallback :: #type (device: *Device, type: ErrorType, message: StringView, userdata1: *void, userdata2: *void) #c_call;

ChainedStruct :: struct {
    next: *ChainedStruct;
    sType: SType;
}

BufferMapCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    mode: CallbackMode;
    callback: BufferMapCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

CompilationInfoCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    mode: CallbackMode;
    callback: CompilationInfoCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

CreateComputePipelineAsyncCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    mode: CallbackMode;
    callback: CreateComputePipelineAsyncCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

CreateRenderPipelineAsyncCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    mode: CallbackMode;
    callback: CreateRenderPipelineAsyncCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

DeviceLostCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    mode: CallbackMode;
    callback: DeviceLostCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

PopErrorScopeCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    mode: CallbackMode;
    callback: PopErrorScopeCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

QueueWorkDoneCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    mode: CallbackMode;
    callback: QueueWorkDoneCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

RequestAdapterCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    mode: CallbackMode;
    callback: RequestAdapterCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

RequestDeviceCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    mode: CallbackMode;
    callback: RequestDeviceCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

UncapturedErrorCallbackInfo :: struct {
    nextInChain: /* const */ *ChainedStruct;
    callback: UncapturedErrorCallback;
    userdata1: /* NULLABLE */ *void;
    userdata2: /* NULLABLE */ *void;
}

AdapterInfo :: struct {
    nextInChain: *ChainedStruct;
    vendor: StringView;
    architecture: StringView;
    device: StringView;
    description: StringView;
    backendType: BackendType;
    adapterType: AdapterType;
    vendorID: u32;
    deviceID: u32;
    subgroupMinSize: u32;
    subgroupMaxSize: u32;
}

BlendComponent :: struct {
    operation: BlendOperation;
    srcFactor: BlendFactor;
    dstFactor: BlendFactor;
}

BufferBindingLayout :: struct {
    nextInChain: *ChainedStruct;
    type: BufferBindingType;
    hasDynamicOffset: Bool;
    minBindingSize: u64;
}

BufferDescriptor :: struct {
    nextInChain: /* const */ *ChainedStruct;
    label: StringView;
    usage: BufferUsageFlags;
    size: u64;
    mappedAtCreation: Bool;
}

Color :: struct {
    r, g, b, a: float64;
}

CommandBufferDescriptor :: struct {
    nextInChain: /* const */ *ChainedStruct;
    label: StringView;
}

CommandEncoderDescriptor :: struct {
    nextInChain: /* const */ *ChainedStruct;
    label: StringView;
}

CompatibilityModeLimits :: struct {
    using chain: ChainedStruct;
    maxStorageBuffersInVertexStage: u32;
    maxStorageTexturesInVertexStage: u32;
    maxStorageBuffersInFragmentStage: u32;
    maxStorageTexturesInFragmentStage: u32;
}

CompilationMessage :: struct {
    nextInChain: *ChainedStruct;
    message: StringView;
    type: CompilationMessageType;
    lineNum: u64;
    linePos: u64;
    offset: u64;
    length: u64;
}

ConstantEntry :: struct {
    nextInChain: /* const */ *ChainedStruct;
    key: StringView;
    value: float64;
}

Extent3D :: struct {
    width: u32;
    height: u32;
    depthOrArrayLayers: u32;
}

/*
Chained in a `BindGroupEntry`.
*/
ExternalTextureBindingEntry :: struct {
    using chain: ChainedStruct;
    externalTexture: ExternalTexture;
}

/*
Chained in a `BindGroupLayoutEntry`.
*/
ExternalTextureBindingLayout :: struct {
    using chain: ChainedStruct;
}

Future :: struct {
    id: u64;
}

InstanceLimits :: struct {
    nextInChain: *ChainedStruct;
    timedWaitAnyMaxCount: u64;
}

MultisampleState :: struct {
    nextInChain: *ChainedStruct;
    count: u32;
    mask: u32;
    alphaToCoverageEnabled: Bool;
}

Origin3D :: struct {
    x: u32;
    y: u32;
    z: u32;
}

PassTimestampWrites :: struct {
    nextInChain: *ChainedStruct;
    querySet: QuerySet;
    beginningOfPassWriteIndex: u32;
    endOfPassWriteIndex: u32;
}

PipelineLayoutDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    bindGroupLayoutCount: u64;
    bindGroupLayouts: *BindGroupLayout;
    immediateSize: u32;
}

PrimitiveState :: struct {
    nextInChain: *ChainedStruct;
    topology: PrimitiveTopology;
    stripIndexFormat: IndexFormat;
    frontFace: FrontFace;
    cullMode: CullMode;
    unclippedDepth: Bool;
}

QuerySetDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    type: QueryType;
    count: u32;
}

QueueDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
}

RenderBundleDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
}

RenderBundleEncoderDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    colorFormatCount: u64;
    colorFormats: /* const */ *TextureFormat;
    depthStencilFormat: TextureFormat;
    sampleCount: u32;
    depthReadOnly: Bool;
    stencilReadOnly: Bool;
}

RenderPassDepthStencilAttachment :: struct {
    nextInChain: *ChainedStruct;
    view: TextureView;
    depthLoadOp: LoadOp;
    depthStoreOp: StoreOp;
    depthClearValue: float32;
    depthReadOnly: Bool;
    stencilLoadOp: LoadOp;
    stencilStoreOp: StoreOp;
    stencilClearValue: u32;
    stencilReadOnly: Bool;
}

RenderPassMaxDrawCount :: struct {
    using chain: ChainedStruct;
    maxDrawCount: u64;
}

/*
Chained in a `RequestAdapterOptions`.
*/
RequestAdapterWebXROptions :: struct {
    using chain: ChainedStruct;
    xrCompatible: Bool;
}

SamplerBindingLayout :: struct {
    nextInChain: *ChainedStruct;
    type: SamplerBindingType;
}

SamplerDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    addressModeU: AddressMode;
    addressModeV: AddressMode;
    addressModeW: AddressMode;
    magFilter: FilterMode;
    minFilter: FilterMode;
    mipmapFilter: MipmapFilterMode;
    lodMinClamp: float32;
    lodMaxClamp: float32;
    compare: CompareFunction;
    maxAnisotropy: u16;
}

ShaderSourceSPIRV :: struct {
    using chain: ChainedStruct;
    codeSize: u32;
    code: /* const */ *u32;
}

ShaderSourceWGSL :: struct {
    using chain: ChainedStruct;
    code: StringView;
}

StencilFaceState :: struct {
    compare: CompareFunction;
    failOp: StencilOperation;
    depthFailOp: StencilOperation;
    passOp: StencilOperation;
}

StorageTextureBindingLayout :: struct {
    nextInChain: *ChainedStruct;
    access: StorageTextureAccess;
    format: TextureFormat;
    viewDimension: TextureViewDimension;
}

SupportedFeatures :: struct {
    featureCount: u64;
    features: /* const */ *FeatureName;
}

SupportedInstanceFeatures :: struct {
    featureCount: u64;
    features: /* const */ *InstanceFeatureName;
}

SupportedWGSLLanguageFeatures :: struct {
    featureCount: u64;
    features: /* const */ *WGSLLanguageFeatureName;
}

SurfaceCapabilities :: struct {
    nextInChain: *ChainedStruct;
    usages: TextureUsageFlags;
    formatCount: u64;
    formats: /* const */ *TextureFormat;
    presentModeCount: u64;
    presentModes: /* const */ *PresentMode;
    alphaModeCount: u64;
    alphaModes: /* const */ *CompositeAlphaMode;
}

/*
Chained in a `SurfaceConfiguration`.
*/
SurfaceColorManagement :: struct {
    using chain: ChainedStruct;
    colorSpace: PredefinedColorSpace;
    toneMappingMode: ToneMappingMode;
}

SurfaceConfiguration :: struct {
    nextInChain: *ChainedStruct;
    device: Device;
    format: TextureFormat;
    usage: TextureUsageFlags;
    width: u32;
    height: u32;
    viewFormatCount: u64;
    viewFormats: /* const */ *TextureFormat;
    alphaMode: CompositeAlphaMode;
    presentMode: PresentMode;
}

/*
Chained in a `SurfaceDescriptor`.
*/
SurfaceSourceAndroidNativeWindow :: struct {
    using chain: ChainedStruct;
    window: *void;
}

/*
Chained in a `SurfaceDescriptor`.
*/
SurfaceSourceMetalLayer :: struct {
    using chain: ChainedStruct;
    layer: *void;
}

/*
Chained in a `SurfaceDescriptor`.
*/
SurfaceSourceWaylandSurface :: struct {
    using chain: ChainedStruct;
    display: *void;
    surface: *void;
}

/*
Chained in a `SurfaceDescriptor`.
*/
SurfaceSourceWindowsHWND :: struct {
    using chain: ChainedStruct;
    hinstance: *void;
    hwnd: *void;
}

/*
Chained in a `SurfaceDescriptor`.
*/
SurfaceSourceXcbWindow :: struct {
    using chain: ChainedStruct;
    connection: *void;
    window: u32;
}

/*
Chained in a `SurfaceDescriptor`.
*/
SurfaceSourceXlibWindow :: struct {
    using chain: ChainedStruct;
    display: *void;
    window: u64;
}

SurfaceTexture :: struct {
    nextInChain: *ChainedStruct;
    texture: Texture;
    status: SurfaceGetCurrentTextureStatus;
}

TexelCopyBufferLayout :: struct {
    offset: u64;
    bytesPerRow: u32;
    rowsPerImage: u32;
}

TextureBindingLayout :: struct {
    nextInChain: *ChainedStruct;
    sampleType: TextureSampleType;
    viewDimension: TextureViewDimension;
    multisampled: Bool;
}

TextureBindingViewDimension :: struct {
    using chain: ChainedStruct;
    textureBindingViewDimension: TextureViewDimension;
}

TextureComponentSwizzle :: struct {
    r, g, b, a: ComponentSwizzle;
}

VertexAttribute :: struct {
    nextInChain: *ChainedStruct;
    format: VertexFormat;
    offset: u64;
    shaderLocation: u32;
}

BindGroupEntry :: struct {
    nextInChain: *ChainedStruct;
    binding: u32;
    buffer: /* NULLABLE */ Buffer;
    offset: u64;
    size: u64;
    sampler: /* NULLABLE */ Sampler;
    textureView: /* NULLABLE */ TextureView;
}

BindGroupLayoutEntry :: struct {
    nextInChain: *ChainedStruct;
    binding: u32;
    visibility: ShaderStageFlags;
    bindingArraySize: u32;
    buffer: BufferBindingLayout;
    sampler: SamplerBindingLayout;
    texture: TextureBindingLayout;
    storageTexture: StorageTextureBindingLayout;
}

BlendState :: struct {
    color: BlendComponent;
    alpha: BlendComponent;
}

CompilationInfo :: struct {
    nextInChain: *ChainedStruct;
    messageCount: u64;
    messages: /* const */ *CompilationMessage;
}

ComputePassDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    timestampWrites: /* NULLABLE */ /* const */ *PassTimestampWrites;
}

ComputeState :: struct {
    nextInChain: *ChainedStruct;
    module: ShaderModule;
    entryPoint: StringView;
    constantCount: u64;
    constants: *ConstantEntry;
}

DepthStencilState :: struct {
    nextInChain: *ChainedStruct;
    format: TextureFormat;
    depthWriteEnabled: OptionalBool;
    depthCompare: CompareFunction;
    stencilFront: StencilFaceState;
    stencilBack: StencilFaceState;
    stencilReadMask: u32;
    stencilWriteMask: u32;
    depthBias: s32;
    depthBiasSlopeScale: float32;
    depthBiasClamp: float32;
}

FutureWaitInfo :: struct {
    future: Future;
    completed: Bool;
}

InstanceDescriptor :: struct {
    nextInChain: *ChainedStruct;
    requiredFeatureCount: u64;
    requiredFeatures: *InstanceFeatureName;
    requiredLimits: /* NULLABLE */ *InstanceLimits;
}

Limits :: struct {
    nextInChain: *ChainedStruct;
    maxTextureDimension1D: u32;
    maxTextureDimension2D: u32;
    maxTextureDimension3D: u32;
    maxTextureArrayLayers: u32;
    maxBindGroups: u32;
    maxBindGroupsPlusVertexBuffers: u32;
    maxBindingsPerBindGroup: u32;
    maxDynamicUniformBuffersPerPipelineLayout: u32;
    maxDynamicStorageBuffersPerPipelineLayout: u32;
    maxSampledTexturesPerShaderStage: u32;
    maxSamplersPerShaderStage: u32;
    maxStorageBuffersPerShaderStage: u32;
    maxStorageTexturesPerShaderStage: u32;
    maxUniformBuffersPerShaderStage: u32;
    maxUniformBufferBindingSize: u64;
    maxStorageBufferBindingSize: u64;
    minUniformBufferOffsetAlignment: u32;
    minStorageBufferOffsetAlignment: u32;
    maxVertexBuffers: u32;
    maxBufferSize: u64;
    maxVertexAttributes: u32;
    maxVertexBufferArrayStride: u32;
    maxInterStageShaderVariables: u32;
    maxColorAttachments: u32;
    maxColorAttachmentBytesPerSample: u32;
    maxComputeWorkgroupStorageSize: u32;
    maxComputeInvocationsPerWorkgroup: u32;
    maxComputeWorkgroupSizeX: u32;
    maxComputeWorkgroupSizeY: u32;
    maxComputeWorkgroupSizeZ: u32;
    maxComputeWorkgroupsPerDimension: u32;
    maxImmediateSize: u32;
}

RenderPassColorAttachment :: struct {
    nextInChain: *ChainedStruct;
    view: /* NULLABLE */ TextureView;
    depthSlice: u32;
    resolveTarget: /* NULLABLE */ TextureView;
    loadOp: LoadOp;
    storeOp: StoreOp;
    clearValue: Color;
}

RequestAdapterOptions :: struct {
    nextInChain: *ChainedStruct;
    featureLevel: FeatureLevel;
    powerPreference: PowerPreference;
    forceFallbackAdapter: Bool;
    backendType: BackendType;
    compatibleSurface: /* NULLABLE */ Surface;
}

ShaderModuleDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
}

SurfaceDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
}

TexelCopyBufferInfo :: struct {
    layout: TexelCopyBufferLayout;
    buffer: Buffer;
}

TexelCopyTextureInfo :: struct {
    texture: Texture;
    mipLevel: u32;
    origin: Origin3D;
    aspect: TextureAspect;
}

/*
Chained in a `TextureViewDescriptor`.
*/
TextureComponentSwizzleDescriptor :: struct {
    using chain: ChainedStruct;
    swizzle: TextureComponentSwizzle;
}

TextureDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    usage: TextureUsageFlags;
    dimension: TextureDimension;
    size: Extent3D;
    format: TextureFormat;
    mipLevelCount: u32;
    sampleCount: u32;
    viewFormatCount: u64;
    viewFormats: /* const */ *TextureFormat;
}

VertexBufferLayout :: struct {
    nextInChain: *ChainedStruct;
    stepMode: VertexStepMode;
    arrayStride: u64;
    attributeCount: u64;
    attributes: /* const */ *VertexAttribute;
}

BindGroupDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    layout: BindGroupLayout;
    entryCount: u64;
    entries: /* const */ *BindGroupEntry;
}

BindGroupLayoutDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    entryCount: u64;
    entries: /* const */ *BindGroupLayoutEntry;
}

ColorTargetState :: struct {
    nextInChain: *ChainedStruct;
    format: TextureFormat;
    blend: /* NULLABLE */ /* const */ *BlendState;
    writeMask: ColorWriteMaskFlags;
}

ComputePipelineDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    layout: /* NULLABLE */ PipelineLayout;
    compute: ComputeState;
}

DeviceDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    requiredFeatureCount: u64;
    requiredFeatures: /* const */ *FeatureName;
    requiredLimits: /* NULLABLE */ /* const */ *Limits;
    defaultQueue: QueueDescriptor;
    deviceLostCallbackInfo: DeviceLostCallbackInfo;
    uncapturedErrorCallbackInfo: UncapturedErrorCallbackInfo;
}

RenderPassDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    colorAttachmentCount: u64;
    colorAttachments: /* const */ *RenderPassColorAttachment;
    depthStencilAttachment: /* NULLABLE */ /* const */ *RenderPassDepthStencilAttachment;
    occlusionQuerySet: /* NULLABLE */ QuerySet;
    timestampWrites: /* NULLABLE */ /* const */ *PassTimestampWrites;
}

TextureViewDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    format: TextureFormat;
    dimension: TextureViewDimension;
    baseMipLevel: u32;
    mipLevelCount: u32;
    baseArrayLayer: u32;
    arrayLayerCount: u32;
    aspect: TextureAspect;
    usage: TextureUsageFlags;
}

VertexState :: struct {
    nextInChain: *ChainedStruct;
    module: ShaderModule;
    entryPoint: StringView;
    constantCount: u64;
    constants: /* const */ *ConstantEntry;
    bufferCount: u64;
    buffers: /* const */ *VertexBufferLayout;
}

FragmentState :: struct {
    nextInChain: *ChainedStruct;
    module: ShaderModule;
    entryPoint: StringView;
    constantCount: u64;
    constants: /* const */ *ConstantEntry;
    targetCount: u64;
    targets: /* const */ *ColorTargetState;
}

RenderPipelineDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label: StringView;
    layout: /* NULLABLE */ PipelineLayout;
    vertex: VertexState;
    primitive: PrimitiveState;
    depthStencil: /* NULLABLE */ /* const */ *DepthStencilState;
    multisample: MultisampleState;
    fragment: /* NULLABLE */ /* const */ *FragmentState;
}

RawCreateInstance :: (/* NULLABLE */ descriptor: /* const */ *InstanceDescriptor = null) -> Instance #foreign libwgpu "wgpuCreateInstance";
GetInstanceFeatures :: (features: *SupportedInstanceFeatures) #foreign libwgpu "wgpuGetInstanceFeatures";
RawGetInstanceLimits :: (limits: *InstanceLimits) -> Status #foreign libwgpu "wgpuGetInstanceLimits";
HasInstanceFeature :: (feature: InstanceFeatureName) -> Bool #foreign libwgpu "wgpuHasInstanceFeature";
GetProcAddress :: (procName: StringView) -> Proc #foreign libwgpu "wgpuGetProcAddress";

// Methods of Adapter
RawAdapterGetFeatures :: (adapter: Adapter, features: *SupportedFeatures) #foreign libwgpu "wgpuAdapterGetFeatures";
RawAdapterGetInfo :: (adapter: Adapter, info: *AdapterInfo) -> Status #foreign libwgpu "wgpuAdapterGetInfo";
RawAdapterGetLimits :: (adapter: Adapter, limits: *Limits) -> Status #foreign libwgpu "wgpuAdapterGetLimits";
AdapterHasFeature :: (adapter: Adapter, feature: FeatureName) -> Bool #foreign libwgpu "wgpuAdapterHasFeature";
AdapterRequestDevice :: (adapter: Adapter, /* NULLABLE */ descriptor: /* const */ *DeviceDescriptor, callbackInfo: RequestDeviceCallbackInfo) -> Future #foreign libwgpu "wgpuAdapterRequestDevice";
AdapterAddRef :: (adapter: Adapter) #foreign libwgpu "wgpuAdapterAddRef";
AdapterRelease :: (adapter: Adapter) #foreign libwgpu "wgpuAdapterRelease";

// Procs of AdapterInfo
AdapterInfoFreeMembers :: (adapterInfo: AdapterInfo) #foreign libwgpu "wgpuAdapterInfoFreeMembers";

// Methods of BindGroup
BindGroupSetLabel :: (bindGroup: BindGroup, label: StringView) #foreign libwgpu "wgpuBindGroupSetLabel";
BindGroupAddRef :: (bindGroup: BindGroup) #foreign libwgpu "wgpuBindGroupAddRef";
BindGroupRelease :: (bindGroup: BindGroup) #foreign libwgpu "wgpuBindGroupRelease";

// Methods of BindGroupLayout
BindGroupLayoutSetLabel :: (bindGroupLayout: BindGroupLayout, label: StringView) #foreign libwgpu "wgpuBindGroupLayoutSetLabel";
BindGroupLayoutAddRef :: (bindGroupLayout: BindGroupLayout) #foreign libwgpu "wgpuBindGroupLayoutAddRef";
BindGroupLayoutRelease :: (bindGroupLayout: BindGroupLayout) #foreign libwgpu "wgpuBindGroupLayoutRelease";

// Methods of Buffer
BufferDestroy :: (buffer: Buffer) #foreign libwgpu "wgpuBufferDestroy";
RawBufferGetConstMappedRange :: (buffer: Buffer, offset: u64, size: u64) -> /* const */ *void #foreign libwgpu "wgpuBufferGetConstMappedRange";
RawBufferGetMappedRange :: (buffer: Buffer, offset: u64, size: u64) -> *void #foreign libwgpu "wgpuBufferGetMappedRange";
BufferGetMapState :: (buffer: Buffer) -> BufferMapState #foreign libwgpu "wgpuBufferGetMapState";
BufferGetSize :: (buffer: Buffer) -> u64 #foreign libwgpu "wgpuBufferGetSize";
BufferGetUsage :: (buffer: Buffer) -> BufferUsageFlags #foreign libwgpu "wgpuBufferGetUsage";
BufferMapAsync :: (buffer: Buffer, mode: MapModeFlags, offset: u64, size: u64, callbackInfo: BufferMapCallbackInfo) -> Future #foreign libwgpu "wgpuBufferMapAsync";
BufferReadMappedRange :: (buffer: Buffer, offset: u64, data: *void, size: u64) -> Status #foreign libwgpu "wgpuBufferReadMappedRange";
BufferSetLabel :: (buffer: Buffer, label: StringView) #foreign libwgpu "wgpuBufferSetLabel";
BufferUnmap :: (buffer: Buffer) #foreign libwgpu "wgpuBufferUnmap";
BufferWriteMappedRange :: (buffer: Buffer, offset: u64, data: /* const */ *void, size: u64) -> Status #foreign libwgpu "wgpuBufferWriteMappedRange";
BufferAddRef :: (buffer: Buffer) #foreign libwgpu "wgpuBufferAddRef";
BufferRelease :: (buffer: Buffer) #foreign libwgpu "wgpuBufferRelease";

// Methods of CommandBuffer
CommandBufferSetLabel :: (commandBuffer: CommandBuffer, label: StringView) #foreign libwgpu "wgpuCommandBufferSetLabel";
CommandBufferAddRef :: (commandBuffer: CommandBuffer) #foreign libwgpu "wgpuCommandBufferAddRef";
CommandBufferRelease :: (commandBuffer: CommandBuffer) #foreign libwgpu "wgpuCommandBufferRelease";

// Methods of CommandEncoder
CommandEncoderBeginComputePass :: (commandEncoder: CommandEncoder, /* NULLABLE */ descriptor: /* const */ *ComputePassDescriptor = null) -> ComputePassEncoder #foreign libwgpu "wgpuCommandEncoderBeginComputePass";
CommandEncoderBeginRenderPass :: (commandEncoder: CommandEncoder, descriptor: /* const */ *RenderPassDescriptor) -> RenderPassEncoder #foreign libwgpu "wgpuCommandEncoderBeginRenderPass";
CommandEncoderClearBuffer :: (commandEncoder: CommandEncoder, buffer: Buffer, offset: u64, size: u64) #foreign libwgpu "wgpuCommandEncoderClearBuffer";
CommandEncoderCopyBufferToBuffer :: (commandEncoder: CommandEncoder, source: Buffer, sourceOffset: u64, destination: Buffer, destinationOffset: u64, size: u64) #foreign libwgpu "wgpuCommandEncoderCopyBufferToBuffer";
CommandEncoderCopyBufferToTexture :: (commandEncoder: CommandEncoder, source: /* const */ *TexelCopyBufferInfo, destination: /* const */ *TexelCopyTextureInfo, copySize: /* const */ *Extent3D) #foreign libwgpu "wgpuCommandEncoderCopyBufferToTexture";
CommandEncoderCopyTextureToBuffer :: (commandEncoder: CommandEncoder, source: /* const */ *TexelCopyTextureInfo, destination: /* const */ *TexelCopyBufferInfo, copySize: /* const */ *Extent3D) #foreign libwgpu "wgpuCommandEncoderCopyTextureToBuffer";
CommandEncoderCopyTextureToTexture :: (commandEncoder: CommandEncoder, source: /* const */ *TexelCopyTextureInfo, destination: /* const */ *TexelCopyTextureInfo, copySize: /* const */ *Extent3D) #foreign libwgpu "wgpuCommandEncoderCopyTextureToTexture";
CommandEncoderFinish :: (commandEncoder: CommandEncoder, /* NULLABLE */ descriptor: /* const */ *CommandBufferDescriptor = null) -> CommandBuffer #foreign libwgpu "wgpuCommandEncoderFinish";
CommandEncoderInsertDebugMarker :: (commandEncoder: CommandEncoder, markerLabel: StringView) #foreign libwgpu "wgpuCommandEncoderInsertDebugMarker";
CommandEncoderPopDebugGroup :: (commandEncoder: CommandEncoder) #foreign libwgpu "wgpuCommandEncoderPopDebugGroup";
CommandEncoderPushDebugGroup :: (commandEncoder: CommandEncoder, groupLabel: StringView) #foreign libwgpu "wgpuCommandEncoderPushDebugGroup";
CommandEncoderResolveQuerySet :: (commandEncoder: CommandEncoder, querySet: QuerySet, firstQuery: u32, queryCount: u32, destination: Buffer, destinationOffset: u64) #foreign libwgpu "wgpuCommandEncoderResolveQuerySet";
CommandEncoderSetLabel :: (commandEncoder: CommandEncoder, label: StringView) #foreign libwgpu "wgpuCommandEncoderSetLabel";
CommandEncoderWriteTimestamp :: (commandEncoder: CommandEncoder, querySet: QuerySet, queryIndex: u32) #foreign libwgpu "wgpuCommandEncoderWriteTimestamp";
CommandEncoderAddRef :: (commandEncoder: CommandEncoder) #foreign libwgpu "wgpuCommandEncoderAddRef";
CommandEncoderRelease :: (commandEncoder: CommandEncoder) #foreign libwgpu "wgpuCommandEncoderRelease";

// Methods of ComputePassEncoder
ComputePassEncoderDispatchWorkgroups :: (computePassEncoder: ComputePassEncoder, workgroupCountX: u32, workgroupCountY: u32, workgroupCountZ: u32) #foreign libwgpu "wgpuComputePassEncoderDispatchWorkgroups";
ComputePassEncoderDispatchWorkgroupsIndirect :: (computePassEncoder: ComputePassEncoder, indirectBuffer: Buffer, indirectOffset: u64) #foreign libwgpu "wgpuComputePassEncoderDispatchWorkgroupsIndirect";
ComputePassEncoderEnd :: (computePassEncoder: ComputePassEncoder) #foreign libwgpu "wgpuComputePassEncoderEnd";
ComputePassEncoderInsertDebugMarker :: (computePassEncoder: ComputePassEncoder, markerLabel: StringView) #foreign libwgpu "wgpuComputePassEncoderInsertDebugMarker";
ComputePassEncoderPopDebugGroup :: (computePassEncoder: ComputePassEncoder) #foreign libwgpu "wgpuComputePassEncoderPopDebugGroup";
ComputePassEncoderPushDebugGroup :: (computePassEncoder: ComputePassEncoder, groupLabel: StringView) #foreign libwgpu "wgpuComputePassEncoderPushDebugGroup";
RawComputePassEncoderSetBindGroup :: (computePassEncoder: ComputePassEncoder, groupIndex: u32, /* NULLABLE */ group: BindGroup, dynamicOffsetCount: u64, dynamicOffsets: /* const */ *u32) #foreign libwgpu "wgpuComputePassEncoderSetBindGroup";
ComputePassEncoderSetImmediates :: (computePassEncoder: ComputePassEncoder, offset: u32, data: /* const */ *void, size: u64) #foreign libwgpu "wgpuComputePassEncoderSetImmediates";
ComputePassEncoderSetLabel :: (computePassEncoder: ComputePassEncoder, label: StringView) #foreign libwgpu "wgpuComputePassEncoderSetLabel";
ComputePassEncoderSetPipeline :: (computePassEncoder: ComputePassEncoder, pipeline: ComputePipeline) #foreign libwgpu "wgpuComputePassEncoderSetPipeline";
ComputePassEncoderAddRef :: (computePassEncoder: ComputePassEncoder) #foreign libwgpu "wgpuComputePassEncoderAddRef";
ComputePassEncoderRelease :: (computePassEncoder: ComputePassEncoder) #foreign libwgpu "wgpuComputePassEncoderRelease";

// Methods of ComputePipeline
ComputePipelineGetBindGroupLayout :: (computePipeline: ComputePipeline, groupIndex: u32) -> BindGroupLayout #foreign libwgpu "wgpuComputePipelineGetBindGroupLayout";
ComputePipelineSetLabel :: (computePipeline: ComputePipeline, label: StringView) #foreign libwgpu "wgpuComputePipelineSetLabel";
ComputePipelineAddRef :: (computePipeline: ComputePipeline) #foreign libwgpu "wgpuComputePipelineAddRef";
ComputePipelineRelease :: (computePipeline: ComputePipeline) #foreign libwgpu "wgpuComputePipelineRelease";

// Methods of Device
DeviceCreateBindGroup :: (device: Device, descriptor: /* const */ *BindGroupDescriptor) -> BindGroup #foreign libwgpu "wgpuDeviceCreateBindGroup";
DeviceCreateBindGroupLayout :: (device: Device, descriptor: /* const */ *BindGroupLayoutDescriptor) -> BindGroupLayout #foreign libwgpu "wgpuDeviceCreateBindGroupLayout";
DeviceCreateBuffer :: (device: Device, descriptor: /* const */ *BufferDescriptor) -> Buffer #foreign libwgpu "wgpuDeviceCreateBuffer";
DeviceCreateCommandEncoder :: (device: Device, /* NULLABLE */ descriptor: /* const */ *CommandEncoderDescriptor = null) -> CommandEncoder #foreign libwgpu "wgpuDeviceCreateCommandEncoder";
DeviceCreateComputePipeline :: (device: Device, descriptor: /* const */ *ComputePipelineDescriptor) -> ComputePipeline #foreign libwgpu "wgpuDeviceCreateComputePipeline";
DeviceCreateComputePipelineAsync :: (device: Device, descriptor: /* const */ *ComputePipelineDescriptor, callbackInfo: CreateComputePipelineAsyncCallbackInfo) -> Future #foreign libwgpu "wgpuDeviceCreateComputePipelineAsync";
DeviceCreatePipelineLayout :: (device: Device, descriptor: /* const */ *PipelineLayoutDescriptor) -> PipelineLayout #foreign libwgpu "wgpuDeviceCreatePipelineLayout";
DeviceCreateQuerySet :: (device: Device, descriptor: /* const */ *QuerySetDescriptor) -> QuerySet #foreign libwgpu "wgpuDeviceCreateQuerySet";
DeviceCreateRenderBundleEncoder :: (device: Device, descriptor: /* const */ *RenderBundleEncoderDescriptor) -> RenderBundleEncoder #foreign libwgpu "wgpuDeviceCreateRenderBundleEncoder";
DeviceCreateRenderPipeline :: (device: Device, descriptor: /* const */ *RenderPipelineDescriptor) -> RenderPipeline #foreign libwgpu "wgpuDeviceCreateRenderPipeline";
DeviceCreateRenderPipelineAsync :: (device: Device, descriptor: /* const */ *RenderPipelineDescriptor, callbackInfo: CreateRenderPipelineAsyncCallbackInfo) -> Future #foreign libwgpu "wgpuDeviceCreateRenderPipelineAsync";
DeviceCreateSampler :: (device: Device, /* NULLABLE */ descriptor: /* const */ *SamplerDescriptor = null) -> Sampler #foreign libwgpu "wgpuDeviceCreateSampler";
DeviceCreateShaderModule :: (device: Device, descriptor: /* const */ *ShaderModuleDescriptor) -> ShaderModule #foreign libwgpu "wgpuDeviceCreateShaderModule";
DeviceCreateTexture :: (device: Device, descriptor: /* const */ *TextureDescriptor) -> Texture #foreign libwgpu "wgpuDeviceCreateTexture";
DeviceDestroy :: (device: Device) #foreign libwgpu "wgpuDeviceDestroy";
RawDeviceGetAdapterInfo :: (device: Device, info: *AdapterInfo) -> Status #foreign libwgpu "wgpuDeviceGetAdapterInfo";
RawDeviceGetFeatures :: (device: Device, features: *SupportedFeatures) #foreign libwgpu "wgpuDeviceGetFeatures";
RawDeviceGetLimits :: (device: Device, limits: *Limits) -> Status #foreign libwgpu "wgpuDeviceGetLimits";
DeviceGetLostFuture :: (device: Device) -> Future #foreign libwgpu "wgpuDeviceGetLostFuture";
DeviceGetQueue :: (device: Device) -> Queue #foreign libwgpu "wgpuDeviceGetQueue";
DeviceHasFeature :: (device: Device, feature: FeatureName) -> Bool #foreign libwgpu "wgpuDeviceHasFeature";
DevicePopErrorScope :: (device: Device, callbackInfo: PopErrorScopeCallbackInfo) -> Future #foreign libwgpu "wgpuDevicePopErrorScope";
DevicePushErrorScope :: (device: Device, filter: ErrorFilter) #foreign libwgpu "wgpuDevicePushErrorScope";
DeviceSetLabel :: (device: Device, label: StringView) #foreign libwgpu "wgpuDeviceSetLabel";
DeviceAddRef :: (device: Device) #foreign libwgpu "wgpuDeviceAddRef";
DeviceRelease :: (device: Device) #foreign libwgpu "wgpuDeviceRelease";

// Methods of ExternalTexture
ExternalTextureSetLabel :: (externalTexture: ExternalTexture, label: StringView) #foreign libwgpu "wgpuExternalTextureSetLabel";
ExternalTextureAddRef :: (externalTexture: ExternalTexture) #foreign libwgpu "wgpuExternalTextureAddRef";
ExternalTextureRelease :: (externalTexture: ExternalTexture) #foreign libwgpu "wgpuExternalTextureRelease";

// Methods of Instance
InstanceCreateSurface :: (instance: Instance, descriptor: /* const */ *SurfaceDescriptor) -> Surface #foreign libwgpu "wgpuInstanceCreateSurface";
InstanceGetWGSLLanguageFeatures :: (instance: Instance, features: *SupportedWGSLLanguageFeatures) #foreign libwgpu "wgpuInstanceGetWGSLLanguageFeatures";
InstanceHasWGSLLanguageFeature :: (instance: Instance, feature: WGSLLanguageFeatureName) -> Bool #foreign libwgpu "wgpuInstanceHasWGSLLanguageFeature";
InstanceProcessEvents :: (instance: Instance) #foreign libwgpu "wgpuInstanceProcessEvents";
InstanceRequestAdapter :: (instance: Instance, /* NULLABLE */ options: /* const */ *RequestAdapterOptions, callbackInfo: RequestAdapterCallbackInfo) -> Future #foreign libwgpu "wgpuInstanceRequestAdapter";
InstanceWaitAny :: (instance: Instance, futureCount: u64, futures: *FutureWaitInfo, timeoutNS: u64) -> WaitStatus #foreign libwgpu "wgpuInstanceWaitAny";
InstanceAddRef :: (instance: Instance) #foreign libwgpu "wgpuInstanceAddRef";
InstanceRelease :: (instance: Instance) #foreign libwgpu "wgpuInstanceRelease";

// Methods of PipelineLayout
PipelineLayoutSetLabel :: (pipelineLayout: PipelineLayout, label: StringView) #foreign libwgpu "wgpuPipelineLayoutSetLabel";
PipelineLayoutAddRef :: (pipelineLayout: PipelineLayout) #foreign libwgpu "wgpuPipelineLayoutAddRef";
PipelineLayoutRelease :: (pipelineLayout: PipelineLayout) #foreign libwgpu "wgpuPipelineLayoutRelease";

// Methods of QuerySet
QuerySetDestroy :: (querySet: QuerySet) #foreign libwgpu "wgpuQuerySetDestroy";
QuerySetGetCount :: (querySet: QuerySet) -> u32 #foreign libwgpu "wgpuQuerySetGetCount";
QuerySetGetType :: (querySet: QuerySet) -> QueryType #foreign libwgpu "wgpuQuerySetGetType";
QuerySetSetLabel :: (querySet: QuerySet, label: StringView) #foreign libwgpu "wgpuQuerySetSetLabel";
QuerySetAddRef :: (querySet: QuerySet) #foreign libwgpu "wgpuQuerySetAddRef";
QuerySetRelease :: (querySet: QuerySet) #foreign libwgpu "wgpuQuerySetRelease";

// Methods of Queue
QueueOnSubmittedWorkDone :: (queue: Queue, callbackInfo: QueueWorkDoneCallbackInfo) -> Future #foreign libwgpu "wgpuQueueOnSubmittedWorkDone";
QueueSetLabel :: (queue: Queue, label: StringView) #foreign libwgpu "wgpuQueueSetLabel";
RawQueueSubmit :: (queue: Queue, commandCount: u64, commands: /* const */ *CommandBuffer) #foreign libwgpu "wgpuQueueSubmit";
QueueWriteBuffer :: (queue: Queue, buffer: Buffer, bufferOffset: u64, data: /* const */ *void, size: u64) #foreign libwgpu "wgpuQueueWriteBuffer";
QueueWriteTexture :: (queue: Queue, destination: /* const */ *TexelCopyTextureInfo, data: /* const */ *void, dataSize: u64, dataLayout: /* const */ *TexelCopyBufferLayout, writeSize: /* const */ *Extent3D) #foreign libwgpu "wgpuQueueWriteTexture";
QueueAddRef :: (queue: Queue) #foreign libwgpu "wgpuQueueAddRef";
QueueRelease :: (queue: Queue) #foreign libwgpu "wgpuQueueRelease";

// Methods of RenderBundle
RenderBundleSetLabel :: (renderBundle: RenderBundle, label: StringView) #foreign libwgpu "wgpuRenderBundleSetLabel";
RenderBundleAddRef :: (renderBundle: RenderBundle) #foreign libwgpu "wgpuRenderBundleAddRef";
RenderBundleRelease :: (renderBundle: RenderBundle) #foreign libwgpu "wgpuRenderBundleRelease";

// Methods of RenderBundleEncoder
RenderBundleEncoderDraw :: (renderBundleEncoder: RenderBundleEncoder, vertexCount: u32, instanceCount: u32, firstVertex: u32, firstInstance: u32) #foreign libwgpu "wgpuRenderBundleEncoderDraw";
RenderBundleEncoderDrawIndexed :: (renderBundleEncoder: RenderBundleEncoder, indexCount: u32, instanceCount: u32, firstIndex: u32, baseVertex: s32, firstInstance: u32) #foreign libwgpu "wgpuRenderBundleEncoderDrawIndexed";
RenderBundleEncoderDrawIndexedIndirect :: (renderBundleEncoder: RenderBundleEncoder, indirectBuffer: Buffer, indirectOffset: u64) #foreign libwgpu "wgpuRenderBundleEncoderDrawIndexedIndirect";
RenderBundleEncoderDrawIndirect :: (renderBundleEncoder: RenderBundleEncoder, indirectBuffer: Buffer, indirectOffset: u64) #foreign libwgpu "wgpuRenderBundleEncoderDrawIndirect";
RenderBundleEncoderFinish :: (renderBundleEncoder: RenderBundleEncoder, /* NULLABLE */ descriptor: /* const */ *RenderBundleDescriptor = null) -> RenderBundle #foreign libwgpu "wgpuRenderBundleEncoderFinish";
RenderBundleEncoderInsertDebugMarker :: (renderBundleEncoder: RenderBundleEncoder, markerLabel: StringView) #foreign libwgpu "wgpuRenderBundleEncoderInsertDebugMarker";
RenderBundleEncoderPopDebugGroup :: (renderBundleEncoder: RenderBundleEncoder) #foreign libwgpu "wgpuRenderBundleEncoderPopDebugGroup";
RenderBundleEncoderPushDebugGroup :: (renderBundleEncoder: RenderBundleEncoder, groupLabel: StringView) #foreign libwgpu "wgpuRenderBundleEncoderPushDebugGroup";
RawRenderBundleEncoderSetBindGroup :: (renderBundleEncoder: RenderBundleEncoder, groupIndex: u32, /* NULLABLE */ group: BindGroup, dynamicOffsetCount: u64, dynamicOffsets: /* const */ *u32) #foreign libwgpu "wgpuRenderBundleEncoderSetBindGroup";
RenderBundleEncoderSetImmediates :: (renderBundleEncoder: RenderBundleEncoder, offset: u32, data: /* const */ *void, size: u64) #foreign libwgpu "wgpuRenderBundleEncoderSetImmediates";
RenderBundleEncoderSetIndexBuffer :: (renderBundleEncoder: RenderBundleEncoder, buffer: Buffer, format: IndexFormat, offset: u64, size: u64) #foreign libwgpu "wgpuRenderBundleEncoderSetIndexBuffer";
RenderBundleEncoderSetLabel :: (renderBundleEncoder: RenderBundleEncoder, label: StringView) #foreign libwgpu "wgpuRenderBundleEncoderSetLabel";
RenderBundleEncoderSetPipeline :: (renderBundleEncoder: RenderBundleEncoder, pipeline: RenderPipeline) #foreign libwgpu "wgpuRenderBundleEncoderSetPipeline";
RenderBundleEncoderSetVertexBuffer :: (renderBundleEncoder: RenderBundleEncoder, slot: u32, /* NULLABLE */ buffer: Buffer, offset: u64, size: u64) #foreign libwgpu "wgpuRenderBundleEncoderSetVertexBuffer";
RenderBundleEncoderAddRef :: (renderBundleEncoder: RenderBundleEncoder) #foreign libwgpu "wgpuRenderBundleEncoderAddRef";
RenderBundleEncoderRelease :: (renderBundleEncoder: RenderBundleEncoder) #foreign libwgpu "wgpuRenderBundleEncoderRelease";

// Methods of RenderPassEncoder
RenderPassEncoderBeginOcclusionQuery :: (renderPassEncoder: RenderPassEncoder, queryIndex: u32) #foreign libwgpu "wgpuRenderPassEncoderBeginOcclusionQuery";
RenderPassEncoderDraw :: (renderPassEncoder: RenderPassEncoder, vertexCount: u32, instanceCount: u32, firstVertex: u32, firstInstance: u32) #foreign libwgpu "wgpuRenderPassEncoderDraw";
RenderPassEncoderDrawIndexed :: (renderPassEncoder: RenderPassEncoder, indexCount: u32, instanceCount: u32, firstIndex: u32, baseVertex: s32, firstInstance: u32) #foreign libwgpu "wgpuRenderPassEncoderDrawIndexed";
RenderPassEncoderDrawIndexedIndirect :: (renderPassEncoder: RenderPassEncoder, indirectBuffer: Buffer, indirectOffset: u64) #foreign libwgpu "wgpuRenderPassEncoderDrawIndexedIndirect";
RenderPassEncoderDrawIndirect :: (renderPassEncoder: RenderPassEncoder, indirectBuffer: Buffer, indirectOffset: u64) #foreign libwgpu "wgpuRenderPassEncoderDrawIndirect";
RenderPassEncoderEnd :: (renderPassEncoder: RenderPassEncoder) #foreign libwgpu "wgpuRenderPassEncoderEnd";
RenderPassEncoderEndOcclusionQuery :: (renderPassEncoder: RenderPassEncoder) #foreign libwgpu "wgpuRenderPassEncoderEndOcclusionQuery";
RawRenderPassEncoderExecuteBundles :: (renderPassEncoder: RenderPassEncoder, bundleCount: u64, bundles: /* const */ *RenderBundle) #foreign libwgpu "wgpuRenderPassEncoderExecuteBundles";
RenderPassEncoderInsertDebugMarker :: (renderPassEncoder: RenderPassEncoder, markerLabel: StringView) #foreign libwgpu "wgpuRenderPassEncoderInsertDebugMarker";
RenderPassEncoderPopDebugGroup :: (renderPassEncoder: RenderPassEncoder) #foreign libwgpu "wgpuRenderPassEncoderPopDebugGroup";
RenderPassEncoderPushDebugGroup :: (renderPassEncoder: RenderPassEncoder, groupLabel: StringView) #foreign libwgpu "wgpuRenderPassEncoderPushDebugGroup";
RawRenderPassEncoderSetBindGroup :: (renderPassEncoder: RenderPassEncoder, groupIndex: u32, /* NULLABLE */ group: BindGroup, dynamicOffsetCount: u64, dynamicOffsets: /* const */ *u32) #foreign libwgpu "wgpuRenderPassEncoderSetBindGroup";
RenderPassEncoderSetImmediates :: (renderPassEncoder: RenderPassEncoder, offset: u32, data: /* const */ *void, size: u64) #foreign libwgpu "wgpuRenderPassEncoderSetImmediates";
RenderPassEncoderSetBlendConstant :: (renderPassEncoder: RenderPassEncoder, color: /* const */ *Color) #foreign libwgpu "wgpuRenderPassEncoderSetBlendConstant";
RenderPassEncoderSetIndexBuffer :: (renderPassEncoder: RenderPassEncoder, buffer: Buffer, format: IndexFormat, offset: u64, size: u64) #foreign libwgpu "wgpuRenderPassEncoderSetIndexBuffer";
RenderPassEncoderSetLabel :: (renderPassEncoder: RenderPassEncoder, label: StringView) #foreign libwgpu "wgpuRenderPassEncoderSetLabel";
RenderPassEncoderSetPipeline :: (renderPassEncoder: RenderPassEncoder, pipeline: RenderPipeline) #foreign libwgpu "wgpuRenderPassEncoderSetPipeline";
RenderPassEncoderSetScissorRect :: (renderPassEncoder: RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) #foreign libwgpu "wgpuRenderPassEncoderSetScissorRect";
RenderPassEncoderSetStencilReference :: (renderPassEncoder: RenderPassEncoder, reference: u32) #foreign libwgpu "wgpuRenderPassEncoderSetStencilReference";
RenderPassEncoderSetVertexBuffer :: (renderPassEncoder: RenderPassEncoder, slot: u32, /* NULLABLE */ buffer: Buffer, offset: u64, size: u64) #foreign libwgpu "wgpuRenderPassEncoderSetVertexBuffer";
RenderPassEncoderSetViewport :: (renderPassEncoder: RenderPassEncoder, x: float32, y: float32, width: float32, height: float32, minDepth: float32, maxDepth: float32) #foreign libwgpu "wgpuRenderPassEncoderSetViewport";
RenderPassEncoderAddRef :: (renderPassEncoder: RenderPassEncoder) #foreign libwgpu "wgpuRenderPassEncoderAddRef";
RenderPassEncoderRelease :: (renderPassEncoder: RenderPassEncoder) #foreign libwgpu "wgpuRenderPassEncoderRelease";

// Methods of RenderPipeline
RenderPipelineGetBindGroupLayout :: (renderPipeline: RenderPipeline, groupIndex: u32) -> BindGroupLayout #foreign libwgpu "wgpuRenderPipelineGetBindGroupLayout";
RenderPipelineSetLabel :: (renderPipeline: RenderPipeline, label: StringView) #foreign libwgpu "wgpuRenderPipelineSetLabel";
RenderPipelineAddRef :: (renderPipeline: RenderPipeline) #foreign libwgpu "wgpuRenderPipelineAddRef";
RenderPipelineRelease :: (renderPipeline: RenderPipeline) #foreign libwgpu "wgpuRenderPipelineRelease";

// Methods of Sampler
SamplerSetLabel :: (sampler: Sampler, label: StringView) #foreign libwgpu "wgpuSamplerSetLabel";
SamplerAddRef :: (sampler: Sampler) #foreign libwgpu "wgpuSamplerAddRef";
SamplerRelease :: (sampler: Sampler) #foreign libwgpu "wgpuSamplerRelease";

// Methods of ShaderModule
ShaderModuleGetCompilationInfo :: (shaderModule: ShaderModule, callbackInfo: CompilationInfoCallbackInfo) -> Future #foreign libwgpu "wgpuShaderModuleGetCompilationInfo";
ShaderModuleSetLabel :: (shaderModule: ShaderModule, label: StringView) #foreign libwgpu "wgpuShaderModuleSetLabel";
ShaderModuleAddRef :: (shaderModule: ShaderModule) #foreign libwgpu "wgpuShaderModuleAddRef";
ShaderModuleRelease :: (shaderModule: ShaderModule) #foreign libwgpu "wgpuShaderModuleRelease";

// Methods of SupportedFeatures
SupportedFeaturesFreeMembers :: (supportedFeatures: SupportedFeatures) #foreign libwgpu "wgpuSupportedFeaturesFreeMembers";

// Methods of SupportedInstanceFeatures
SupportedInstanceFeaturesFreeMembers :: (supportedInstanceFeatures: SupportedInstanceFeatures) #foreign libwgpu "wgpuSupportedInstanceFeaturesFreeMembers";

// Methods of SupportedWGSLLanguageFeatures
SupportedWGSLLanguageFeaturesFreeMembers :: (supportedWGSLLanguageFeatures: SupportedWGSLLanguageFeatures) #foreign libwgpu "wgpuSupportedWGSLLanguageFeaturesFreeMembers";

// Methods of Surface
SurfaceConfigure :: (surface: Surface, config: /* const */ *SurfaceConfiguration) #foreign libwgpu "wgpuSurfaceConfigure";
RawSurfaceGetCapabilities :: (surface: Surface, adapter: Adapter, capabilities: *SurfaceCapabilities) -> Status #foreign libwgpu "wgpuSurfaceGetCapabilities";
RawSurfaceGetCurrentTexture :: (surface: Surface, surfaceTexture: *SurfaceTexture) #foreign libwgpu "wgpuSurfaceGetCurrentTexture";
SurfacePresent :: (surface: Surface) -> Status #foreign libwgpu "wgpuSurfacePresent";
SurfaceSetLabel :: (surface: Surface, label: StringView) #foreign libwgpu "wgpuSurfaceSetLabel";
SurfaceUnconfigure :: (surface: Surface) #foreign libwgpu "wgpuSurfaceUnconfigure";
SurfaceAddRef :: (surface: Surface) #foreign libwgpu "wgpuSurfaceAddRef";
SurfaceRelease :: (surface: Surface) #foreign libwgpu "wgpuSurfaceRelease";

// Methods of SurfaceCapabilities
SurfaceCapabilitiesFreeMembers :: (surfaceCapabilities: SurfaceCapabilities) #foreign libwgpu "wgpuSurfaceCapabilitiesFreeMembers";

// Methods of Texture
TextureCreateView :: (texture: Texture, /* NULLABLE */ descriptor: /* const */ *TextureViewDescriptor = null) -> TextureView #foreign libwgpu "wgpuTextureCreateView";
TextureDestroy :: (texture: Texture) #foreign libwgpu "wgpuTextureDestroy";
TextureGetDepthOrArrayLayers :: (texture: Texture) -> u32 #foreign libwgpu "wgpuTextureGetDepthOrArrayLayers";
TextureGetDimension :: (texture: Texture) -> TextureDimension #foreign libwgpu "wgpuTextureGetDimension";
TextureGetFormat :: (texture: Texture) -> TextureFormat #foreign libwgpu "wgpuTextureGetFormat";
TextureGetHeight :: (texture: Texture) -> u32 #foreign libwgpu "wgpuTextureGetHeight";
TextureGetMipLevelCount :: (texture: Texture) -> u32 #foreign libwgpu "wgpuTextureGetMipLevelCount";
TextureGetSampleCount :: (texture: Texture) -> u32 #foreign libwgpu "wgpuTextureGetSampleCount";
TextureGetTextureBindingViewDimension :: (texture: Texture) -> TextureViewDimension #foreign libwgpu "wgpuTextureGetTextureBindingViewDimension";
TextureGetUsage :: (texture: Texture) -> TextureUsageFlags #foreign libwgpu "wgpuTextureGetUsage";
TextureGetWidth :: (texture: Texture) -> u32 #foreign libwgpu "wgpuTextureGetWidth";
TextureSetLabel :: (texture: Texture, label: StringView) #foreign libwgpu "wgpuTextureSetLabel";
TextureAddRef :: (texture: Texture) #foreign libwgpu "wgpuTextureAddRef";
TextureRelease :: (texture: Texture) #foreign libwgpu "wgpuTextureRelease";

// Methods of TextureView
TextureViewSetLabel :: (textureView: TextureView, label: StringView) #foreign libwgpu "wgpuTextureViewSetLabel";
TextureViewAddRef :: (textureView: TextureView) #foreign libwgpu "wgpuTextureViewAddRef";
TextureViewRelease :: (textureView: TextureView) #foreign libwgpu "wgpuTextureViewRelease";

// Wrappers of Instance

CreateInstance :: (/* NULLABLE */ descriptor: /* const */ *InstanceDescriptor = null) -> Instance {
    // The version is encoded as 0xMMmmppbb (major, minor, patch, build).
    v := GetVersion();
    major := cast,trunc(u8) (v >> 24);
    minor := cast,trunc(u8) (v >> 16);
    patch := cast,trunc(u8) (v >> 8);

    if major != BINDINGS_VERSION[0] || minor != BINDINGS_VERSION[1] || patch != BINDINGS_VERSION[2] {
        wgpu_panic(tprint("wgpu-native version mismatch: bindings are for version %, but a different version (%.%.%.%) is linked", BINDINGS_VERSION_STRING, major, minor, patch, cast,trunc(u8) v));
    }

    return RawCreateInstance(descriptor);
}

GetInstanceLimits :: () -> limits: InstanceLimits, status: Status {
    limits: InstanceLimits;
    status := RawGetInstanceLimits(*limits);
    return limits, status;
}

// Wrappers of Adapter

AdapterGetLimits :: (adapter: Adapter) -> limits: Limits, status: Status {
    limits: Limits;
    status := RawAdapterGetLimits(adapter, *limits);
    return limits, status;
}

AdapterGetInfo :: (adapter: Adapter) -> info: AdapterInfo, status: Status {
    info: AdapterInfo;
    status := RawAdapterGetInfo(adapter, *info);
    return info, status;
}

AdapterGetFeatures :: (adapter: Adapter) -> features: SupportedFeatures {
    features: SupportedFeatures;
    RawAdapterGetFeatures(adapter, *features);
    return features;
}

// Wrappers of Buffer

BufferGetConstMappedRange :: (buffer: Buffer, offset: u64, size: u64) -> [] u8 {
    result: [] u8;
    result.data = RawBufferGetConstMappedRange(buffer, offset, size);
    result.count = cast(s64) size;
    return result;
}

BufferGetConstMappedRangeTyped :: (buffer: Buffer, offset: u64, $T: Type) -> *T
#modify {
    return !is_array_type(T), "T must not be an array type, use BufferGetConstMappedRangeSlice instead.";
} {
    return cast(*T) RawBufferGetConstMappedRange(buffer, offset, size_of(T));
}

BufferGetConstMappedRangeSlice :: (buffer: Buffer, offset: u64, length: u64, $T: Type) -> [] T {
    result: [] T;
    result.data = RawBufferGetConstMappedRange(buffer, offset, size_of(T) * length);
    result.count = cast(s64) length;
    return result;
}

BufferGetMappedRange :: (buffer: Buffer, offset: u64, size: u64) -> [] u8 {
    result: [] u8;
    result.data = RawBufferGetMappedRange(buffer, offset, size);
    result.count = cast(s64) size;
    return result;
}

BufferGetMappedRangeTyped :: (buffer: Buffer, offset: u64, $T: Type) -> *T
#modify {
    return !is_array_type(T), "T must not be an array type, use BufferGetMappedRangeSlice instead.";
} {
    return cast(*T) RawBufferGetMappedRange(buffer, offset, size_of(T));
}

BufferGetMappedRangeSlice :: (buffer: Buffer, offset: u64, $T: Type, length: u64) -> [] T {
    result: [] T;
    result.data = RawBufferGetMappedRange(buffer, offset, size_of(T) * length);
    result.count = cast(s64) length;
    return result;
}

// Wrappers of ComputePassEncoder

ComputePassEncoderSetBindGroup :: (computePassEncoder: ComputePassEncoder, groupIndex: u32, /* NULLABLE */ group: BindGroup, dynamicOffsets: [] u32 = .[]) {
    RawComputePassEncoderSetBindGroup(computePassEncoder, groupIndex, group, cast(u64) dynamicOffsets.count, dynamicOffsets.data);
}

// Wrappers of Device

DeviceGetLimits :: (device: Device) -> limits: Limits, status: Status {
    limits: Limits;
    status := RawDeviceGetLimits(device, *limits);
    return limits, status;
}

DeviceGetAdapterInfo :: (device: Device) -> info: AdapterInfo, status: Status {
    info: AdapterInfo;
    status := RawDeviceGetAdapterInfo(device, *info);
    return info, status;
}

DeviceGetFeatures :: (device: Device) -> features: SupportedFeatures {
    features: SupportedFeatures;
    RawDeviceGetFeatures(device, *features);
    return features;
}

BufferWithDataDescriptor :: struct {
    label: /* NULLABLE */ StringView;
    usage: BufferUsageFlags;
}

DeviceCreateBufferWithData :: (device: Device, descriptor: /* const */ *BufferWithDataDescriptor, data: [] $T) -> Buffer {
    size := cast(u64) (size_of(T) * data.count);
    buffer_descriptor := BufferDescriptor.{
        label = descriptor.label,
        usage = descriptor.usage,
        size = size,
        mappedAtCreation = TRUE,
    };
    buf := DeviceCreateBuffer(device, *buffer_descriptor);

    mapping := BufferGetMappedRangeSlice(buf, 0, T, cast(u64) data.count);
    memcpy(mapping.data, data.data, cast(s64) size);

    BufferUnmap(buf);
    return buf;
}

DeviceCreateBufferWithData :: (device: Device, descriptor: /* const */ *BufferWithDataDescriptor, data: $T) -> Buffer
#modify {
    return !is_array_type(T);
} {
    buffer_descriptor := BufferDescriptor.{
        label = descriptor.label,
        usage = descriptor.usage,
        size = size_of(T),
        mappedAtCreation = TRUE,
    };
    buf := DeviceCreateBuffer(device, *buffer_descriptor);

    mapping := BufferGetMappedRangeTyped(buf, 0, T);
    mapping.* = data;

    BufferUnmap(buf);
    return buf;
}

// Wrappers of Queue

QueueSubmit :: (queue: Queue, commands: [] CommandBuffer) {
    RawQueueSubmit(queue, cast(u64) commands.count, commands.data);
}

// Wrappers of RenderBundleEncoder

RenderBundleEncoderSetBindGroup :: (renderBundleEncoder: RenderBundleEncoder, groupIndex: u32, /* NULLABLE */ group: BindGroup, dynamicOffsets: [] u32 = .[]) {
    RawRenderBundleEncoderSetBindGroup(renderBundleEncoder, groupIndex, group, cast(u64) dynamicOffsets.count, dynamicOffsets.data);
}

// Wrappers of RenderPassEncoder

RenderPassEncoderExecuteBundles :: (renderPassEncoder: RenderPassEncoder, bundles: [] RenderBundle) {
    RawRenderPassEncoderExecuteBundles(renderPassEncoder, cast(u64) bundles.count, bundles.data);
}

RenderPassEncoderSetBindGroup :: (renderPassEncoder: RenderPassEncoder, groupIndex: u32, /* NULLABLE */ group: BindGroup, dynamicOffsets: [] u32 = .[]) {
    RawRenderPassEncoderSetBindGroup(renderPassEncoder, groupIndex, group, cast(u64) dynamicOffsets.count, dynamicOffsets.data);
}

// Wrappers of Surface

SurfaceGetCapabilities :: (surface: Surface, adapter: Adapter) -> capabilities: SurfaceCapabilities, status: Status {
    capabilities: SurfaceCapabilities;
    status := RawSurfaceGetCapabilities(surface, adapter, *capabilities);
    return capabilities, status;
}

SurfaceGetCurrentTexture :: (surface: Surface) -> surface_texture: SurfaceTexture {
    surface_texture: SurfaceTexture;
    RawSurfaceGetCurrentTexture(surface, *surface_texture);
    return surface_texture;
}

#scope_module

// Equivalent of Odin's 'panic': report like a failed assertion (with stack trace), then stop the program.
wgpu_panic :: (message: string, loc := #caller_location) {
    if assert_helper(message, loc = loc) debug_break();
    exit(1);
}

#scope_file

is_array_type :: (T: Type) -> bool {
    return (cast(*Type_Info) T).type == .ARRAY;
}
