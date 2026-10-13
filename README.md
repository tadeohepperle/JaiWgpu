## Wgpu Bindings for the Jai Programming Language

Currently targets wgpu-native v29.0.1.1
Tested on linux with Jai Version: beta 0.2.030, built on 2 July 2026.

Heavily inspired by the Odin bindings to wgpu-native

Needs to have a `jai` compiler in your path. 
Copy the unzipped release from https://github.com/gfx-rs/wgpu-native/releases/tag/v29.0.1.1 into the lib directory. The lib directory should look like this:

```
.
├── examples
│   ├── triangle
│   └── triangle.jai
├── lib
│   └── wgpu-linux-x86_64-release
│       ├── include
│       │   └── webgpu
│       │       ├── webgpu.h
│       │       └── wgpu.h
│       ├── lib
│       │   ├── libwgpu_native.a
│       │   └── libwgpu_native.so
│       └── wgpu-native-meta
│           ├── webgpu.yml
│           └── wgpu-native-git-tag
├── module.jai
├── wgpu.jai
├── wgpu_native.jai
├── wgpu_native_types.jai
└── WgpuSdl2
    ├── glue_darwin.jai
    ├── glue_linux.jai
    ├── glue_windows.jai
    └── module.jai
```

# Example program

A simple program that just renders a triangle can be run like this:

```sh
jai examples/triangle.jai +Autorun
```
