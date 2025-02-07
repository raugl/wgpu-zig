const std = @import("std");

// TODO: Test if `preferred_link_mode` has any effect
pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "webgpu",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib);
    lib.linkLibCpp();
    lib.linkLibC();

    const mod = b.addModule("root", .{
        .root_source_file = b.path("src/root.zig"),
    });

    { // Dependencies
        const os = @tagName(target.result.os.tag);
        const cpu = @tagName(target.result.cpu.arch);
        const mode = if (optimize == .Debug) "debug" else "release";

        var buffer: [256]u8 = undefined;
        const wgpu_dep_name = try std.fmt.bufPrint(&buffer, "wgpu-{s}-{s}-{s}", .{ os, cpu, mode });

        if (b.lazyDependency(wgpu_dep_name, .{})) |dep| {
            lib.addSystemIncludePath(dep.path(""));

            if (target.result.os.tag != .emscripten) {
                mod.addLibraryPath(dep.path(""));
                lib.addLibraryPath(dep.path(""));
                lib.linkSystemLibrary("wgpu_native", .{ .preferred_link_mode = .static });
            }
        }
    }
    { // Link system deps
        switch (target.result.os.tag) {
            .windows => {
                if (b.lazyDependency("system_sdk", .{})) |system_sdk| {
                    lib.addLibraryPath(system_sdk.path("windows/lib/x86_64-windows-gnu"));
                }
                lib.linkSystemLibrary("ole32", .{});
                lib.linkSystemLibrary("dxguid", .{});
            },
            .macos => {
                if (b.lazyDependency("system_sdk", .{})) |system_sdk| {
                    lib.addLibraryPath(system_sdk.path("macos12/usr/lib"));
                    lib.addFrameworkPath(system_sdk.path("macos12/System/Library/Frameworks"));
                }
                lib.linkSystemLibrary("objc", .{});
                lib.linkFramework("Metal", .{});
                lib.linkFramework("CoreGraphics", .{});
                lib.linkFramework("Foundation", .{});
                lib.linkFramework("IOKit", .{});
                lib.linkFramework("IOSurface", .{});
                lib.linkFramework("QuartzCore", .{});
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
