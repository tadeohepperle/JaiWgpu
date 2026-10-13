GetSurface :: (instance: Wgpu.Instance, window: *SDL_Window) -> Wgpu.Surface {
    window_info: SysWMinfo;
    if !GetWindowWMInfo(window, *window_info) {
        glue_panic(tprint("wgpu sdl2 glue: SDL_GetWindowWMInfo failed: %", to_string(SDL_GetError())));
    }

    if window_info.subsystem == .WAYLAND {
        source := Wgpu.SurfaceSourceWaylandSurface.{
            sType = .SurfaceSourceWaylandSurface,
            display = window_info.info.wl.display,
            surface = window_info.info.wl.surface,
        };
        return Wgpu.InstanceCreateSurface(instance, *(Wgpu.SurfaceDescriptor.{ nextInChain = *source.chain }));
    } else if window_info.subsystem == .X11 {
        source := Wgpu.SurfaceSourceXlibWindow.{
            sType = .SurfaceSourceXlibWindow,
            display = window_info.info.x11.display,
            window = window_info.info.x11.window,
        };
        return Wgpu.InstanceCreateSurface(instance, *(Wgpu.SurfaceDescriptor.{ nextInChain = *source.chain }));
    } else {
        glue_panic("wgpu sdl2 glue: unsupported platform, expected Wayland or X11");
        return null;
    }
}
