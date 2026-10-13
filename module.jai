/*

wgpu-native bindings. This is a port of the Odin vendor package `vendor:wgpu` to Jai.

Native support is provided by the [wgpu-native](https://github.com/gfx-rs/wgpu-native) library.

Download them from the releases on GitHub: https://github.com/gfx-rs/wgpu-native/releases/tag/v29.0.1.1

The bindings are for v29.0.1.1 at the moment.

Libraries are expected in the `lib` folder under the same name as they are released (just unzipped), e.g.

    lib/wgpu-linux-x86_64-release/lib/libwgpu_native.a
    lib/wgpu-macos-aarch64-release/lib/libwgpu_native.a
    lib/wgpu-windows-x86_64-msvc-release/lib/wgpu_native.lib

By default it will look for a static release version (`wgpu-OS-ARCH-release`),
you can set the program parameter `WGPU_DEBUG = true` for it to look for a debug version,
and use `WGPU_SHARED = true` to link against the shared libraries.

Note: On Linux and macOS, Jai links the static library (`.a`) whenever it sits next to the shared one,
so to link dynamically you have to delete `libwgpu_native.a` from the `lib` folder (you will get a warning
otherwise). The release `.so`/`.dylib` has no install name/SONAME, so the executable references it by its absolute path.

*/

#module_parameters()(WGPU_SHARED := false, WGPU_DEBUG := false);

#load "wgpu.jai";
#load "wgpu_native_types.jai";
#load "wgpu_native.jai";

#scope_module

#import "Basic";

#if OS == .WINDOWS {
    #if CPU == .X64 {
        #if WGPU_DEBUG {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-windows-x86_64-msvc-debug/lib/wgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-windows-x86_64-msvc-debug/lib/wgpu_native";
        } else {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-windows-x86_64-msvc-release/lib/wgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-windows-x86_64-msvc-release/lib/wgpu_native";
        }

        LIB_PATH :: #run tprint("lib/wgpu-windows-x86_64-msvc-%/lib/wgpu_native%", LIB_TYPE, ifx WGPU_SHARED then ".dll" else ".lib");
    } else {
        #assert false "unsupported WGPU Native architecture";
    }

    d3dcompiler :: #library,system,link_always "d3dcompiler";
    ws2_32 :: #library,system,link_always "ws2_32";
    userenv :: #library,system,link_always "userenv";
    bcrypt :: #library,system,link_always "bcrypt";
    ntdll :: #library,system,link_always "ntdll";
    opengl32 :: #library,system,link_always "opengl32";
    advapi32 :: #library,system,link_always "advapi32";
    user32 :: #library,system,link_always "user32";
    gdi32 :: #library,system,link_always "gdi32";
    ole32 :: #library,system,link_always "ole32";
    oleaut32 :: #library,system,link_always "oleaut32";
    propsys :: #library,system,link_always "propsys";
    runtimeobject :: #library,system,link_always "runtimeobject";
} else #if OS == .MACOS {
    #if CPU == .X64 {
        #if WGPU_DEBUG {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-macos-x86_64-debug/lib/libwgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-macos-x86_64-debug/lib/libwgpu_native";
        } else {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-macos-x86_64-release/lib/libwgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-macos-x86_64-release/lib/libwgpu_native";
        }

        LIB_ARCH :: "x86_64";
    } else #if CPU == .ARM64 {
        #if WGPU_DEBUG {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-macos-aarch64-debug/lib/libwgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-macos-aarch64-debug/lib/libwgpu_native";
        } else {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-macos-aarch64-release/lib/libwgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-macos-aarch64-release/lib/libwgpu_native";
        }

        LIB_ARCH :: "aarch64";
    } else {
        #assert false "unsupported WGPU Native architecture";
    }

    LIB_PATH :: #run tprint("lib/wgpu-macos-%-%/lib/libwgpu_native%", LIB_ARCH, LIB_TYPE, ifx WGPU_SHARED then ".dylib" else ".a");

    Foundation :: #library,system,link_always "Foundation";
    CoreFoundation :: #library,system,link_always "CoreFoundation";
    QuartzCore :: #library,system,link_always "QuartzCore";
    Metal :: #library,system,link_always "Metal";
} else #if OS == .LINUX {
    #if CPU == .X64 {
        #if WGPU_DEBUG {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-linux-x86_64-debug/lib/libwgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-linux-x86_64-debug/lib/libwgpu_native";
        } else {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-linux-x86_64-release/lib/libwgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-linux-x86_64-release/lib/libwgpu_native";
        }

        LIB_ARCH :: "x86_64";
    } else #if CPU == .ARM64 {
        #if WGPU_DEBUG {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-linux-aarch64-debug/lib/libwgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-linux-aarch64-debug/lib/libwgpu_native";
        } else {
            #if WGPU_SHARED libwgpu :: #library,no_static_library "lib/wgpu-linux-aarch64-release/lib/libwgpu_native";
            else libwgpu :: #library,no_dll "lib/wgpu-linux-aarch64-release/lib/libwgpu_native";
        }

        LIB_ARCH :: "aarch64";
    } else {
        #assert false "unsupported WGPU Native architecture";
    }

    LIB_PATH :: #run tprint("lib/wgpu-linux-%-%/lib/libwgpu_native%", LIB_ARCH, LIB_TYPE, ifx WGPU_SHARED then ".so" else ".a");

    libdl :: #library,system,link_always "libdl";
    libm :: #library,system,link_always "libm";
    // The static Rust library needs the unwinder from libgcc_s.
    // Only the versioned name is guaranteed to exist on systems without gcc dev files installed.
    libgcc_s :: #library,system,link_always "libgcc_s.so.1";
} else {
    #assert false "unsupported OS for WGPU Native";
}

LIB_TYPE :: #run ifx WGPU_DEBUG then "debug" else "release";

#run {
    if !file_exists(tprint("%1%2", #filepath, LIB_PATH)) {
        compiler_report(tprint("Could not find the compiled WGPU Native library at '%1%2', these can be downloaded from https://github.com/gfx-rs/wgpu-native/releases/tag/v29.0.1.1, make sure to read the docs at '%1module.jai'", #filepath, LIB_PATH));
    }

    #if WGPU_SHARED && OS != .WINDOWS {
        static_path := tprint("%1%2.a", #filepath, path_strip_extension(LIB_PATH));
        if file_exists(static_path) {
            compiler_report(tprint("WGPU_SHARED is set, but the static library '%' exists next to the shared one. Jai links the static library whenever both are present, remove it to link dynamically.", static_path), mode = .WARNING);
        }
    }
}

#import "File_Utilities";
#import "String";
#import "Compiler";
