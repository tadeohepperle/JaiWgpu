GetSurface :: (instance: wgpu.Instance, window: *SDL_Window) -> wgpu.Surface {
    window_info: SysWMinfo;
    if !GetWindowWMInfo(window, *window_info) {
        glue_panic(tprint("wgpu sdl2 glue: SDL_GetWindowWMInfo failed: %", to_string(SDL_GetError())));
    }

    hwnd := window_info.info.win.window;
    hinstance := GetModuleHandleW(null);

    source := wgpu.SurfaceSourceWindowsHWND.{
        sType = .SurfaceSourceWindowsHWND,
        hinstance = cast(*void) hinstance,
        hwnd = hwnd,
    };
    return wgpu.InstanceCreateSurface(instance, *(wgpu.SurfaceDescriptor.{ nextInChain = *source.chain }));
}

#scope_file

#import "Windows";
