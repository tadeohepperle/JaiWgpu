// Unlike the Odin glue, which creates a CAMetalLayer through Objective-C and sets it on the NSWindow's content view,
// we let SDL (>= 2.0.12) create a Metal view and layer for us, so we don't need an Objective-C runtime binding.
// For best results create the window with SDL_WINDOW_METAL.

GetSurface :: (instance: Wgpu.Instance, window: *SDL_Window) -> Wgpu.Surface {
    metal_view := SDL_Metal_CreateView(window);
    metal_layer := SDL_Metal_GetLayer(metal_view);
    if !metal_layer {
        glue_panic(tprint("wgpu sdl2 glue: could not create a Metal layer: %", to_string(SDL_GetError())));
    }

    source := Wgpu.SurfaceSourceMetalLayer.{
        sType = .SurfaceSourceMetalLayer,
        layer = metal_layer,
    };
    return Wgpu.InstanceCreateSurface(instance, *(Wgpu.SurfaceDescriptor.{ nextInChain = *source.chain }));
}

#scope_file

SDL_MetalView :: *void;

SDL_Metal_CreateView :: (window: *SDL_Window) -> SDL_MetalView #foreign SDL2;
SDL_Metal_GetLayer :: (view: SDL_MetalView) -> *void #foreign SDL2;
