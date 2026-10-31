// Wgpu glue code for SDL3.
//
// Exports one procedure:
//
//     GetSurface :: (instance: Instance, window: *SDL_Window) -> Surface;
//
// Expects the SDL3 bindings to be available as module "sdl3" on the import path.
//
// Also reexports Wgpu, so please use this, otherwise there can be type mismatches due to uncanonicalized paths (compiler bug as of 2026-10-13)

wgpu :: #import "wgpu";

#if OS == .LINUX {
    #load "glue_linux.jai";
} else #if OS == .WINDOWS {
    #load "glue_windows.jai";
} else #if OS == .MACOS {
    #load "glue_darwin.jai";
} else {
    #assert false "module wgpu_sdl3 is not supported on the current target";
}

#scope_module

#import "Basic";
#import "sdl3";

// SDL3 has no SDL_GetWindowWMInfo anymore; native handles are window properties instead.
get_window_pointer_property :: (window: *SDL_Window, name: *u8) -> *void {
    pointer := SDL_GetPointerProperty(SDL_GetWindowProperties(window), name, null);
    if !pointer {
        glue_panic(tprint("wgpu sdl3 glue: window property '%' is not set: %", to_string(name), to_string(SDL_GetError())));
    }
    return pointer;
}

// Equivalent of Odin's 'panic': report like a failed assertion (with stack trace), then stop the program.
glue_panic :: (message: string, loc := #caller_location) {
    if assert_helper(message, loc = loc) debug_break();
    exit(1);
}
