GetSurface :: (instance: wgpu.Instance, window: *SDL_Window) -> wgpu.Surface {
    video_driver := to_string(SDL_GetCurrentVideoDriver());

    if video_driver == "wayland" {
        source := wgpu.SurfaceSourceWaylandSurface.{
            sType = .SurfaceSourceWaylandSurface,
            display = get_window_pointer_property(window, SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER),
            surface = get_window_pointer_property(window, SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER),
        };
        return wgpu.InstanceCreateSurface(instance, *(wgpu.SurfaceDescriptor.{ nextInChain = *source.chain }));
    } else if video_driver == "x11" {
        x11_window := SDL_GetNumberProperty(SDL_GetWindowProperties(window), SDL_PROP_WINDOW_X11_WINDOW_NUMBER, 0);
        if !x11_window {
            glue_panic(tprint("wgpu sdl3 glue: window has no X11 window: %", to_string(SDL_GetError())));
        }

        source := wgpu.SurfaceSourceXlibWindow.{
            sType = .SurfaceSourceXlibWindow,
            display = get_window_pointer_property(window, SDL_PROP_WINDOW_X11_DISPLAY_POINTER),
            window = cast(u64) x11_window,
        };
        return wgpu.InstanceCreateSurface(instance, *(wgpu.SurfaceDescriptor.{ nextInChain = *source.chain }));
    } else {
        glue_panic(tprint("wgpu sdl3 glue: unsupported video driver '%', expected Wayland or X11", video_driver));
        return null;
    }
}
