GetSurface :: (instance: wgpu.Instance, window: *SDL_Window) -> wgpu.Surface {
    source := wgpu.SurfaceSourceWindowsHWND.{
        sType = .SurfaceSourceWindowsHWND,
        hinstance = get_window_pointer_property(window, SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER),
        hwnd = get_window_pointer_property(window, SDL_PROP_WINDOW_WIN32_HWND_POINTER),
    };
    return wgpu.InstanceCreateSurface(instance, *(wgpu.SurfaceDescriptor.{ nextInChain = *source.chain }));
}
