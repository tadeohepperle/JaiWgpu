BINDINGS_VERSION        :: u8.[29, 0, 1, 1];
BINDINGS_VERSION_STRING :: "29.0.1.1";

LogLevel :: enum s32 {
    Off   :: 0x00000000;
    Error :: 0x00000001;
    Warn  :: 0x00000002;
    Info  :: 0x00000003;
    Debug :: 0x00000004;
    Trace :: 0x00000005;
}

InstanceBackend :: enum_flags u64 {
    All           :: 0;
    Vulkan        :: 1 << 0;
    GL            :: 1 << 1;
    Metal         :: 1 << 2;
    DX12          :: 1 << 3;
    // DX11       :: 1 << 4;
    BrowserWebGPU :: 1 << 5;
    Primary       :: Vulkan | Metal | DX12 | BrowserWebGPU;
    Secondary     :: GL;
}
InstanceBackendFlags :: InstanceBackend;
InstanceBackendFlags_All       :: InstanceBackendFlags.All;
InstanceBackendFlags_Primary   :: InstanceBackendFlags.Primary;
InstanceBackendFlags_Secondary :: InstanceBackendFlags.Secondary;

InstanceFlag :: enum_flags u64 {
    Empty                              :: 0;
    Debug                              :: 1 << 0;
    Validation                         :: 1 << 1;
    DiscardHalLabels                   :: 1 << 2;
    AllowUnderlyingNoncompliantAdapter :: 1 << 3;
    GPUBasedValidation                 :: 1 << 4;
    ValidationIndirectCall             :: 1 << 5;
    AutomaticTimestampNormalization    :: 1 << 6;
    Default                            :: 1 << 24;
    Debugging                          :: 1 << 25;
    AdvancedDebugging                  :: 1 << 26;
    WithEnv                            :: 1 << 27;
}
InstanceFlags :: InstanceFlag;
InstanceFlags_Empty :: InstanceFlags.Empty;

Dx12Compiler :: enum s32 {
    Undefined :: 0x00000000;
    Fxc       :: 0x00000001;
    Dxc       :: 0x00000002;
}

Gles3MinorVersion :: enum s32 {
    Automatic :: 0x00000000;
    Version0  :: 0x00000001;
    Version1  :: 0x00000002;
    Version2  :: 0x00000003;
}

PipelineStatisticName :: enum s32 {
    VertexShaderInvocations   :: 0x00000000;
    ClipperInvocations        :: 0x00000001;
    ClipperPrimitivesOut      :: 0x00000002;
    FragmentShaderInvocations :: 0x00000003;
    ComputeShaderInvocations  :: 0x00000004;
}

DxcMaxShaderModel :: enum s32 {
    V6_0 :: 0x00000000;
    V6_1 :: 0x00000001;
    V6_2 :: 0x00000002;
    V6_3 :: 0x00000003;
    V6_4 :: 0x00000004;
    V6_5 :: 0x00000005;
    V6_6 :: 0x00000006;
    V6_7 :: 0x00000007;
}

GLFenceBehaviour :: enum s32 {
    Normal     :: 0x00000000;
    AutoFinish :: 0x00000001;
}

Dx12SwapchainKind :: enum s32 {
    Undefined      :: 0x00000000;
    DxgiFromHwnd   :: 0x00000001;
    DxgiFromVisual :: 0x00000002;
}

NativeDisplayHandleType :: enum s32 {
    None    :: 0x00000000;
    Xlib    :: 0x00000001;
    Xcb     :: 0x00000002;
    Wayland :: 0x00000003;
}

XlibDisplayHandle :: struct {
    display: *void;
    screen:  s32;
}

XcbDisplayHandle :: struct {
    connection: *void;
    screen:     s32;
}

WaylandDisplayHandle :: struct {
    display: *void;
}

NativeDisplayHandle :: struct {
    type: NativeDisplayHandleType;
    using data: union {
        xlib:    XlibDisplayHandle;
        xcb:     XcbDisplayHandle;
        wayland: WaylandDisplayHandle;
    };
}

InstanceExtras :: struct {
    using chain: ChainedStruct;
    backends:                InstanceBackendFlags;
    flags:                   InstanceFlags;
    dx12ShaderCompiler:      Dx12Compiler;
    gles3MinorVersion:       Gles3MinorVersion;
    glFenceBehaviour:        GLFenceBehaviour;
    dxcPath:                 StringView;
    dxcMaxShaderModel:       DxcMaxShaderModel;
    dx12PresentationSystem:  Dx12SwapchainKind;
    budgetForDeviceCreation: /* NULLABLE */ /* const */ *u8;
    budgetForDeviceLoss:     /* NULLABLE */ /* const */ *u8;
    displayHandle:           NativeDisplayHandle;
}

DeviceExtras :: struct {
    using chain: ChainedStruct;
    tracePath: StringView;
}

NativeLimits :: struct {
    using chain: ChainedStruct;
    maxNonSamplerBindings:                        u32;
    maxBindingArrayElementsPerShaderStage:        u32;
    maxBindingArraySamplerElementsPerShaderStage: u32;
    maxMultiviewViewCount:                        u32;
}

SubmissionIndex :: u64;

ShaderDefine :: struct {
    name:  StringView;
    value: StringView;
}

ShaderSourceGLSL :: struct {
    using chain: ChainedStruct;
    stage:       ShaderStage;
    code:        StringView;
    defineCount: u32;
    defines:     /* const */ *ShaderDefine;
}

ShaderModuleDescriptorSpirV :: struct {
    label:      StringView;
    sourceSize: u32;
    source:     /* const */ *u32;
}

RegistryReport :: struct {
    numAllocated:        u64;
    numKeptFromUser:     u64;
    numReleasedFromUser: u64;
    elementSize:         u64;
}

HubReport :: struct {
    adapters:         RegistryReport;
    devices:          RegistryReport;
    queues:           RegistryReport;
    pipelineLayouts:  RegistryReport;
    shaderModules:    RegistryReport;
    bindGroupLayouts: RegistryReport;
    bindGroups:       RegistryReport;
    commandBuffers:   RegistryReport;
    renderBundles:    RegistryReport;
    renderPipelines:  RegistryReport;
    computePipelines: RegistryReport;
    pipelineCaches:   RegistryReport;
    querySets:        RegistryReport;
    buffers:          RegistryReport;
    textures:         RegistryReport;
    textureViews:     RegistryReport;
    samplers:         RegistryReport;
}

GlobalReport :: struct {
    surfaces: RegistryReport;
    hub:      HubReport;
}

InstanceEnumerateAdapterOptions :: struct {
    nextInChain: /* const */ *ChainedStruct;
    backends:    InstanceBackendFlags;
}

BindGroupEntryExtras :: struct {
    using chain: ChainedStruct;
    buffers:          /* const */ *Buffer;
    bufferCount:      u64;
    samplers:         /* const */ *Sampler;
    samplerCount:     u64;
    textureViews:     /* const */ *TextureView;
    textureViewCount: u64;
}

BindGroupLayoutEntryExtras :: struct {
    using chain: ChainedStruct;
    count: u32;
}

QuerySetDescriptorExtras :: struct {
    using chain: ChainedStruct;
    pipelineStatistics:     /* const */ *PipelineStatisticName;
    pipelineStatisticCount: u64;
}

SurfaceConfigurationExtras :: struct {
    using chain: ChainedStruct;
    desiredMaximumFrameLatency: u32;
}

// Chained in `SurfaceDescriptor` to make a `Surface` wrapping a WinUI SwapChainPanel
// (https://learn.microsoft.com/en-us/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.swapchainpanel).
SurfaceSourceSwapChainPanel :: struct {
    using chain: ChainedStruct;
    /**
     * A pointer to the ISwapChainPanelNative
     * (https://learn.microsoft.com/en-us/windows/windows-app-sdk/api/win32/microsoft.ui.xaml.media.dxinterop/nn-microsoft-ui-xaml-media-dxinterop-iswapchainpanelnative)
     * interface of the `SwapChainPanel` that will be wrapped by the `Surface`.
     */
    panelNative: *void;
}

PolygonMode :: enum s32 {
    Fill  :: 0;
    Line  :: 1;
    Point :: 2;
}

PrimitiveStateExtras :: struct {
    using chain: ChainedStruct;
    polygonMode:  PolygonMode;
    conservative: Bool;
}

LogCallback :: #type (level: LogLevel, message: StringView, userdata: *void) #c_call;

ImageSubresourceRange :: struct {
    aspect:          TextureAspect;
    baseMipLevel:    u32;
    mipLevelCount:   u32;
    baseArrayLayer:  u32;
    arrayLayerCount: u32;
}

ShaderRuntimeCheck :: enum_flags u64 {
    None                            :: 0x0000000000000000;
    BoundsChecks                    :: 0x0000000000000001;
    ForceLoopBounding               :: 0x0000000000000002;
    RayQueryInitializationTracking  :: 0x0000000000000004;
    TaskShaderDispatchTracking      :: 0x0000000000000008;
    MeshShaderPrimitiveIndicesClamp :: 0x0000000000000010;
}
ShaderRuntimeChecks :: ShaderRuntimeCheck;

SamplerBorderColor :: enum s32 {
    Undefined        :: 0x00000000;
    TransparentBlack :: 0x00000001;
    OpaqueBlack      :: 0x00000002;
    OpaqueWhite      :: 0x00000003;
    Zero             :: 0x00000004;
}

SamplerDescriptorExtras :: struct {
    using chain: ChainedStruct;
    samplerBorderColor: SamplerBorderColor;
}

// Wrappers

// Jai splits the severity of a log message into 'Log_Flags' (ERROR, WARNING) and the
// verbosity into 'Log_Level' (NORMAL, VERBOSE, VERY_VERBOSE).

ConvertJaiToWGPULogLevel :: (flags: Log_Flags, level: Log_Level) -> LogLevel {
    if flags & .ERROR    return .Error;
    if flags & .WARNING  return .Warn;
    if level == {
        case .NORMAL;       return .Info;
        case .VERBOSE;      return .Debug;
        case;               return .Trace;
    }
}

ConvertWGPUToJaiLogLevel :: (level: LogLevel) -> flags: Log_Flags, level: Log_Level {
    if level == {
        case .Off;   #through;
        case .Trace; return .NONE,    .VERY_VERBOSE;
        case .Debug; return .NONE,    .VERBOSE;
        case .Info;  return .NONE,    .NORMAL;
        case .Warn;  return .WARNING, .NORMAL;
        case .Error; return .ERROR,   .NORMAL;
        case;        return .ERROR,   .NORMAL;
    }
}

ConvertLogLevel :: ConvertJaiToWGPULogLevel;
ConvertLogLevel :: ConvertWGPUToJaiLogLevel;
