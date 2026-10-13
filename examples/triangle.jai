WgpuSdl2 :: #import,dir "../WgpuSdl2";

Wgpu :: WgpuSdl2.Wgpu;

#import "SDL";
#import "Basic";


State :: struct {
    instance: Wgpu.Instance;
    surface: Wgpu.Surface;
    adapter: Wgpu.Adapter;
    device: Wgpu.Device;
    queue: Wgpu.Queue;
    config: Wgpu.SurfaceConfiguration;
    pipeline: Wgpu.RenderPipeline;
}


main :: () {
    SDL_Init(SDL_INIT_VIDEO);

    window_flags := SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE;
    #if OS == .MACOS window_flags |= SDL_WINDOW_METAL;

    window := SDL_CreateWindow("wgpu triangle",
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480,
        window_flags);

    if window == null {
        print("Could not create window: %\n", to_string(SDL_GetError()));
        return;
    }

    state: State;
    init_wgpu(*state, window);

    exit := false;
    while !exit {
        event: SDL_Event;
        while SDL_PollEvent(*event) {
            if event.type == {
                case SDL_QUIT;
                    exit = true;
                case SDL_KEYUP;
                    if event.key.keysym.sym == SDLK_ESCAPE exit = true;
                case SDL_WINDOWEVENT;
                    if event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED {
                        resize(*state, event.window.data1, event.window.data2);
                    }
            }
        }

        frame(*state, window);
    }

    deinit_wgpu(*state);

    SDL_DestroyWindow(window);
    SDL_Quit();
}

init_wgpu :: (state: *State, window: *SDL_Window) {

    state.instance = Wgpu.CreateInstance(null);
    if !state.instance fail("Could not create a wgpu instance.");

    state.surface = WgpuSdl2.GetSurface(state.instance, window);
    if !state.surface fail("Could not create a wgpu surface.");

    // Request an adapter. With .AllowProcessEvents the callback fires during InstanceProcessEvents.
    options := Wgpu.RequestAdapterOptions.{ compatibleSurface = state.surface };
    Wgpu.InstanceRequestAdapter(state.instance, *options, .{
        mode = .AllowProcessEvents,
        callback = on_adapter,
        userdata1 = state,
    });
    Wgpu.InstanceProcessEvents(state.instance);
    if !state.adapter fail("Could not get a wgpu adapter.");

    info, info_status := Wgpu.AdapterGetInfo(state.adapter);
    if info_status == .Success {
        print("Using % (%)\n", Wgpu.to_string(info.device), info.backendType);
        Wgpu.AdapterInfoFreeMembers(info);
    }

    // Request a device.
    device_descriptor := Wgpu.DeviceDescriptor.{
        uncapturedErrorCallbackInfo = .{ callback = on_uncaptured_error },
    };
    Wgpu.AdapterRequestDevice(state.adapter, *device_descriptor, .{
        mode = .AllowProcessEvents,
        callback = on_device,
        userdata1 = state,
    });
    Wgpu.InstanceProcessEvents(state.instance);
    if !state.device fail("Could not get a wgpu device.");

    state.queue = Wgpu.DeviceGetQueue(state.device);

    // Configure the surface.
    capabilities, caps_status := Wgpu.SurfaceGetCapabilities(state.surface, state.adapter);
    if caps_status != .Success || capabilities.formatCount == 0 fail("Could not get the surface capabilities.");

    width, height: s32;
    SDL_GetWindowSize(window, *width, *height);

    state.config = .{
        device = state.device,
        usage = .RenderAttachment,
        format = capabilities.formats[0],
        width = cast(u32) width,
        height = cast(u32) height,
        presentMode = .Fifo,
        alphaMode = capabilities.alphaModes[0],
    };
    Wgpu.SurfaceCapabilitiesFreeMembers(capabilities);
    Wgpu.SurfaceConfigure(state.surface, *state.config);

    // Create the pipeline.
    wgsl := Wgpu.ShaderSourceWGSL.{ sType = .ShaderSourceWGSL, code = Wgpu.to_string_view(SHADER) };
    module := Wgpu.DeviceCreateShaderModule(state.device, *(Wgpu.ShaderModuleDescriptor.{ nextInChain = *wgsl.chain }));
    defer Wgpu.ShaderModuleRelease(module);

    color_target := Wgpu.ColorTargetState.{
        format = state.config.format,
        writeMask = .All,
    };
    fragment := Wgpu.FragmentState.{
        module = module,
        entryPoint = Wgpu.to_string_view("fs_main"),
        targetCount = 1,
        targets = *color_target,
    };
    pipeline_descriptor := Wgpu.RenderPipelineDescriptor.{
        vertex = .{
            module = module,
            entryPoint = Wgpu.to_string_view("vs_main"),
        },
        primitive = .{
            topology = .TriangleList,
        },
        multisample = .{
            count = 1,
            mask = 0xFFFF_FFFF,
        },
        fragment = *fragment,
    };
    state.pipeline = Wgpu.DeviceCreateRenderPipeline(state.device, *pipeline_descriptor);
}

on_adapter :: (status: Wgpu.RequestAdapterStatus, adapter: Wgpu.Adapter, message: Wgpu.StringView, userdata1: *void, userdata2: *void) #c_call {
    push_context, defer_pop;
    if status != .Success {
        print("Request adapter failed (%): %\n", status, Wgpu.to_string(message));
        return;
    }
    (cast(*State) userdata1).adapter = adapter;
}

on_device :: (status: Wgpu.RequestDeviceStatus, device: Wgpu.Device, message: Wgpu.StringView, userdata1: *void, userdata2: *void) #c_call {
    push_context, defer_pop;
    if status != .Success {
        print("Request device failed (%): %\n", status, Wgpu.to_string(message));
        return;
    }
    (cast(*State) userdata1).device = device;
}

on_uncaptured_error :: (device: *Wgpu.Device, type: Wgpu.ErrorType, message: Wgpu.StringView, userdata1: *void, userdata2: *void) #c_call {
    push_context, defer_pop;
    print("wgpu error (%): %\n", type, Wgpu.to_string(message));
}

resize :: (state: *State, width: s32, height: s32) {
    if width <= 0 || height <= 0 return; // Minimized.

    state.config.width = cast(u32) width;
    state.config.height = cast(u32) height;
    Wgpu.SurfaceConfigure(state.surface, *state.config);
}

frame :: (state: *State, window: *SDL_Window) {
    surface_texture := Wgpu.SurfaceGetCurrentTexture(state.surface);
    if surface_texture.status == {
        case .SuccessOptimal; #through;
        case .SuccessSuboptimal;
        // All good, could handle suboptimal here.

        case .Timeout; #through;
        case .Outdated; #through;
        case .Lost;
            // Skip this frame, and re-configure the surface.
            if surface_texture.texture Wgpu.TextureRelease(surface_texture.texture);
            width, height: s32;
            SDL_GetWindowSize(window, *width, *height);
            resize(state, width, height);
            return;

        case .Occluded;
            SDL_Delay(16);
            return;

        case;
            fail(tprint("SurfaceGetCurrentTexture failed with status %", surface_texture.status));
    }
    defer Wgpu.TextureRelease(surface_texture.texture);

    view := Wgpu.TextureCreateView(surface_texture.texture);
    defer Wgpu.TextureViewRelease(view);

    encoder := Wgpu.DeviceCreateCommandEncoder(state.device);
    defer Wgpu.CommandEncoderRelease(encoder);

    color_attachment := Wgpu.RenderPassColorAttachment.{
        view = view,
        depthSlice = Wgpu.DEPTH_SLICE_UNDEFINED,
        loadOp = .Clear,
        storeOp = .Store,
        clearValue = .{ r = 0.1, g = 0.1, b = 0.12, a = 1 },
    };
    pass := Wgpu.CommandEncoderBeginRenderPass(encoder, *(Wgpu.RenderPassDescriptor.{
        colorAttachmentCount = 1,
        colorAttachments = *color_attachment,
    }));
    Wgpu.RenderPassEncoderSetPipeline(pass, state.pipeline);
    Wgpu.RenderPassEncoderDraw(pass, 3, 1, 0, 0);
    Wgpu.RenderPassEncoderEnd(pass);
    Wgpu.RenderPassEncoderRelease(pass);

    command_buffer := Wgpu.CommandEncoderFinish(encoder);
    defer Wgpu.CommandBufferRelease(command_buffer);

    Wgpu.QueueSubmit(state.queue, .[command_buffer]);
    Wgpu.SurfacePresent(state.surface);
}

deinit_wgpu :: (state: *State) {
    Wgpu.RenderPipelineRelease(state.pipeline);
    Wgpu.QueueRelease(state.queue);
    Wgpu.DeviceRelease(state.device);
    Wgpu.AdapterRelease(state.adapter);
    Wgpu.SurfaceRelease(state.surface);
    Wgpu.InstanceRelease(state.instance);
}

fail :: (message: string) {
    print("%\n", message);
    exit(1);
}

SHADER :: #string WGSL
struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) color: vec3<f32>,
};

@vertex
fn vs_main(@builtin(vertex_index) in_vertex_index: u32) -> VertexOutput {
    var positions = array<vec2<f32>, 3>(
        vec2<f32>( 0.0,  0.5),
        vec2<f32>(-0.5, -0.5),
        vec2<f32>( 0.5, -0.5),
    );
    var colors = array<vec3<f32>, 3>(
        vec3<f32>(1.0, 0.0, 0.0),
        vec3<f32>(0.0, 1.0, 0.0),
        vec3<f32>(0.0, 0.0, 1.0),
    );

    var out: VertexOutput;
    out.position = vec4<f32>(positions[in_vertex_index], 0.0, 1.0);
    out.color = colors[in_vertex_index];
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(in.color, 1.0);
}
WGSL

// Not declared by the SDL module.
SDL_WINDOW_METAL :: cast(SDL_WindowFlags) 0x20000000;
