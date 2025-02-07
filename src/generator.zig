// MIT License
//
// Copyright (c) 2025 raugl
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    const usage =
        \\ Usage: {s} <file>
        \\
        \\ Translate the structs and enums from a C header file into zig. Uses smarter types with better default values, and fixes casing. Intendet to be used only with wgpu-native headers.
        \\
        \\  --help               print this help message
        \\  --version            print program version
        \\
    ;

    const stdout_writer = std.io.getStdOut().writer();
    const writer = stdout_writer.any();

    if (args.len != 2) {
        try writer.print(usage, .{args[0]});
        std.process.exit(1);
    }
    if (std.mem.eql(u8, args[1], "--help")) {
        try writer.print(usage, .{args[0]});
        std.process.exit(0);
    }
    if (std.mem.eql(u8, args[1], "--version")) {
        try writer.writeAll("v0.0.1");
        std.process.exit(0);
    }

    const file = try std.fs.cwd().openFile(args[1], .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = std.ArrayList(u8).init(alloc);
    defer line.deinit();

    try writer.writeAll(
        \\pub const WGPUBool = enum(u32) {
        \\    false = 0,
        \\    true = 1,
        \\};
        \\
        \\
    );

    while (reader.streamUntilDelimiter(line.writer(), '\n', null)) {
        try translateC(line.items, writer);
        line.clearRetainingCapacity();
    } else |err| switch (err) {
        error.EndOfStream => if (line.items.len > 0) {
            try translateC(line.items, writer);
        },
        else => return err,
    }
}

const State = enum { start, @"enum", @"struct" };

var state: State = .start;
var type_name: []const u8 = undefined;
var prev_value: u32 = std.math.maxInt(u32) - 1;

const Substitution = struct {
    from: []const u8,
    to: []const u8,
};

fn translateC(line_: []const u8, writer: std.io.AnyWriter) !void {
    var line = line_;
    if (line.len == 0) return;

    switch (state) {
        .start => if (std.mem.startsWith(u8, line, "typedef enum ")) {
            line = line["typedef enum ".len..];
            const end = std.mem.indexOfScalar(u8, line, ' ').?;
            type_name = line[0..end];

            try writer.print("pub const {s} = enum(u32) {{\n", .{type_name[4..]});
            state = .@"enum";
        } else if (std.mem.startsWith(u8, line, "typedef struct ")) {
            line = line["typedef struct ".len..];
            const end = std.mem.indexOfScalar(u8, line, ' ').?;
            type_name = line[0..end];

            try writer.print("pub const {s} = extern struct {{\n", .{type_name[4..]});
            state = .@"struct";
        },
        .@"enum" => if (line[0] == '}') {
            try writer.writeAll("};\n\n");
            prev_value = std.math.maxInt(u32) - 1;
            state = .start;
        } else {
            line = std.mem.trim(u8, line, " \t");
            if (std.mem.startsWith(u8, line, "//")) {
                try writer.print("    {s}\n", .{line});
                return;
            }
            line = line[type_name.len + 1 ..];

            const end = std.mem.indexOfScalar(u8, line, ' ').?;
            const field_name = line[0..end];
            line = line[end..];

            const value = try std.fmt.parseInt(u32, line[5 .. line.len - 1], 16);
            defer prev_value = value;

            if (!std.mem.eql(u8, field_name, "Force32")) {
                try writer.writeAll("    ");
                try writeSnakeCase(field_name, writer);

                if (value != prev_value + 1) {
                    try writer.print(" = {}", .{value});
                }
                try writer.writeAll(",\n");
            }
        },
        .@"struct" => if (line[0] == '}') {
            try writer.writeAll("};\n\n");
            state = .start;
        } else {
            line = std.mem.trim(u8, line, " \t");
            line = line[0 .. line.len - 1];

            var is_nullable = std.mem.startsWith(u8, line, "WGPU_NULLABLE");
            if (is_nullable) line = line["WGPU_NULLABLE ".len..];

            if (std.mem.lastIndexOfScalar(u8, line, ' ')) |idx| {
                const field_name = line[idx + 1 ..];
                line = line[0..idx];

                if (std.mem.eql(u8, field_name, "next")) is_nullable = true;
                if (std.mem.eql(u8, field_name, "chain")) is_nullable = true;
                if (std.mem.eql(u8, field_name, "nextInChain")) is_nullable = true;

                try writer.writeAll("    ");
                for (field_name, 0..) |ch, i| {
                    if (std.ascii.isUpper(ch)) {
                        if (i > 0) try writer.writeByte('_');
                        try writer.writeByte(std.ascii.toLower(ch));
                    } else {
                        try writer.writeByte(ch);
                    }
                }
                try writer.writeAll(": ");
            }

            if (is_nullable) try writer.writeByte('?');
            if (std.mem.startsWith(u8, line, "struct ")) {
                line = line["struct ".len..];
            }

            if (std.mem.eql(u8, line, "char const *")) {
                try writer.writeAll("[*:0]const u8");
            } else blk: {
                while (std.mem.lastIndexOfScalar(u8, line, ' ')) |idx| {
                    const type_word = line[idx + 1 ..];
                    line = line[0..idx];
                    try writer.writeAll(type_word);
                    if (std.mem.eql(u8, type_word, "const")) try writer.writeByte(' ');
                }

                var type_word = line;
                for (type_substitutions) |sub| {
                    if (std.mem.eql(u8, type_word, sub.from)) {
                        try writer.writeAll(sub.to);
                        break :blk;
                    }
                }

                if (std.mem.startsWith(u8, type_word, "WGPU")) type_word = type_word[4..];
                try writer.writeAll(type_word);
            }

            if (is_nullable) try writer.writeAll(" = null");
            try writer.writeAll(",\n");
        },
    }
}

const type_substitutions = [_]Substitution{
    .{ .from = "void", .to = "anyopaque" },
    .{ .from = "uint64_t", .to = "u64" },
    .{ .from = "uint32_t", .to = "u32" },
    .{ .from = "uint16_t", .to = "u16" },
    .{ .from = "size_t", .to = "usize" },
    .{ .from = "float", .to = "f32" },
    .{ .from = "double", .to = "f64" },
    .{ .from = "WGPUBool", .to = "WGPUBool" },
};

const substitutions = [_]Substitution{
    .{ .from = "WebGPU", .to = "webgpu" },
    .{ .from = "WGSL", .to = "wgsl" },
    .{ .from = "SPIRV", .to = "spirv" },
    .{ .from = "RGBA", .to = "rgba" },
    .{ .from = "RGB", .to = "rgb" },
    .{ .from = "RG", .to = "rg" },
    .{ .from = "OpenGLES", .to = "opengles" },
    .{ .from = "OpenGL", .to = "opengl" },
    .{ .from = "HWND", .to = "hwnd" },
    .{ .from = "HTML", .to = "html" },
    .{ .from = "GPU", .to = "gpu" },
    .{ .from = "GL", .to = "gl" },
    .{ .from = "ETC2", .to = "etc2" },
    .{ .from = "EACRG", .to = "eacrg" },
    .{ .from = "EACR", .to = "eacr" },
    .{ .from = "DX1", .to = "dx1" },
    .{ .from = "D3D", .to = "d3d" },
    .{ .from = "CW", .to = "cw" },
    .{ .from = "CPU", .to = "cpu" },
    .{ .from = "CCW", .to = "ccw" },
    .{ .from = "BGRA", .to = "bgra" },
    .{ .from = "BC", .to = "bc" },
    .{ .from = "ASTC", .to = "astc" },
};

const whole_substitutions = [_]Substitution{
    .{ .from = "Opaque", .to = "@\"opaque\"" },
    .{ .from = "Error", .to = "@\"error\"" },
    .{ .from = "3D", .to = "@\"3d\"" },
    .{ .from = "2DArray", .to = "@\"2d_array\"" },
    .{ .from = "2D", .to = "@\"2d\"" },
    .{ .from = "1D", .to = "@\"1d\"" },
};

fn writeSnakeCase(name: []const u8, writer: std.io.AnyWriter) !void {
    for (whole_substitutions) |sub| {
        if (std.mem.eql(u8, name, sub.from)) {
            try writer.writeAll(sub.to);
            return;
        }
    }

    var i: usize = 0;
    outer: while (i < name.len) {
        for (substitutions) |sub| {
            if (sub.from.len + i <= name.len) {
                if (std.mem.eql(u8, sub.from, name[i..][0..sub.from.len])) {
                    if (i > 0) try writer.writeByte('_');
                    try writer.writeAll(sub.to);
                    i += sub.from.len;
                    continue :outer;
                }
            }
        }

        if (std.ascii.isUpper(name[i])) {
            if (i > 0) try writer.writeByte('_');
            try writer.writeByte(std.ascii.toLower(name[i]));
        } else {
            try writer.writeByte(name[i]);
        }
        i += 1;
    }
}
