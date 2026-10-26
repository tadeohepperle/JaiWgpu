wgpu_sdl2 :: #import "wgpu_sdl2";
wgpu :: #import "wgpu";

#import "SDL";
#import "Basic";


State :: struct {
    instance: wgpu.Instance;
    surface: wgpu.Surface;
    adapter: wgpu.Adapter;
    device: wgpu.Device;
    queue: wgpu.Queue;
    config: wgpu.SurfaceConfiguration;
    pipeline: wgpu.RenderPipeline;
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

    state.instance = wgpu.CreateInstance(null);
    if !state.instance fail("Could not create a wgpu instance.");

    state.surface = wgpu_sdl2.GetSurface(state.instance, window);
    if !state.surface fail("Could not create a wgpu surface.");

    // Request an adapter. With .AllowProcessEvents the callback fires during InstanceProcessEvents.
    options := wgpu.RequestAdapterOptions.{ compatibleSurface = state.surface };
    wgpu.InstanceRequestAdapter(state.instance, *options, .{
        mode = .AllowProcessEvents,
        callback = on_adapter,
        userdata1 = state,
    });
    wgpu.InstanceProcessEvents(state.instance);
    if !state.adapter fail("Could not get a wgpu adapter.");

    info, info_status := wgpu.AdapterGetInfo(state.adapter);
    if info_status == .Success {
        print("Using % (%)\n", wgpu.to_string(info.device), info.backendType);
        wgpu.AdapterInfoFreeMembers(info);
    }

    // Request a device.
    device_descriptor := wgpu.DeviceDescriptor.{
        uncapturedErrorCallbackInfo = .{ callback = on_uncaptured_error },
    };
    wgpu.AdapterRequestDevice(state.adapter, *device_descriptor, .{
        mode = .AllowProcessEvents,
        callback = on_device,
        userdata1 = state,
    });
    wgpu.InstanceProcessEvents(state.instance);
    if !state.device fail("Could not get a wgpu device.");

    state.queue = wgpu.DeviceGetQueue(state.device);

    // Configure the surface.
    capabilities, caps_status := wgpu.SurfaceGetCapabilities(state.surface, state.adapter);
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
    wgpu.SurfaceCapabilitiesFreeMembers(capabilities);
    wgpu.SurfaceConfigure(state.surface, *state.config);

    // Create the pipeline.
    wgsl := wgpu.ShaderSourceWGSL.{ sType = .ShaderSourceWGSL, code = wgpu.to_string_view(SHADER) };
    module := wgpu.DeviceCreateShaderModule(state.device, *(wgpu.ShaderModuleDescriptor.{ nextInChain = *wgsl.chain }));
    defer wgpu.ShaderModuleRelease(module);

    color_target := wgpu.ColorTargetState.{
        format = state.config.format,
        writeMask = .All,
    };
    fragment := wgpu.FragmentState.{
        module = module,
        entryPoint = wgpu.to_string_view("fs_main"),
        targetCount = 1,
        targets = *color_target,
    };
    pipeline_descriptor := wgpu.RenderPipelineDescriptor.{
        vertex = .{
            module = module,
            entryPoint = wgpu.to_string_view("vs_main"),
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
    state.pipeline = wgpu.DeviceCreateRenderPipeline(state.device, *pipeline_descriptor);
}

on_adapter :: (status: wgpu.RequestAdapterStatus, adapter: wgpu.Adapter, message: wgpu.StringView, userdata1: *void, userdata2: *void) #c_call {
    push_context, defer_pop;
    if status != .Success {
        print("Request adapter failed (%): %\n", status, wgpu.to_string(message));
        return;
    }
    (cast(*State) userdata1).adapter = adapter;
}

on_device :: (status: wgpu.RequestDeviceStatus, device: wgpu.Device, message: wgpu.StringView, userdata1: *void, userdata2: *void) #c_call {
    push_context, defer_pop;
    if status != .Success {
        print("Request device failed (%): %\n", status, wgpu.to_string(message));
        return;
    }
    (cast(*State) userdata1).device = device;
}

on_uncaptured_error :: (device: *wgpu.Device, type: wgpu.ErrorType, message: wgpu.StringView, userdata1: *void, userdata2: *void) #c_call {
    push_context, defer_pop;
    print("wgpu error (%): %\n", type, wgpu.to_string(message));
}

resize :: (state: *State, width: s32, height: s32) {
    if width <= 0 || height <= 0 return; // Minimized.

    state.config.width = cast(u32) width;
    state.config.height = cast(u32) height;
    wgpu.SurfaceConfigure(state.surface, *state.config);
}

frame :: (state: *State, window: *SDL_Window) {
    surface_texture := wgpu.SurfaceGetCurrentTexture(state.surface);
    if surface_texture.status == {
        case .SuccessOptimal; #through;
        case .SuccessSuboptimal;
        // All good, could handle suboptimal here.

        case .Timeout; #through;
        case .Outdated; #through;
        case .Lost;
            // Skip this frame, and re-configure the surface.
            if surface_texture.texture wgpu.TextureRelease(surface_texture.texture);
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
    defer wgpu.TextureRelease(surface_texture.texture);

    view := wgpu.TextureCreateView(surface_texture.texture);
    defer wgpu.TextureViewRelease(view);

    encoder := wgpu.DeviceCreateCommandEncoder(state.device);
    defer wgpu.CommandEncoderRelease(encoder);

    color_attachment := wgpu.RenderPassColorAttachment.{
        view = view,
        depthSlice = wgpu.DEPTH_SLICE_UNDEFINED,
        loadOp = .Clear,
        storeOp = .Store,
        clearValue = .{ r = 0.1, g = 0.1, b = 0.12, a = 1 },
    };
    pass := wgpu.CommandEncoderBeginRenderPass(encoder, *(wgpu.RenderPassDescriptor.{
        colorAttachmentCount = 1,
        colorAttachments = *color_attachment,
    }));
    wgpu.RenderPassEncoderSetPipeline(pass, state.pipeline);
    wgpu.RenderPassEncoderDraw(pass, 3, 1, 0, 0);
    wgpu.RenderPassEncoderEnd(pass);
    wgpu.RenderPassEncoderRelease(pass);

    command_buffer := wgpu.CommandEncoderFinish(encoder);
    defer wgpu.CommandBufferRelease(command_buffer);

    wgpu.QueueSubmit(state.queue, .[command_buffer]);
    wgpu.SurfacePresent(state.surface);
}

deinit_wgpu :: (state: *State) {
    wgpu.RenderPipelineRelease(state.pipeline);
    wgpu.QueueRelease(state.queue);
    wgpu.DeviceRelease(state.device);
    wgpu.AdapterRelease(state.adapter);
    wgpu.SurfaceRelease(state.surface);
    wgpu.InstanceRelease(state.instance);
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
