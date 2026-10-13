GetSurface :: (instance: Wgpu.Instance, window: *SDL_Window) -> Wgpu.Surface {
    window_info: SysWMinfo;
    if !GetWindowWMInfo(window, *window_info) {
        glue_panic(tprint("wgpu sdl2 glue: SDL_GetWindowWMInfo failed: %", to_string(SDL_GetError())));
    }

    hwnd := window_info.info.win.window;
    hinstance := GetModuleHandleW(null);

    source := Wgpu.SurfaceSourceWindowsHWND.{
        sType = .SurfaceSourceWindowsHWND,
        hinstance = cast(*void) hinstance,
        hwnd = hwnd,
    };
    return Wgpu.InstanceCreateSurface(instance, *(Wgpu.SurfaceDescriptor.{ nextInChain = *source.chain }));
}

#scope_file

#import "Windows";
