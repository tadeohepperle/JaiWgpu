// Wgpu glue code for SDL2.
//
// Exports one procedure:
//
//     GetSurface :: (instance: Instance, window: *SDL_Window) -> Surface;
//
// Also reexports Wgpu, so please use this, otherwise there can be type mismatches due to uncanonicalized paths (compiler bug as of 2026-10-13)

Wgpu :: #import,dir "..";

#if OS == .LINUX {
    #load "glue_linux.jai";
} else #if OS == .WINDOWS {
    #load "glue_windows.jai";
} else #if OS == .MACOS {
    #load "glue_darwin.jai";
} else {
    #assert false "module wgpu/sdl2glue is not supported on the current target";
}

#scope_module

#import "Basic";
#import "SDL";

// The SDL module's SDL_SysWMinfo is incomplete: it lacks Wayland, and its union is smaller than the 64 bytes
// SDL may write into. This is the complete definition from SDL_syswm.h.

SYSWM_TYPE :: enum s32 {
    UNKNOWN :: 0;
    WINDOWS :: 1;
    X11 :: 2;
    DIRECTFB :: 3;
    COCOA :: 4;
    UIKIT :: 5;
    WAYLAND :: 6;
    MIR :: 7; // no longer available, left for API/ABI compatibility.
    WINRT :: 8;
    ANDROID :: 9;
    VIVANTE :: 10;
    OS2 :: 11;
    HAIKU :: 12;
    KMSDRM :: 13;
    RISCOS :: 14;
}

SysWMinfo :: struct {
    version: SDL_version;
    subsystem: SYSWM_TYPE;
    info: union {
        win: struct {
            window: *void; // HWND
            hdc: *void; // HDC
            hinstance: *void; // HINSTANCE
        };
        x11: struct {
            display: *void; // *Display
            window: u64; // Window
        };
        cocoa: struct {
            window: *void; // *NSWindow
        };
        wl: struct {
            display: *void; // *wl_display
            surface: *void; // *wl_surface
            shell_surface: *void; // deprecated
            egl_window: *void;
            xdg_surface: *void;
            xdg_toplevel: *void;
            xdg_popup: *void;
            xdg_positioner: *void;
        };
        dummy: [64] u8;
    };
}

#assert size_of(SysWMinfo) == 72;

GetWindowWMInfo :: (window: *SDL_Window, info: *SysWMinfo) -> bool {
    // Equivalent of the SDL_VERSION macro. We use the version of the linked library, since the SDL module
    // declares a very old header version, and SDL only fills in the fields that the given version knows about.
    SDL_GetVersion(*info.version);
    return SDL_GetWindowWMInfo(window, cast(*SDL_SysWMinfo) info) == SDL_TRUE;
}

// Equivalent of Odin's 'panic': report like a failed assertion (with stack trace), then stop the program.
glue_panic :: (message: string, loc := #caller_location) {
    if assert_helper(message, loc = loc) debug_break();
    exit(1);
}
