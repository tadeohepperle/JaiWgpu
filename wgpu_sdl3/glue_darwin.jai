// Unlike the Odin glue for SDL2, which creates a CAMetalLayer through Objective-C and sets it on the NSWindow's
// content view, we let SDL create a Metal view and layer for us (like Odin's SDL3 glue does).
// For best results create the window with SDL_WINDOW_METAL.
//
// Note: as of writing, the sdl3 module itself only supports Windows and Linux, so this is untested.

GetSurface :: (instance: wgpu.Instance, window: *SDL_Window) -> wgpu.Surface {
    metal_view := SDL_Metal_CreateView(window);
    metal_layer := SDL_Metal_GetLayer(metal_view);
    if !metal_layer {
        glue_panic(tprint("wgpu sdl3 glue: could not create a Metal layer: %", to_string(SDL_GetError())));
    }

    source := wgpu.SurfaceSourceMetalLayer.{
        sType = .SurfaceSourceMetalLayer,
        layer = metal_layer,
    };
    return wgpu.InstanceCreateSurface(instance, *(wgpu.SurfaceDescriptor.{ nextInChain = *source.chain }));
}
