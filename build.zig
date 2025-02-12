const std = @import("std");

// TODO: Add step for generating translated C headers
// TODO: Get rid of the external dependency `system_sdk`
// TODO: Fix include headers

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const shared = b.option(
        bool,
        "shared",
        "Link wgpu-native as a shared library (default: off)",
    ) orelse false;

    const wgpu = b.addModule("root", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    if (target.result.os.tag == .emscripten) return;

    { // Dependencies
        const wgpu_dep_name = b.fmt("wgpu-{s}-{s}-{s}", .{
            .os = @tagName(target.result.os.tag),
            .cpu = @tagName(target.result.cpu.arch),
            .mode = if (optimize == .Debug) "debug" else "release",
        });

        if (b.lazyDependency(wgpu_dep_name, .{})) |dep| {
            // const install_headers = b.addInstallHeaderFile(dep.path("include"), "");
            // b.getInstallStep().dependOn(&install_headers.step);

            wgpu.addLibraryPath(dep.path("lib"));
            wgpu.linkSystemLibrary("wgpu_native", .{
                .preferred_link_mode = if (shared) .dynamic else .static,
            });
        }
    }
    { // Link system deps
        switch (target.result.os.tag) {
            .windows => {
                if (b.lazyDependency("system_sdk", .{})) |system_sdk| {
                    wgpu.addLibraryPath(system_sdk.path("windows/lib/x86_64-windows-gnu"));
                }
                wgpu.linkSystemLibrary("ole32", .{});
                wgpu.linkSystemLibrary("dxguid", .{});
            },
            .macos => {
                if (b.lazyDependency("system_sdk", .{})) |system_sdk| {
                    wgpu.addLibraryPath(system_sdk.path("macos12/usr/lib"));
                    wgpu.addFrameworkPath(system_sdk.path("macos12/System/Library/Frameworks"));
                }
                wgpu.linkSystemLibrary("objc", .{});
                wgpu.linkFramework("Metal", .{});
                wgpu.linkFramework("CoreGraphics", .{});
                wgpu.linkFramework("Foundation", .{});
                wgpu.linkFramework("IOKit", .{});
                wgpu.linkFramework("IOSurface", .{});
                wgpu.linkFramework("QuartzCore", .{});
            },
            else => {},
        }
    }
}
