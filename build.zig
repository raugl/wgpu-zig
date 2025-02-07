const std = @import("std");

// TODO: Add option for link mode
// TODO: Add step for generating translated C headers
// TODO: Get rid of the external dependency `system_sdk`

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const wgpu = b.addModule("root", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    { // Dependencies
        const os = @tagName(target.result.os.tag);
        const cpu = @tagName(target.result.cpu.arch);
        const mode = if (optimize == .Debug) "debug" else "release";

        var wgpu_name_buffer: [256]u8 = undefined;
        const wgpu_dep_name = try std.fmt.bufPrint(&wgpu_name_buffer, "wgpu-{s}-{s}-{s}", .{ os, cpu, mode });

        if (b.lazyDependency(wgpu_dep_name, .{})) |dep| {
            if (target.result.os.tag != .emscripten) {
                wgpu.linkSystemLibrary("wgpu_native", .{ .preferred_link_mode = .static });
                wgpu.addIncludePath(dep.path("include")); // FIXME
                wgpu.addLibraryPath(dep.path("lib"));
            }
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
    // { // Unit tests
    //     const unit_tests = b.addTest(.{
    //         .root_source_file = b.path("src/root.zig"),
    //         .target = target,
    //         .optimize = optimize,
    //     });
    //     const run_unit_tests = b.addRunArtifact(unit_tests);
    //     const test_step = b.step("test", "Run unit tests");
    //     test_step.dependOn(&run_unit_tests.step);
    // }
}
