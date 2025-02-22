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

// TODO: ZLS doesn't work well with the current methods API. I should first add method wrappers for
// all wgpu functions, even the ones that are exactly the same as the C ones, then alias them as free funciton.
// TODO: Add wrapper structs that use slices and optionals instead of C pointers
// TODO: Add default values
// TODO: I think emscripten has different values for enums, maybe even different structs
// TODO: wasm and cross compilation support

const std = @import("std");
const wgpu = @This();
const Allocator = std.mem.Allocator;

test {
    _ = std.testing.refAllDeclsRecursive(@This());
}

pub const array_layer_count_undefined = 0xffffffff;
pub const copy_stride_undefined = 0xffffffff;
pub const depth_slice_undefined = 0xffffffff;
pub const limit_u32_undefined = 0xffffffff;
pub const limit_u64_undefined = 0xffffffffffffffff;
pub const mip_level_count_undefined = 0xffffffff;
pub const query_set_index_undefined = 0xffffffff;
pub const whole_map_size = std.math.maxInt(usize);
pub const whole_size = 0xffffffffffffffff;

pub const Bool = enum(u32) {
    false = 0,
    true = 1,
};

pub const AdapterType = enum(u32) {
    discrete_gpu = 0,
    integrated_gpu,
    cpu,
    unknown,
};

pub const AddressMode = enum(u32) {
    repeat = 0,
    mirror_repeat,
    clamp_to_edge,
};

pub const BackendType = enum(u32) {
    undefined = 0,
    null,
    webgpu,
    d3d11,
    d3d12,
    metal,
    vulkan,
    opengl,
    opengles,
};

pub const BlendFactor = enum(u32) {
    zero = 0,
    one,
    src,
    one_minus_src,
    src_alpha,
    one_minus_src_alpha,
    dst,
    one_minus_dst,
    dst_alpha,
    one_minus_dst_alpha,
    src_alpha_saturated,
    constant,
    one_minus_constant,
};

pub const BlendOperation = enum(u32) {
    add = 0,
    subtract,
    reverse_subtract,
    min,
    max,
};

pub const BufferBindingType = enum(u32) {
    undefined = 0,
    uniform,
    storage,
    read_only_storage,
};

pub const BufferMapAsyncStatus = enum(u32) {
    success = 0,
    validation_error,
    unknown,
    device_lost,
    destroyed_before_callback,
    unmapped_before_callback,
    mapping_already_pending,
    offset_out_of_range,
    size_out_of_range,
};

pub const BufferMapState = enum(u32) {
    unmapped = 0,
    pending,
    mapped,
};

pub const CompareFunction = enum(u32) {
    undefined = 0,
    never,
    less,
    less_equal,
    greater,
    greater_equal,
    equal,
    not_equal,
    always,
};

pub const CompilationInfoRequestStatus = enum(u32) {
    success = 0,
    @"error",
    device_lost,
    unknown,
};

pub const CompilationMessageType = enum(u32) {
    @"error" = 0,
    warning,
    info,
};

pub const CompositeAlphaMode = enum(u32) {
    auto = 0,
    @"opaque",
    premultiplied,
    unpremultiplied,
    inherit,
};

pub const CreatePipelineAsyncStatus = enum(u32) {
    success = 0,
    validation_error,
    internal_error,
    device_lost,
    device_destroyed,
    unknown,
};

pub const CullMode = enum(u32) {
    none = 0,
    front,
    back,
};

pub const DeviceLostReason = enum(u32) {
    unknown = 1,
    destroyed,
};

pub const ErrorFilter = enum(u32) {
    validation = 0,
    out_of_memory,
    internal,
};

pub const ErrorType = enum(u32) {
    no_error = 0,
    validation,
    out_of_memory,
    internal,
    unknown,
    device_lost,
};

pub const FeatureName = enum(u32) {
    undefined = 0,
    depth_clip_control,
    depth32_float_stencil8,
    timestamp_query,
    texture_compression_bc,
    texture_compression_etc2,
    texture_compression_astc,
    indirect_first_instance,
    shader_f16,
    rg11_b10_ufloat_renderable,
    bgra8_unorm_storage,
    float32_filterable,

    // wgpu-native extras (wgpu.h)
    push_constants = 0x30001,
    texture_adapter_specific_format_features = 0x30002,
    multi_draw_indirect = 0x30003,
    multi_draw_indirect_count = 0x30004,
    vertex_writable_storage = 0x30005,
    texture_binding_array = 0x30006,
    sampled_texture_and_storage_buffer_array_non_uniform_indexing = 0x30007,
    pipeline_statistics_query = 0x30008,
    storage_resource_binding_array = 0x30009,
    partially_bound_binding_array = 0x3000a,
    texture_format16bit_norm = 0x3000b,
    texture_compression_astc_hdr = 0x3000c,
    // TODO: requires wgpu.h api change
    // timestamp_query_inside_passes = 0x3000d,
    mappable_primary_buffers = 0x3000e,
    buffer_binding_array = 0x3000f,
    uniform_buffer_and_storage_texture_array_non_uniform_indexing = 0x30010,
    // TODO: requires wgpu.h api change
    // address_mode_clamp_to_zero = 0x30011,
    // address_mode_clamp_to_border = 0x30012,
    // polygon_mode_line = 0x30013,
    // polygon_mode_point = 0x30014,
    // conservative_rasterization = 0x30015,
    // clear_texture = 0x30016,
    // spirv_shader_passthrough = 0x30017,
    // multiview = 0x30018,
    vertex_attribute64bit = 0x30019,
    texture_format_nv12 = 0x3001a,
    ray_tracing_acceleration_structure = 0x3001b,
    ray_query = 0x3001c,
    shader_f64 = 0x3001d,
    shader_i16 = 0x3001e,
    shader_primitive_index = 0x3001f,
    shader_early_depth_test = 0x30020,
};

pub const FilterMode = enum(u32) {
    nearest = 0,
    linear,
};

pub const FrontFace = enum(u32) {
    ccw = 0,
    cw,
};

pub const IndexFormat = enum(u32) {
    undefined = 0,
    uint16,
    uint32,
};

pub const LoadOp = enum(u32) {
    undefined = 0,
    clear,
    load,
};

pub const MipmapFilterMode = enum(u32) {
    nearest = 0,
    linear,
};

pub const PowerPreference = enum(u32) {
    undefined = 0,
    low_power,
    high_performance,
};

pub const PresentMode = enum(u32) {
    fifo = 0,
    fifo_relaxed,
    immediate,
    mailbox,
};

pub const PrimitiveTopology = enum(u32) {
    point_list = 0,
    line_list,
    line_strip,
    triangle_list,
    triangle_strip,
};

pub const QueryType = enum(u32) {
    occlusion = 0,
    timestamp,
    pipeline_statistics = 0x30000,
};

pub const QueueWorkDoneStatus = enum(u32) {
    success = 0,
    @"error",
    unknown,
    device_lost,
};

pub const RequestAdapterStatus = enum(u32) {
    success = 0,
    unavailable,
    @"error",
    unknown,
};

pub const RequestDeviceStatus = enum(u32) {
    success = 0,
    @"error",
    unknown,
};

pub const SType = enum(u32) {
    invalid = 0,
    surface_descriptor_from_metal_layer,
    surface_descriptor_from_windows_hwnd,
    surface_descriptor_from_xlib_window,
    surface_descriptor_from_canvas_html_selector,
    shader_module_spirv_descriptor,
    shader_module_wgsl_descriptor,
    primitive_depth_clip_control,
    surface_descriptor_from_wayland_surface,
    surface_descriptor_from_android_native_window,
    surface_descriptor_from_xcb_window,
    render_pass_descriptor_max_draw_count = 15,

    // Start at 0x30000 since that's allocated range for wgpu-native
    // wgpu-native extras (wgpu.h)
    device_extras = 0x30001,
    required_limits_extras = 0x30002,
    pipeline_layout_extras = 0x30003,
    shader_module_glsl_descriptor = 0x30004,
    supported_limits_extras = 0x30005,
    instance_extras = 0x30006,
    bind_group_entry_extras = 0x30007,
    bind_group_layout_entry_extras = 0x30008,
    query_set_descriptor_extras = 0x30009,
    surface_configuration_extras = 0x3000a,
};

pub const SamplerBindingType = enum(u32) {
    undefined = 0,
    filtering,
    non_filtering,
    comparison,
};

pub const StencilOperation = enum(u32) {
    keep = 0,
    zero,
    replace,
    invert,
    increment_clamp,
    decrement_clamp,
    increment_wrap,
    decrement_wrap,
};

pub const StorageTextureAccess = enum(u32) {
    undefined = 0,
    write_only,
    read_only,
    read_write,
};

pub const StoreOp = enum(u32) {
    undefined = 0,
    store,
    discard,
};

pub const SurfaceGetCurrentTextureStatus = enum(u32) {
    success = 0,
    timeout,
    outdated,
    lost,
    out_of_memory,
    device_lost,
};

pub const TextureAspect = enum(u32) {
    all = 0,
    stencil_only,
    depth_only,
};

pub const TextureDimension = enum(u32) {
    @"1d" = 0,
    @"2d",
    @"3d",
};

pub const TextureFormat = enum(u32) {
    undefined = 0,
    r8_unorm,
    r8_snorm,
    r8_uint,
    r8_sint,
    r16_uint,
    r16_sint,
    r16_float,
    rg8_unorm,
    rg8_snorm,
    rg8_uint,
    rg8_sint,
    r32_float,
    r32_uint,
    r32_sint,
    rg16_uint,
    rg16_sint,
    rg16_float,
    rgba8_unorm,
    rgba8_unorm_srgb,
    rgba8_snorm,
    rgba8_uint,
    rgba8_sint,
    bgra8_unorm,
    bgra8_unorm_srgb,
    rgb10_a2_uint,
    rgb10_a2_unorm,
    rg11_b10_ufloat,
    rgb9_e5_ufloat,
    rg32_float,
    rg32_uint,
    rg32_sint,
    rgba16_uint,
    rgba16_sint,
    rgba16_float,
    rgba32_float,
    rgba32_uint,
    rgba32_sint,
    stencil8,
    depth16_unorm,
    depth24_plus,
    depth24_plus_stencil8,
    depth32_float,
    depth32_float_stencil8,
    bc1_rgba_unorm,
    bc1_rgba_unorm_srgb,
    bc2_rgba_unorm,
    bc2_rgba_unorm_srgb,
    bc3_rgba_unorm,
    bc3_rgba_unorm_srgb,
    bc4_r_unorm,
    bc4_r_snorm,
    bc5_rg_unorm,
    bc5_rg_snorm,
    bc6_hrgb_ufloat,
    bc6_hrgb_float,
    bc7_rgba_unorm,
    bc7_rgba_unorm_srgb,
    etc2_rgb8_unorm,
    etc2_rgb8_unorm_srgb,
    etc2_rgb8_a1_unorm,
    etc2_rgb8_a1_unorm_srgb,
    etc2_rgba8_unorm,
    etc2_rgba8_unorm_srgb,
    eacr11_unorm,
    eacr11_snorm,
    eacrg11_unorm,
    eacrg11_snorm,
    astc4x4_unorm,
    astc4x4_unorm_srgb,
    astc5x4_unorm,
    astc5x4_unorm_srgb,
    astc5x5_unorm,
    astc5x5_unorm_srgb,
    astc6x5_unorm,
    astc6x5_unorm_srgb,
    astc6x6_unorm,
    astc6x6_unorm_srgb,
    astc8x5_unorm,
    astc8x5_unorm_srgb,
    astc8x6_unorm,
    astc8x6_unorm_srgb,
    astc8x8_unorm,
    astc8x8_unorm_srgb,
    astc10x5_unorm,
    astc10x5_unorm_srgb,
    astc10x6_unorm,
    astc10x6_unorm_srgb,
    astc10x8_unorm,
    astc10x8_unorm_srgb,
    astc10x10_unorm,
    astc10x10_unorm_srgb,
    astc12x10_unorm,
    astc12x10_unorm_srgb,
    astc12x12_unorm,
    astc12x12_unorm_srgb,

    // wgpu-native extras (wgpu.h)
    r16_unorm = 0x30001, // From FEATURES::TEXTURE_FORMAT_16BIT_NORM
    r16_snorm,
    rg16_unorm,
    rg16_snorm,
    rgba16_unorm,
    rgba16_snorm,
    nv12, // From FEATURES::TEXTURE_FORMAT_NV12
};

pub const TextureSampleType = enum(u32) {
    undefined = 0,
    float,
    unfilterable_float,
    depth,
    sint,
    uint,
};

pub const TextureViewDimension = enum(u32) {
    undefined = 0,
    @"1d",
    @"2d",
    @"2d_array",
    cube,
    cube_array,
    @"3d",
};

pub const VertexFormat = enum(u32) {
    undefined = 0,
    uint8x2,
    uint8x4,
    sint8x2,
    sint8x4,
    unorm8x2,
    unorm8x4,
    snorm8x2,
    snorm8x4,
    uint16x2,
    uint16x4,
    sint16x2,
    sint16x4,
    unorm16x2,
    unorm16x4,
    snorm16x2,
    snorm16x4,
    float16x2,
    float16x4,
    float32,
    float32x2,
    float32x3,
    float32x4,
    uint32,
    uint32x2,
    uint32x3,
    uint32x4,
    sint32,
    sint32x2,
    sint32x3,
    sint32x4,
};

pub const VertexStepMode = enum(u32) {
    vertex = 0,
    instance,
    vertex_buffer_not_used,
};

pub const WGSLFeatureName = enum(u32) {
    undefined = 0,
    readonly_and_readwrite_storage_textures,
    packed4x8integer_dot_product,
    unrestricted_pointer_parameters,
    pointer_composite_access,
};

pub const BufferUsageFlags = packed struct(u32) {
    pub const none = BufferUsageFlags{};

    map_read: bool = false,
    map_write: bool = false,
    copy_src: bool = false,
    copy_dst: bool = false,
    index: bool = false,
    vertex: bool = false,
    uniform: bool = false,
    storage: bool = false,
    indirect: bool = false,
    query_resolve: bool = false,
    _padding: u22 = 0,
};

pub const ColorWriteMaskFlags = packed struct(u32) {
    pub const none = ColorWriteMaskFlags{};
    pub const all = ColorWriteMaskFlags{ .red = true, .green = true, .blue = true, .alpha = true };

    red: bool = false,
    green: bool = false,
    blue: bool = false,
    alpha: bool = false,
    _padding: u28 = 0,
};

pub const MapModeFlags = packed struct(u32) {
    pub const none = MapModeFlags{};

    read: bool = false,
    write: bool = false,
    _padding: u30 = 0,
};

pub const ShaderStageFlags = packed struct(u32) {
    pub const none = ShaderStageFlags{};

    vertex: bool = false,
    fragment: bool = false,
    compute: bool = false,
    _padding: u29 = 0,
};

pub const TextureUsageFlags = packed struct(u32) {
    pub const none = @This(){};

    copy_src: bool = false,
    copy_dst: bool = false,
    texture_binding: bool = false,
    storage_binding: bool = false,
    render_attachment: bool = false,
    _padding: u27 = 0,
};

pub const BufferMapAsyncCallback = *const fn (
    status: BufferMapAsyncStatus,
    userdata: ?*anyopaque,
) callconv(.C) void;

pub const ShaderModuleGetCompilationInfoCallback = *const fn (
    status: CompilationInfoRequestStatus,
    compilation_info: *const CompilationInfo,
    userdata: ?*anyopaque,
) callconv(.C) void;

pub const DeviceCreateComputePipelineAsyncCallback = *const fn (
    status: CreatePipelineAsyncStatus,
    pipeline: ComputePipeline,
    messaeg: [*:0]const u8,
    userdata: ?*anyopaque,
) callconv(.C) void;

pub const DeviceCreateRenderPipelineAsyncCallback = *const fn (
    status: CreatePipelineAsyncStatus,
    pipeline: RenderPipeline,
    message: [*:0]const u8,
    userdata: ?*anyopaque,
) callconv(.C) void;

pub const DeviceLostCallback = *const fn (
    reason: DeviceLostReason,
    message: [*:0]const u8,
    userdata: ?*anyopaque,
) callconv(.C) void;

pub const ErrorCallback = *const fn (
    type: ErrorType,
    message: [*:0]const u8,
    userdata: ?*anyopaque,
) callconv(.C) void;

pub const Proc = *const fn () callconv(.C) void;

pub const QueueOnSubmittedWorkDoneCallback = *const fn (
    status: QueueWorkDoneStatus,
    ?*anyopaque,
) callconv(.C) void;

pub const InstanceRequestAdapterCallback = *const fn (
    status: RequestAdapterStatus,
    adapter: Adapter,
    message: [*:0]const u8,
    userata: ?*anyopaque,
) callconv(.C) void;

pub const AdapterRequestDeviceCallback = *const fn (
    status: RequestDeviceStatus,
    device: Device,
    message: [*:0]const u8,
    userdata: ?*anyopaque,
) callconv(.C) void;

pub const ChainedStruct = extern struct {
    next: ?*const ChainedStruct = null,
    s_type: SType,
};

pub const ChainedStructOut = extern struct {
    next: ?*ChainedStructOut = null,
    s_type: SType,
};

pub const AdapterInfo = extern struct {
    next_in_chain: ?*ChainedStructOut = null,
    vendor: [*:0]const u8 = undefined,
    architecture: [*:0]const u8 = undefined,
    device: [*:0]const u8 = undefined,
    description: [*:0]const u8 = undefined,
    backend_type: BackendType = .undefined,
    adapter_type: AdapterType = .unknown,
    vendor_id: u32 = 0,
    device_id: u32 = 0,

    pub const freeMembers = wgpu.adapterInfoFreeMembers;
};

pub const BindGroupEntry = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    binding: u32,
    buffer: ?Buffer = null,
    offset: u64,
    size: u64,
    sampler: ?Sampler = null,
    texture_view: ?TextureView = null,
};

pub const BlendComponent = extern struct {
    operation: BlendOperation,
    src_factor: BlendFactor,
    dst_factor: BlendFactor,
};

pub const BufferBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    type: BufferBindingType,
    has_dynamic_offset: Bool,
    min_binding_size: u64,
};

pub const BufferDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    usage: BufferUsageFlags,
    size: u64,
    mapped_at_creation: Bool,
};

pub const Color = extern struct {
    r: f64 = 0,
    g: f64 = 0,
    b: f64 = 0,
    a: f64 = 1,
};

pub fn color(r: f64, g: f64, b: f64, a: f64) Color {
    return Color{ .r = r, .g = g, .b = b, .a = a };
}

pub const CommandBufferDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const CommandEncoderDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const CompilationMessage = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    message: ?[*:0]const u8 = null,
    type: CompilationMessageType,
    line_num: u64,
    line_pos: u64,
    offset: u64,
    length: u64,
    utf16_line_pos: u64,
    utf16_offset: u64,
    utf16_length: u64,
};

pub const ComputePassTimestampWrites = extern struct {
    query_set: QuerySet,
    beginning_of_pass_write_index: u32,
    end_of_pass_write_index: u32,
};

pub const ConstantEntry = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    key: [*:0]const u8,
    value: f64,
};

pub const Extent3D = extern struct {
    width: u32,
    height: u32,
    depth_or_array_layers: u32,
};

pub const InstanceDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
};

pub const Limits = extern struct {
    max_texture_dimension_1d: u32 = limit_u32_undefined,
    max_texture_dimension_2d: u32 = limit_u32_undefined,
    max_texture_dimension_3d: u32 = limit_u32_undefined,
    max_texture_array_layers: u32 = limit_u32_undefined,
    max_bind_groups: u32 = limit_u32_undefined,
    max_bind_groups_plus_vertex_buffers: u32 = limit_u32_undefined,
    max_bindings_per_bind_group: u32 = limit_u32_undefined,
    max_dynamic_uniform_buffers_per_pipeline_layout: u32 = limit_u32_undefined,
    max_dynamic_storage_buffers_per_pipeline_layout: u32 = limit_u32_undefined,
    max_sampled_textures_per_shader_stage: u32 = limit_u32_undefined,
    max_samplers_per_shader_stage: u32 = limit_u32_undefined,
    max_storage_buffers_per_shader_stage: u32 = limit_u32_undefined,
    max_storage_textures_per_shader_stage: u32 = limit_u32_undefined,
    max_uniform_buffers_per_shader_stage: u32 = limit_u32_undefined,
    max_uniform_buffer_binding_size: u64 = limit_u64_undefined,
    max_storage_buffer_binding_size: u64 = limit_u64_undefined,
    min_uniform_buffer_offset_alignment: u32 = limit_u32_undefined,
    min_storage_buffer_offset_alignment: u32 = limit_u32_undefined,
    max_vertex_buffers: u32 = limit_u32_undefined,
    max_buffer_size: u64 = limit_u64_undefined,
    max_vertex_attributes: u32 = limit_u32_undefined,
    max_vertex_buffer_array_stride: u32 = limit_u32_undefined,
    max_inter_stage_shader_components: u32 = limit_u32_undefined,
    max_inter_stage_shader_variables: u32 = limit_u32_undefined,
    max_color_attachments: u32 = limit_u32_undefined,
    max_color_attachment_bytes_per_sample: u32 = limit_u32_undefined,
    max_compute_workgroup_storage_size: u32 = limit_u32_undefined,
    max_compute_invocations_per_workgroup: u32 = limit_u32_undefined,
    max_compute_workgroup_size_x: u32 = limit_u32_undefined,
    max_compute_workgroup_size_y: u32 = limit_u32_undefined,
    max_compute_workgroup_size_z: u32 = limit_u32_undefined,
    max_compute_workgroups_per_dimension: u32 = limit_u32_undefined,
};

pub const MultisampleState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    count: u32,
    mask: u32 = 0xffffffff,
    alpha_to_coverage_enabled: Bool = .false,
};

pub const Origin3D = extern struct {
    x: u32 = 0,
    y: u32 = 0,
    z: u32 = 0,
};

pub const PipelineLayoutDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    bind_group_layout_count: usize = 0,
    bind_group_layouts: [*]const BindGroupLayout = undefined,
};

pub const PrimitiveDepthClipControl = extern struct {
    chain: ChainedStruct = .{ .s_type = .primitive_depth_clip_control },
    unclipped_depth: Bool,
};

pub const PrimitiveState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    topology: PrimitiveTopology = .triangle_list,
    strip_index_format: IndexFormat = .undefined,
    front_face: FrontFace = .ccw,
    cull_mode: CullMode = .back,
};

pub const QuerySetDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    type: QueryType,
    count: u32,
};

pub const QueueDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const RequestAdapterResponse = struct {
    status: RequestAdapterStatus,
    message: [*:0]const u8,
    adapter: Adapter,
};

pub const RequestDeviceResponse = struct {
    status: RequestDeviceStatus,
    message: [*:0]const u8,
    device: Device,
};

pub const RenderBundleDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const RenderBundleEncoderDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    color_format_count: usize = 0,
    color_formats: [*]const TextureFormat = undefined,
    depth_stencil_format: TextureFormat,
    sample_count: u32,
    depth_read_only: Bool,
    stencil_read_only: Bool,
};

pub const RenderPassDepthStencilAttachment = extern struct {
    view: TextureView,
    depth_load_op: LoadOp,
    depth_store_op: StoreOp,
    depth_clear_value: f32,
    depth_read_only: Bool,
    stencil_load_op: LoadOp,
    stencil_store_op: StoreOp,
    stencil_clear_value: u32,
    stencil_read_only: Bool,
};

pub const RenderPassDescriptorMaxDrawCount = extern struct {
    chain: ChainedStruct = .{ .s_type = .render_pass_descriptor_max_draw_count },
    max_draw_count: u64,
};

pub const RenderPassTimestampWrites = extern struct {
    query_set: QuerySet,
    beginning_of_pass_write_index: u32,
    end_of_pass_write_index: u32,
};

pub const RequestAdapterOptions = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    compatible_surface: ?Surface = null,
    power_preference: PowerPreference = .undefined,
    backend_type: BackendType = .undefined,
    force_fallback_adapter: Bool = .false,
};

pub const SamplerBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    type: SamplerBindingType,
};

pub const SamplerDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    address_mode_u: AddressMode,
    address_mode_v: AddressMode,
    address_mode_w: AddressMode,
    mag_filter: FilterMode,
    min_filter: FilterMode,
    mipmap_filter: MipmapFilterMode,
    lod_min_clamp: f32,
    lod_max_clamp: f32,
    compare: CompareFunction,
    max_anisotropy: u16,
};

pub const ShaderModuleCompilationHint = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    entry_point: [*:0]const u8,
    layout: PipelineLayout,
};

pub const ShaderModuleSPIRVDescriptor = extern struct {
    chain: ChainedStruct = .{ .s_type = .shader_module_spirv_descriptor },
    code_size: u32,
    code: *const u32,
};

pub const MergedShaderModuleSPIRVDescriptor = struct {
    label: ?[*:0]const u8 = null,
    hints: []const ShaderModuleCompilationHint = &.{},
    code: []const u32 = &.{},
};

pub inline fn shaderModuleSPIRVDescriptor(descriptor: MergedShaderModuleSPIRVDescriptor) ShaderModuleDescriptor {
    return ShaderModuleDescriptor{
        .next_in_chain = @ptrCast(&ShaderModuleSPIRVDescriptor{
            .code_size = @intCast(descriptor.code.len),
            .code = descriptor.code.ptr,
        }),
        .label = descriptor.label,
        .hint_count = descriptor.hints.len,
        .hints = descriptor.hints.ptr,
    };
}

pub const ShaderModuleWGSLDescriptor = extern struct {
    chain: ChainedStruct = .{ .s_type = .shader_module_wgsl_descriptor },
    code: [*:0]const u8,
};

pub const MergedShaderModuleWGSLDescriptor = struct {
    label: ?[*:0]const u8 = null,
    hints: []const ShaderModuleCompilationHint = &.{},
    code: [*:0]const u8,
};

pub inline fn shaderModuleWGSLDescriptor(descriptor: MergedShaderModuleWGSLDescriptor) ShaderModuleDescriptor {
    return ShaderModuleDescriptor{
        .next_in_chain = @ptrCast(&ShaderModuleWGSLDescriptor{
            .code = descriptor.code,
        }),
        .label = descriptor.label,
        .hint_count = descriptor.hints.len,
        .hints = descriptor.hints.ptr,
    };
}

pub const StencilFaceState = extern struct {
    compare: CompareFunction,
    fail_op: StencilOperation,
    depth_fail_op: StencilOperation,
    pass_op: StencilOperation,
};

pub const StorageTextureBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    access: StorageTextureAccess,
    format: TextureFormat,
    view_dimension: TextureViewDimension,
};

pub const SurfaceCapabilities = extern struct {
    next_in_chain: ?*ChainedStructOut = null,
    usages: TextureUsageFlags = TextureUsageFlags.none,
    format_count: usize = 0,
    _formats: [*]const TextureFormat = undefined,
    present_mode_count: usize = 0,
    _present_modes: [*]const PresentMode = undefined,
    alpha_mode_count: usize = 0,
    _alpha_modes: [*]const CompositeAlphaMode = undefined,

    pub fn formats(self: SurfaceCapabilities) []const TextureFormat {
        return self._formats[0..self.format_count];
    }
    pub fn present_modes(self: SurfaceCapabilities) []const PresentMode {
        return self._present_modes[0..self.present_mode_count];
    }
    pub fn alpha_modes(self: SurfaceCapabilities) []const CompositeAlphaMode {
        return self._alpha_modes[0..self.alpha_mode_count];
    }
    pub const freeMembers = wgpu.surfaceCapabilitiesFreeMembers;
};

pub const SurfaceConfiguration = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    device: Device,
    format: TextureFormat,
    usage: TextureUsageFlags,
    view_format_count: usize = 0,
    view_formats: [*]const TextureFormat = undefined,
    alpha_mode: CompositeAlphaMode,
    width: u32,
    height: u32,
    present_mode: PresentMode,
};

pub const SurfaceDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const SurfaceDescriptorFromAndroidNativeWindow = extern struct {
    chain: ChainedStruct = .{ .s_type = .surface_descriptor_from_android_native_window },
    window: *anyopaque,
};

pub const MergedSurfaceDescriptorFromAndroidWindow = struct {
    label: ?[*:0]const u8 = null,
    window: *anyopaque,
};

pub inline fn surfaceDescriptorFromAndroidNativeWindow(descriptor: MergedSurfaceDescriptorFromAndroidWindow) SurfaceDescriptor {
    return SurfaceDescriptor{
        .next_in_chain = @ptrCast(&SurfaceDescriptorFromAndroidNativeWindow{
            .window = descriptor.window,
        }),
        .label = descriptor.label,
    };
}

pub const SurfaceDescriptorFromCanvasHTMLSelector = extern struct {
    chain: ChainedStruct = .{ .s_type = .surface_descriptor_from_canvas_html_selector },
    selector: [*:0]const u8,
};

pub const MergedSurfaceDescriptorFromCanvasHTMLSelector = struct {
    label: ?[*:0]const u8 = null,
    selector: [*:0]const u8,
};

pub inline fn surfaceDescriptorFromCanvasHTMLSelector(descriptor: MergedSurfaceDescriptorFromCanvasHTMLSelector) SurfaceDescriptor {
    return SurfaceDescriptor{
        .next_in_chain = @ptrCast(&SurfaceDescriptorFromCanvasHTMLSelector{
            .selector = descriptor.selector,
        }),
        .label = descriptor.label,
    };
}

pub const SurfaceDescriptorFromMetalLayer = extern struct {
    chain: ChainedStruct = .{ .s_type = .surface_descriptor_from_metal_layer },
    layer: *anyopaque,
};

pub const MergedSurfaceDescriptorFromMetalLayer = struct {
    label: ?[*:0]const u8 = null,
    layer: *anyopaque,
};

pub inline fn surfaceDescriptorFromMetalLayer(descriptor: MergedSurfaceDescriptorFromMetalLayer) SurfaceDescriptor {
    return SurfaceDescriptor{
        .next_in_chain = @ptrCast(&SurfaceDescriptorFromMetalLayer{
            .layer = descriptor.layer,
        }),
        .label = descriptor.label,
    };
}

pub const SurfaceDescriptorFromWaylandSurface = extern struct {
    chain: ChainedStruct = .{ .s_type = .surface_descriptor_from_wayland_surface },
    display: *anyopaque,
    surface: *anyopaque,
};

pub const MergedSurfaceDescriptorFromWaylandSurface = struct {
    label: ?[*:0]const u8 = null,
    display: *anyopaque,
    surface: *anyopaque,
};

pub inline fn surfaceDescriptorFromWaylandSurface(descriptor: MergedSurfaceDescriptorFromWaylandSurface) SurfaceDescriptor {
    return SurfaceDescriptor{
        .next_in_chain = @ptrCast(&SurfaceDescriptorFromWaylandSurface{
            .display = descriptor.display,
            .surface = descriptor.surface,
        }),
        .label = descriptor.label,
    };
}

pub const SurfaceDescriptorFromWindowsHWND = extern struct {
    chain: ChainedStruct = .{ .s_type = .surface_descriptor_from_windows_hwnd },
    hinstance: *anyopaque,
    hwnd: *anyopaque,
};

pub const MergedSurfaceDescriptorFromWindowsHWND = struct {
    label: ?[*:0]const u8 = null,
    hinstance: *anyopaque,
    hwnd: *anyopaque,
};

pub inline fn surfaceDescriptorFromWindowsHWND(descriptor: MergedSurfaceDescriptorFromWindowsHWND) SurfaceDescriptor {
    return SurfaceDescriptor{
        .next_in_chain = @ptrCast(&SurfaceDescriptorFromWindowsHWND{
            .hinstance = descriptor.hinstance,
            .hwnd = descriptor.hwnd,
        }),
        .label = descriptor.label,
    };
}

pub const SurfaceDescriptorFromXcbWindow = extern struct {
    chain: ChainedStruct = .{ .s_type = .surface_descriptor_from_xcb_window },
    connection: *anyopaque,
    window: u32,
};

pub const MergedSurfaceDescriptorFromXcbWindow = struct {
    label: ?[*:0]const u8 = null,
    connection: *anyopaque,
    window: u32,
};

pub inline fn surfaceDescriptorFromXcbWindow(descriptor: MergedSurfaceDescriptorFromXcbWindow) SurfaceDescriptor {
    return SurfaceDescriptor{
        .next_in_chain = @ptrCast(&SurfaceDescriptorFromXcbWindow{
            .connection = descriptor.connection,
            .window = descriptor.window,
        }),
        .label = descriptor.label,
    };
}

pub const SurfaceDescriptorFromXlibWindow = extern struct {
    chain: ChainedStruct = .{ .s_type = .surface_descriptor_from_xlib_window },
    display: *anyopaque,
    window: u64,
};

pub const MergedSurfaceDescriptorFromXlibWindow = struct {
    label: ?[*:0]const u8 = null,
    display: *anyopaque,
    window: u64,
};

pub inline fn surfaceDescriptorFromXlibWindow(descriptor: MergedSurfaceDescriptorFromXlibWindow) SurfaceDescriptor {
    return SurfaceDescriptor{
        .next_in_chain = @ptrCast(&SurfaceDescriptorFromXlibWindow{
            .display = descriptor.display,
            .window = descriptor.window,
        }),
        .label = descriptor.label,
    };
}

pub const SurfaceTexture = extern struct {
    texture: Texture = undefined,
    suboptimal: Bool = .false,
    status: SurfaceGetCurrentTextureStatus = .success,
};

pub const TextureBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    sample_type: TextureSampleType,
    view_dimension: TextureViewDimension,
    multisampled: Bool,
};

pub const TextureDataLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    offset: u64,
    bytes_per_row: u32,
    rows_per_image: u32,
};

pub const TextureViewDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    format: TextureFormat,
    dimension: TextureViewDimension,
    base_mip_level: u32,
    mip_level_count: u32 = mip_level_count_undefined,
    base_array_layer: u32,
    array_layer_count: u32 = array_layer_count_undefined,
    aspect: TextureAspect,
};

pub const UncapturedErrorCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    callback: ErrorCallback = &defaultErrorCallback,
    userdata: ?*const anyopaque = null,
};

fn defaultErrorCallback(
    type_: ErrorType,
    message: [*:0]const u8,
    userdata: ?*anyopaque,
) callconv(.C) void {
    std.log.err("WebGPU error: {s} {s}", .{ @tagName(type_), message });
    _ = userdata;
}

pub const VertexAttribute = extern struct {
    format: VertexFormat,
    offset: u64,
    shader_location: u32,
};

pub const BindGroupDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    layout: BindGroupLayout,
    entry_count: usize = 0,
    entries: [*]const BindGroupEntry = undefined,
};

pub const BindGroupLayoutEntry = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    binding: u32,
    visibility: ShaderStageFlags,
    buffer: BufferBindingLayout,
    sampler: SamplerBindingLayout,
    texture: TextureBindingLayout,
    storage_texture: StorageTextureBindingLayout,
};

pub const BlendState = extern struct {
    color: BlendComponent,
    alpha: BlendComponent,
};

pub const CompilationInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    message_count: usize = 0,
    _messages: [*]const CompilationMessage = undefined,

    pub fn messages(self: CompilationInfo) []const CompilationMessage {
        return self._messages[0..self.message_count];
    }
};

pub const ComputePassDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    timestamp_writes: ?*const ComputePassTimestampWrites = null,
};

pub const DepthStencilState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    format: TextureFormat,
    depth_write_enabled: Bool,
    depth_compare: CompareFunction,
    stencil_front: StencilFaceState,
    stencil_back: StencilFaceState,
    stencil_read_mask: u32,
    stencil_write_mask: u32,
    depth_bias: i32,
    depth_bias_slope_scale: f32,
    depth_bias_clamp: f32,
};

pub const ImageCopyBuffer = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    layout: TextureDataLayout,
    buffer: Buffer,
};

pub const ImageCopyTexture = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    texture: Texture,
    mip_level: u32,
    origin: Origin3D,
    aspect: TextureAspect,
};

pub const ProgrammableStageDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    module: ShaderModule,
    entry_point: ?[*:0]const u8 = null,
    constant_count: usize = 0,
    constants: [*]const ConstantEntry = undefined,
};

pub const RenderPassColorAttachment = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    view: ?TextureView = null,
    depth_slice: u32 = depth_slice_undefined,
    resolve_target: ?TextureView = null,
    load_op: LoadOp,
    store_op: StoreOp,
    clear_value: Color,
};

pub const RequiredLimits = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    limits: Limits,
};

pub const ShaderModuleDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    hint_count: usize = 0,
    hints: [*]const ShaderModuleCompilationHint = undefined,
};

pub const SupportedLimits = extern struct {
    next_in_chain: ?*ChainedStructOut = null,
    limits: Limits = .{},
};

pub const TextureDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    usage: TextureUsageFlags,
    dimension: TextureDimension,
    size: Extent3D,
    format: TextureFormat,
    mip_level_count: u32 = mip_level_count_undefined,
    sample_count: u32,
    view_format_count: usize = 0,
    view_formats: [*]const TextureFormat = undefined,
};

pub const VertexBufferLayout = extern struct {
    array_stride: u64,
    step_mode: VertexStepMode,
    attribute_count: usize = 0,
    attributes: [*]const VertexAttribute = undefined,
};

pub const BindGroupLayoutDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    entry_count: usize = 0,
    entries: [*]const BindGroupLayoutEntry = undefined,
};

pub const ColorTargetState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    format: TextureFormat = .undefined,
    blend: ?*const BlendState = null,
    write_mask: ColorWriteMaskFlags = ColorWriteMaskFlags.all,
};

pub const ComputePipelineDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    layout: ?PipelineLayout = null,
    compute: ProgrammableStageDescriptor,
};

pub const DeviceDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    required_feature_count: usize = 0,
    required_features: [*]const FeatureName = undefined,
    required_limits: ?*const RequiredLimits = null,
    default_queue: QueueDescriptor = .{},
    device_lost_callback: DeviceLostCallback = &defaultDeviceLostCallback,
    device_lost_userdata: ?*const anyopaque = null,
    uncaptured_error_callback_info: UncapturedErrorCallbackInfo = .{},
};

fn defaultDeviceLostCallback(
    reason: DeviceLostReason,
    message: [*:0]const u8,
    userdata: ?*anyopaque,
) callconv(.C) void {
    _ = userdata;
    std.log.warn("WebGPU device lost: {s} {s}", .{ @tagName(reason), message });
}

pub const RenderPassDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    color_attachment_count: usize,
    color_attachments: [*]const RenderPassColorAttachment,
    depth_stencil_attachment: ?*const RenderPassDepthStencilAttachment = null,
    occlusion_query_set: ?QuerySet = null,
    timestamp_writes: ?*const RenderPassTimestampWrites = null,
};

pub const VertexState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    module: ShaderModule,
    entry_point: ?[*:0]const u8 = null,
    constant_count: usize = 0,
    constants: [*]const ConstantEntry = undefined,
    buffer_count: usize = 0,
    buffers: [*]const VertexBufferLayout = undefined,
};

pub const FragmentState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    module: ShaderModule,
    entry_point: ?[*:0]const u8 = null,
    constant_count: usize = 0,
    constants: [*]const ConstantEntry = undefined,
    target_count: usize = 0,
    targets: [*]const ColorTargetState = undefined,
};

pub const RenderPipelineDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    layout: ?PipelineLayout = null,
    vertex: VertexState,
    primitive: PrimitiveState,
    depth_stencil: ?*const DepthStencilState = null,
    multisample: MultisampleState,
    fragment: ?*const FragmentState = null,
};

const cdef = struct {
    pub extern fn wgpuCreateInstance(descriptor: ?*const InstanceDescriptor) Instance;
    pub extern fn wgpuGetProcAddress(device: Device, procName: [*:0]const u8) Proc;
    pub extern fn wgpuAdapterEnumerateFeatures(adapter: Adapter, features: ?[*]FeatureName) usize;
    pub extern fn wgpuAdapterGetLimits(adapter: Adapter, limits: *SupportedLimits) Bool;
    pub extern fn wgpuAdapterGetInfo(adapter: Adapter, info: *AdapterInfo) void;
    pub extern fn wgpuAdapterHasFeature(adapter: Adapter, feature: FeatureName) Bool;
    pub extern fn wgpuAdapterRequestDevice(adapter: Adapter, descriptor: ?*const DeviceDescriptor, callback: AdapterRequestDeviceCallback, userdata: ?*const anyopaque) void;
    pub extern fn wgpuAdapterReference(adapter: Adapter) void;
    pub extern fn wgpuAdapterRelease(adapter: Adapter) void;
    pub extern fn wgpuAdapterInfoFreeMembers(info: AdapterInfo) void;
    pub extern fn wgpuBindGroupSetLabel(bindGroup: BindGroup, label: [*:0]const u8) void;
    pub extern fn wgpuBindGroupReference(bindGroup: BindGroup) void;
    pub extern fn wgpuBindGroupRelease(bindGroup: BindGroup) void;
    pub extern fn wgpuBindGroupLayoutSetLabel(bindGroupLayout: BindGroupLayout, label: [*:0]const u8) void;
    pub extern fn wgpuBindGroupLayoutReference(bindGroupLayout: BindGroupLayout) void;
    pub extern fn wgpuBindGroupLayoutRelease(bindGroupLayout: BindGroupLayout) void;
    pub extern fn wgpuBufferDestroy(buffer: Buffer) void;
    pub extern fn wgpuBufferGetConstMappedRange(buffer: Buffer, offset: usize, size: usize) [*]const u8;
    pub extern fn wgpuBufferGetMapState(buffer: Buffer) BufferMapState;
    pub extern fn wgpuBufferGetMappedRange(buffer: Buffer, offset: usize, size: usize) [*]u8;
    pub extern fn wgpuBufferGetSize(buffer: Buffer) u64;
    pub extern fn wgpuBufferGetUsage(buffer: Buffer) BufferUsageFlags;
    pub extern fn wgpuBufferMapAsync(buffer: Buffer, mode: MapModeFlags, offset: usize, size: usize, callback: BufferMapAsyncCallback, userdata: ?*const anyopaque) void;
    pub extern fn wgpuBufferSetLabel(buffer: Buffer, label: [*:0]const u8) void;
    pub extern fn wgpuBufferUnmap(buffer: Buffer) void;
    pub extern fn wgpuBufferReference(buffer: Buffer) void;
    pub extern fn wgpuBufferRelease(buffer: Buffer) void;
    pub extern fn wgpuCommandBufferSetLabel(commandBuffer: CommandBuffer, label: [*:0]const u8) void;
    pub extern fn wgpuCommandBufferReference(commandBuffer: CommandBuffer) void;
    pub extern fn wgpuCommandBufferRelease(commandBuffer: CommandBuffer) void;
    pub extern fn wgpuCommandEncoderBeginComputePass(commandEncoder: CommandEncoder, descriptor: ?*const ComputePassDescriptor) ComputePassEncoder;
    pub extern fn wgpuCommandEncoderBeginRenderPass(commandEncoder: CommandEncoder, descriptor: *const RenderPassDescriptor) RenderPassEncoder;
    pub extern fn wgpuCommandEncoderClearBuffer(commandEncoder: CommandEncoder, buffer: Buffer, offset: u64, size: u64) void;
    pub extern fn wgpuCommandEncoderCopyBufferToBuffer(commandEncoder: CommandEncoder, source: Buffer, sourceOffset: u64, destination: Buffer, destinationOffset: u64, size: u64) void;
    pub extern fn wgpuCommandEncoderCopyBufferToTexture(commandEncoder: CommandEncoder, source: *const ImageCopyBuffer, destination: *const ImageCopyTexture, copySize: *const Extent3D) void;
    pub extern fn wgpuCommandEncoderCopyTextureToBuffer(commandEncoder: CommandEncoder, source: *const ImageCopyTexture, destination: *const ImageCopyBuffer, copySize: *const Extent3D) void;
    pub extern fn wgpuCommandEncoderCopyTextureToTexture(commandEncoder: CommandEncoder, source: *const ImageCopyTexture, destination: *const ImageCopyTexture, copySize: *const Extent3D) void;
    pub extern fn wgpuCommandEncoderFinish(commandEncoder: CommandEncoder, descriptor: ?*const CommandBufferDescriptor) CommandBuffer;
    pub extern fn wgpuCommandEncoderInsertDebugMarker(commandEncoder: CommandEncoder, markerLabel: [*:0]const u8) void;
    pub extern fn wgpuCommandEncoderPopDebugGroup(commandEncoder: CommandEncoder) void;
    pub extern fn wgpuCommandEncoderPushDebugGroup(commandEncoder: CommandEncoder, groupLabel: [*:0]const u8) void;
    pub extern fn wgpuCommandEncoderResolveQuerySet(commandEncoder: CommandEncoder, querySet: QuerySet, firstQuery: u32, queryCount: u32, destination: Buffer, destinationOffset: u64) void;
    pub extern fn wgpuCommandEncoderSetLabel(commandEncoder: CommandEncoder, label: [*:0]const u8) void;
    pub extern fn wgpuCommandEncoderWriteTimestamp(commandEncoder: CommandEncoder, querySet: QuerySet, queryIndex: u32) void;
    pub extern fn wgpuCommandEncoderReference(commandEncoder: CommandEncoder) void;
    pub extern fn wgpuCommandEncoderRelease(commandEncoder: CommandEncoder) void;
    pub extern fn wgpuComputePassEncoderDispatchWorkgroups(computePassEncoder: ComputePassEncoder, workgroupCountX: u32, workgroupCountY: u32, workgroupCountZ: u32) void;
    pub extern fn wgpuComputePassEncoderDispatchWorkgroupsIndirect(computePassEncoder: ComputePassEncoder, indirectBuffer: Buffer, indirectOffset: u64) void;
    pub extern fn wgpuComputePassEncoderEnd(computePassEncoder: ComputePassEncoder) void;
    pub extern fn wgpuComputePassEncoderInsertDebugMarker(computePassEncoder: ComputePassEncoder, markerLabel: [*:0]const u8) void;
    pub extern fn wgpuComputePassEncoderPopDebugGroup(computePassEncoder: ComputePassEncoder) void;
    pub extern fn wgpuComputePassEncoderPushDebugGroup(computePassEncoder: ComputePassEncoder, groupLabel: [*:0]const u8) void;
    pub extern fn wgpuComputePassEncoderSetBindGroup(computePassEncoder: ComputePassEncoder, groupIndex: u32, group: ?BindGroup, dynamicOffsetCount: usize, dynamicOffsets: [*]const u32) void;
    pub extern fn wgpuComputePassEncoderSetLabel(computePassEncoder: ComputePassEncoder, label: [*:0]const u8) void;
    pub extern fn wgpuComputePassEncoderSetPipeline(computePassEncoder: ComputePassEncoder, pipeline: ComputePipeline) void;
    pub extern fn wgpuComputePassEncoderReference(computePassEncoder: ComputePassEncoder) void;
    pub extern fn wgpuComputePassEncoderRelease(computePassEncoder: ComputePassEncoder) void;
    pub extern fn wgpuComputePipelineGetBindGroupLayout(computePipeline: ComputePipeline, groupIndex: u32) BindGroupLayout;
    pub extern fn wgpuComputePipelineSetLabel(computePipeline: ComputePipeline, label: [*:0]const u8) void;
    pub extern fn wgpuComputePipelineReference(computePipeline: ComputePipeline) void;
    pub extern fn wgpuComputePipelineRelease(computePipeline: ComputePipeline) void;
    pub extern fn wgpuDeviceCreateBindGroup(device: Device, descriptor: *const BindGroupDescriptor) BindGroup;
    pub extern fn wgpuDeviceCreateBindGroupLayout(device: Device, descriptor: *const BindGroupLayoutDescriptor) BindGroupLayout;
    pub extern fn wgpuDeviceCreateBuffer(device: Device, descriptor: *const BufferDescriptor) Buffer;
    pub extern fn wgpuDeviceCreateCommandEncoder(device: Device, descriptor: ?*const CommandEncoderDescriptor) CommandEncoder;
    pub extern fn wgpuDeviceCreateComputePipeline(device: Device, descriptor: *const ComputePipelineDescriptor) ComputePipeline;
    pub extern fn wgpuDeviceCreateComputePipelineAsync(device: Device, descriptor: *const ComputePipelineDescriptor, callback: DeviceCreateComputePipelineAsyncCallback, userdata: ?*const anyopaque) void;
    pub extern fn wgpuDeviceCreatePipelineLayout(device: Device, descriptor: *const PipelineLayoutDescriptor) PipelineLayout;
    pub extern fn wgpuDeviceCreateQuerySet(device: Device, descriptor: *const QuerySetDescriptor) QuerySet;
    pub extern fn wgpuDeviceCreateRenderBundleEncoder(device: Device, descriptor: *const RenderBundleEncoderDescriptor) RenderBundleEncoder;
    pub extern fn wgpuDeviceCreateRenderPipeline(device: Device, descriptor: *const RenderPipelineDescriptor) RenderPipeline;
    pub extern fn wgpuDeviceCreateRenderPipelineAsync(device: Device, descriptor: *const RenderPipelineDescriptor, callback: DeviceCreateRenderPipelineAsyncCallback, userdata: ?*const anyopaque) void;
    pub extern fn wgpuDeviceCreateSampler(device: Device, descriptor: ?*const SamplerDescriptor) Sampler;
    pub extern fn wgpuDeviceCreateShaderModule(device: Device, descriptor: *const ShaderModuleDescriptor) ShaderModule;
    pub extern fn wgpuDeviceCreateTexture(device: Device, descriptor: *const TextureDescriptor) Texture;
    pub extern fn wgpuDeviceDestroy(device: Device) void;
    pub extern fn wgpuDeviceEnumerateFeatures(device: Device, features: ?[*]FeatureName) usize;
    pub extern fn wgpuDeviceGetLimits(device: Device, limits: *SupportedLimits) Bool;
    pub extern fn wgpuDeviceGetQueue(device: Device) Queue;
    pub extern fn wgpuDeviceHasFeature(device: Device, feature: FeatureName) Bool;
    pub extern fn wgpuDevicePopErrorScope(device: Device, callback: ErrorCallback, userdata: ?*const anyopaque) void;
    pub extern fn wgpuDevicePushErrorScope(device: Device, filter: ErrorFilter) void;
    pub extern fn wgpuDeviceSetLabel(device: Device, label: [*:0]const u8) void;
    pub extern fn wgpuDeviceReference(device: Device) void;
    pub extern fn wgpuDeviceRelease(device: Device) void;
    pub extern fn wgpuInstanceCreateSurface(instance: Instance, descriptor: *const SurfaceDescriptor) Surface;
    pub extern fn wgpuInstanceHasWGSLLanguageFeature(instance: Instance, feature: WGSLFeatureName) Bool;
    pub extern fn wgpuInstanceProcessEvents(instance: Instance) void;
    pub extern fn wgpuInstanceRequestAdapter(instance: Instance, options: ?*const RequestAdapterOptions, callback: InstanceRequestAdapterCallback, userdata: ?*const anyopaque) void;
    pub extern fn wgpuInstanceReference(instance: Instance) void;
    pub extern fn wgpuInstanceRelease(instance: Instance) void;
    pub extern fn wgpuPipelineLayoutSetLabel(pipelineLayout: PipelineLayout, label: [*:0]const u8) void;
    pub extern fn wgpuPipelineLayoutReference(pipelineLayout: PipelineLayout) void;
    pub extern fn wgpuPipelineLayoutRelease(pipelineLayout: PipelineLayout) void;
    pub extern fn wgpuQuerySetDestroy(querySet: QuerySet) void;
    pub extern fn wgpuQuerySetGetCount(querySet: QuerySet) u32;
    pub extern fn wgpuQuerySetGetType(querySet: QuerySet) QueryType;
    pub extern fn wgpuQuerySetSetLabel(querySet: QuerySet, label: [*:0]const u8) void;
    pub extern fn wgpuQuerySetReference(querySet: QuerySet) void;
    pub extern fn wgpuQuerySetRelease(querySet: QuerySet) void;
    pub extern fn wgpuQueueOnSubmittedWorkDone(queue: Queue, callback: QueueOnSubmittedWorkDoneCallback, userdata: ?*const anyopaque) void;
    pub extern fn wgpuQueueSetLabel(queue: Queue, label: [*:0]const u8) void;
    pub extern fn wgpuQueueSubmit(queue: Queue, commandCount: usize, commands: [*]const CommandBuffer) void;
    pub extern fn wgpuQueueWriteBuffer(queue: Queue, buffer: Buffer, bufferOffset: u64, data: [*]const u8, size: usize) void;
    pub extern fn wgpuQueueWriteTexture(queue: Queue, destination: *const ImageCopyTexture, data: [*]const u8, dataSize: usize, dataLayout: *const TextureDataLayout, writeSize: *const Extent3D) void;
    pub extern fn wgpuQueueReference(queue: Queue) void;
    pub extern fn wgpuQueueRelease(queue: Queue) void;
    pub extern fn wgpuRenderBundleSetLabel(renderBundle: RenderBundle, label: [*:0]const u8) void;
    pub extern fn wgpuRenderBundleReference(renderBundle: RenderBundle) void;
    pub extern fn wgpuRenderBundleRelease(renderBundle: RenderBundle) void;
    pub extern fn wgpuRenderBundleEncoderDraw(renderBundleEncoder: RenderBundleEncoder, vertexCount: u32, instanceCount: u32, firstVertex: u32, firstInstance: u32) void;
    pub extern fn wgpuRenderBundleEncoderDrawIndexed(renderBundleEncoder: RenderBundleEncoder, indexCount: u32, instanceCount: u32, firstIndex: u32, baseVertex: i32, firstInstance: u32) void;
    pub extern fn wgpuRenderBundleEncoderDrawIndexedIndirect(renderBundleEncoder: RenderBundleEncoder, indirectBuffer: Buffer, indirectOffset: u64) void;
    pub extern fn wgpuRenderBundleEncoderDrawIndirect(renderBundleEncoder: RenderBundleEncoder, indirectBuffer: Buffer, indirectOffset: u64) void;
    pub extern fn wgpuRenderBundleEncoderFinish(renderBundleEncoder: RenderBundleEncoder, descriptor: ?*const RenderBundleDescriptor) RenderBundle;
    pub extern fn wgpuRenderBundleEncoderInsertDebugMarker(renderBundleEncoder: RenderBundleEncoder, markerLabel: [*:0]const u8) void;
    pub extern fn wgpuRenderBundleEncoderPopDebugGroup(renderBundleEncoder: RenderBundleEncoder) void;
    pub extern fn wgpuRenderBundleEncoderPushDebugGroup(renderBundleEncoder: RenderBundleEncoder, groupLabel: [*:0]const u8) void;
    pub extern fn wgpuRenderBundleEncoderSetBindGroup(renderBundleEncoder: RenderBundleEncoder, groupIndex: u32, group: ?BindGroup, dynamicOffsetCount: usize, dynamicOffsets: [*]const u32) void;
    pub extern fn wgpuRenderBundleEncoderSetIndexBuffer(renderBundleEncoder: RenderBundleEncoder, buffer: Buffer, format: IndexFormat, offset: u64, size: u64) void;
    pub extern fn wgpuRenderBundleEncoderSetLabel(renderBundleEncoder: RenderBundleEncoder, label: [*:0]const u8) void;
    pub extern fn wgpuRenderBundleEncoderSetPipeline(renderBundleEncoder: RenderBundleEncoder, pipeline: RenderPipeline) void;
    pub extern fn wgpuRenderBundleEncoderSetVertexBuffer(renderBundleEncoder: RenderBundleEncoder, slot: u32, buffer: ?Buffer, offset: u64, size: u64) void;
    pub extern fn wgpuRenderBundleEncoderReference(renderBundleEncoder: RenderBundleEncoder) void;
    pub extern fn wgpuRenderBundleEncoderRelease(renderBundleEncoder: RenderBundleEncoder) void;
    pub extern fn wgpuRenderPassEncoderBeginOcclusionQuery(renderPassEncoder: RenderPassEncoder, queryIndex: u32) void;
    pub extern fn wgpuRenderPassEncoderDraw(renderPassEncoder: RenderPassEncoder, vertexCount: u32, instanceCount: u32, firstVertex: u32, firstInstance: u32) void;
    pub extern fn wgpuRenderPassEncoderDrawIndexed(renderPassEncoder: RenderPassEncoder, indexCount: u32, instanceCount: u32, firstIndex: u32, baseVertex: i32, firstInstance: u32) void;
    pub extern fn wgpuRenderPassEncoderDrawIndexedIndirect(renderPassEncoder: RenderPassEncoder, indirectBuffer: Buffer, indirectOffset: u64) void;
    pub extern fn wgpuRenderPassEncoderDrawIndirect(renderPassEncoder: RenderPassEncoder, indirectBuffer: Buffer, indirectOffset: u64) void;
    pub extern fn wgpuRenderPassEncoderEnd(renderPassEncoder: RenderPassEncoder) void;
    pub extern fn wgpuRenderPassEncoderEndOcclusionQuery(renderPassEncoder: RenderPassEncoder) void;
    pub extern fn wgpuRenderPassEncoderExecuteBundles(renderPassEncoder: RenderPassEncoder, bundleCount: usize, bundles: [*]const RenderBundle) void;
    pub extern fn wgpuRenderPassEncoderInsertDebugMarker(renderPassEncoder: RenderPassEncoder, markerLabel: [*:0]const u8) void;
    pub extern fn wgpuRenderPassEncoderPopDebugGroup(renderPassEncoder: RenderPassEncoder) void;
    pub extern fn wgpuRenderPassEncoderPushDebugGroup(renderPassEncoder: RenderPassEncoder, groupLabel: [*:0]const u8) void;
    pub extern fn wgpuRenderPassEncoderSetBindGroup(renderPassEncoder: RenderPassEncoder, groupIndex: u32, group: ?BindGroup, dynamicOffsetCount: usize, dynamicOffsets: [*]const u32) void;
    pub extern fn wgpuRenderPassEncoderSetBlendConstant(renderPassEncoder: RenderPassEncoder, color: *const Color) void;
    pub extern fn wgpuRenderPassEncoderSetIndexBuffer(renderPassEncoder: RenderPassEncoder, buffer: Buffer, format: IndexFormat, offset: u64, size: u64) void;
    pub extern fn wgpuRenderPassEncoderSetLabel(renderPassEncoder: RenderPassEncoder, label: [*:0]const u8) void;
    pub extern fn wgpuRenderPassEncoderSetPipeline(renderPassEncoder: RenderPassEncoder, pipeline: RenderPipeline) void;
    pub extern fn wgpuRenderPassEncoderSetScissorRect(renderPassEncoder: RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) void;
    pub extern fn wgpuRenderPassEncoderSetStencilReference(renderPassEncoder: RenderPassEncoder, reference: u32) void;
    pub extern fn wgpuRenderPassEncoderSetVertexBuffer(renderPassEncoder: RenderPassEncoder, slot: u32, buffer: ?Buffer, offset: u64, size: u64) void;
    pub extern fn wgpuRenderPassEncoderSetViewport(renderPassEncoder: RenderPassEncoder, x: f32, y: f32, width: f32, height: f32, minDepth: f32, maxDepth: f32) void;
    pub extern fn wgpuRenderPassEncoderReference(renderPassEncoder: RenderPassEncoder) void;
    pub extern fn wgpuRenderPassEncoderRelease(renderPassEncoder: RenderPassEncoder) void;
    pub extern fn wgpuRenderPipelineGetBindGroupLayout(renderPipeline: RenderPipeline, groupIndex: u32) BindGroupLayout;
    pub extern fn wgpuRenderPipelineSetLabel(renderPipeline: RenderPipeline, label: [*:0]const u8) void;
    pub extern fn wgpuRenderPipelineReference(renderPipeline: RenderPipeline) void;
    pub extern fn wgpuRenderPipelineRelease(renderPipeline: RenderPipeline) void;
    pub extern fn wgpuSamplerSetLabel(sampler: Sampler, label: [*:0]const u8) void;
    pub extern fn wgpuSamplerReference(sampler: Sampler) void;
    pub extern fn wgpuSamplerRelease(sampler: Sampler) void;
    pub extern fn wgpuShaderModuleGetCompilationInfo(shaderModule: ShaderModule, callback: ShaderModuleGetCompilationInfoCallback, userdata: ?*const anyopaque) void;
    pub extern fn wgpuShaderModuleSetLabel(shaderModule: ShaderModule, label: [*:0]const u8) void;
    pub extern fn wgpuShaderModuleReference(shaderModule: ShaderModule) void;
    pub extern fn wgpuShaderModuleRelease(shaderModule: ShaderModule) void;
    pub extern fn wgpuSurfaceConfigure(surface: Surface, config: *const SurfaceConfiguration) void;
    pub extern fn wgpuSurfaceGetCapabilities(surface: Surface, adapter: Adapter, capabilities: *SurfaceCapabilities) void;
    pub extern fn wgpuSurfaceGetCurrentTexture(surface: Surface, surfaceTexture: *SurfaceTexture) void;
    pub extern fn wgpuSurfacePresent(surface: Surface) void;
    pub extern fn wgpuSurfaceSetLabel(surface: Surface, label: [*:0]const u8) void;
    pub extern fn wgpuSurfaceUnconfigure(surface: Surface) void;
    pub extern fn wgpuSurfaceReference(surface: Surface) void;
    pub extern fn wgpuSurfaceRelease(surface: Surface) void;
    pub extern fn wgpuSurfaceCapabilitiesFreeMembers(capabilities: SurfaceCapabilities) void;
    pub extern fn wgpuTextureCreateView(texture: Texture, descriptor: ?*const TextureViewDescriptor) TextureView;
    pub extern fn wgpuTextureDestroy(texture: Texture) void;
    pub extern fn wgpuTextureGetDepthOrArrayLayers(texture: Texture) u32;
    pub extern fn wgpuTextureGetDimension(texture: Texture) TextureDimension;
    pub extern fn wgpuTextureGetFormat(texture: Texture) TextureFormat;
    pub extern fn wgpuTextureGetHeight(texture: Texture) u32;
    pub extern fn wgpuTextureGetMipLevelCount(texture: Texture) u32;
    pub extern fn wgpuTextureGetSampleCount(texture: Texture) u32;
    pub extern fn wgpuTextureGetUsage(texture: Texture) TextureUsageFlags;
    pub extern fn wgpuTextureGetWidth(texture: Texture) u32;
    pub extern fn wgpuTextureSetLabel(texture: Texture, label: [*:0]const u8) void;
    pub extern fn wgpuTextureReference(texture: Texture) void;
    pub extern fn wgpuTextureRelease(texture: Texture) void;
    pub extern fn wgpuTextureViewSetLabel(textureView: TextureView, label: [*:0]const u8) void;
    pub extern fn wgpuTextureViewReference(textureView: TextureView) void;
    pub extern fn wgpuTextureViewRelease(textureView: TextureView) void;

    // wgpu-native extras (wgpu.h)
    pub extern fn wgpuGenerateReport(instance: Instance, report: *GlobalReport) void;
    pub extern fn wgpuInstanceEnumerateAdapters(instance: Instance, options: ?*const InstanceEnumerateAdapterOptions, adapters: ?[*]Adapter) usize;
    pub extern fn wgpuQueueSubmitForIndex(queue: Queue, commandCount: usize, commands: [*]const CommandBuffer) SubmissionIndex;
    pub extern fn wgpuDevicePoll(device: Device, wait: Bool, wrappedSubmissionIndex: ?*const WrappedSubmissionIndex) Bool;
    pub extern fn wgpuSetLogCallback(callback: LogCallback, userdata: ?*const anyopaque) void;
    pub extern fn wgpuSetLogLevel(level: LogLevel) void;
    pub extern fn wgpuGetVersion() u32;
    pub extern fn wgpuRenderPassEncoderSetPushConstants(encoder: RenderPassEncoder, stages: ShaderStageFlags, offset: u32, sizeBytes: u32, data: [*]const u8) void;
    pub extern fn wgpuRenderPassEncoderMultiDrawIndirect(encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count: u32) void;
    pub extern fn wgpuRenderPassEncoderMultiDrawIndexedIndirect(encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count: u32) void;
    pub extern fn wgpuRenderPassEncoderMultiDrawIndirectCount(encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count_buffer: Buffer, count_buffer_offset: u64, max_count: u32) void;
    pub extern fn wgpuRenderPassEncoderMultiDrawIndexedIndirectCount(encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count_buffer: Buffer, count_buffer_offset: u64, max_count: u32) void;
    pub extern fn wgpuRenderPassEncoderBeginPipelineStatisticsQuery(renderPassEncoder: RenderPassEncoder, querySet: QuerySet, queryIndex: u32) void;
    pub extern fn wgpuRenderPassEncoderEndPipelineStatisticsQuery(renderPassEncoder: RenderPassEncoder) void;
    pub extern fn wgpuComputePassEncoderBeginPipelineStatisticsQuery(computePassEncoder: ComputePassEncoder, querySet: QuerySet, queryIndex: u32) void;
    pub extern fn wgpuComputePassEncoderEndPipelineStatisticsQuery(computePassEncoder: ComputePassEncoder) void;
};

pub fn createInstance(descriptor: ?InstanceDescriptor) Instance {
    return cdef.wgpuCreateInstance(if (descriptor) |d| &d else null);
}

fn defaultAdapterCallback(
    status: RequestAdapterStatus,
    adapter: Adapter,
    message: [*:0]const u8,
    userdata: ?*anyopaque,
) callconv(.C) void {
    const ud_response: *RequestAdapterResponse = @ptrCast(@alignCast(userdata));
    ud_response.* = .{ .status = status, .message = message, .adapter = adapter };
}

pub fn instanceRequestAdapter(instance: Instance, options: ?RequestAdapterOptions) error{ Unavailable, Error, Unknown }!Adapter {
    var response: RequestAdapterResponse = undefined;
    instance.requestAdapterAsync(options, defaultAdapterCallback, &response);

    if (response.status != .success) {
        std.log.err("WebGPU error: {s} {s}", .{ @tagName(response.status), response.message });
        return switch (response.status) {
            .success => unreachable,
            .@"error" => error.Error,
            .unknown => error.Unknown,
            .unavailable => error.Unavailable,
        };
    }
    return response.adapter;
}

pub fn adapterEnumerateFeatures(adapter: Adapter, alloc: Allocator) Allocator.Error![]FeatureName {
    const count = cdef.wgpuAdapterEnumerateFeatures(adapter, null);
    const features = try alloc.alloc(FeatureName, count);
    _ = cdef.wgpuAdapterEnumerateFeatures(adapter, @ptrCast(features));
    return features;
}

pub fn adapterGetLimits(adapter: Adapter) ?SupportedLimits {
    var limits = SupportedLimits{};
    if (cdef.wgpuAdapterGetLimits(adapter, &limits) == .true) {
        return limits;
    }
    return null;
}

pub fn adapterGetInfo(adapter: Adapter) AdapterInfo {
    var info = AdapterInfo{};
    cdef.wgpuAdapterGetInfo(adapter, &info);
    return info;
}

pub fn adapterHasFeature(adapter: Adapter, feature: FeatureName) bool {
    return cdef.wgpuAdapterHasFeature(adapter, feature) == .true;
}

pub fn adapterRequestDeviceAsync(adapter: Adapter, descriptor: ?DeviceDescriptor, callback: AdapterRequestDeviceCallback, userdata: ?*const anyopaque) void {
    cdef.wgpuAdapterRequestDevice(adapter, if (descriptor) |d| &d else null, callback, userdata);
}

fn defaultDeviceCallback(
    status: RequestDeviceStatus,
    device: Device,
    message: [*:0]const u8,
    userdata: ?*anyopaque,
) callconv(.C) void {
    const ud_response: *RequestDeviceResponse = @ptrCast(@alignCast(userdata));
    ud_response.* = .{ .status = status, .message = message, .device = device };
}

pub fn adapterRequestDevice(adapter: Adapter, descriptor: ?DeviceDescriptor) error{ Error, Unknown }!Device {
    var response: RequestDeviceResponse = undefined;
    adapter.requestDeviceAsync(descriptor, defaultDeviceCallback, &response);

    if (response.status != .success) {
        std.log.err("WebGPU error: {s} {s}", .{ @tagName(response.status), response.message });
        return switch (response.status) {
            .success => unreachable,
            .@"error" => error.Error,
            .unknown => error.Unknown,
        };
    }
    return response.device;
}

pub fn bufferGetConstMappedRange(buffer: Buffer, offset: usize, size: usize) []const u8 {
    return cdef.wgpuBufferGetConstMappedRange(buffer, offset, size)[0..size];
}

pub fn bufferGetMappedRange(buffer: Buffer, offset: usize, size: usize) []u8 {
    return cdef.wgpuBufferGetMappedRange(buffer, offset, size)[0..size];
}

pub fn commandEncoderBeginComputePass(encoder: CommandEncoder, descriptor: ?ComputePassDescriptor) ComputePassEncoder {
    return cdef.wgpuCommandEncoderBeginComputePass(encoder, if (descriptor) |d| &d else null);
}

pub fn commandEncoderBeginRenderPass(encoder: CommandEncoder, descriptor: RenderPassDescriptor) RenderPassEncoder {
    return cdef.wgpuCommandEncoderBeginRenderPass(encoder, &descriptor);
}

pub fn commandEncoderCopyBufferToTexture(encoder: CommandEncoder, source: ImageCopyBuffer, destination: ImageCopyTexture, copySize: Extent3D) void {
    cdef.wgpuCommandEncoderCopyBufferToTexture(encoder, &source, &destination, &copySize);
}

pub fn commandEncoderCopyTextureToBuffer(encoder: CommandEncoder, source: ImageCopyTexture, destination: ImageCopyBuffer, copySize: Extent3D) void {
    cdef.wgpuCommandEncoderCopyTextureToBuffer(encoder, &source, &destination, &copySize);
}

pub fn commandEncoderCopyTextureToTexture(encoder: CommandEncoder, source: ImageCopyTexture, destination: ImageCopyTexture, copySize: Extent3D) void {
    cdef.wgpuCommandEncoderCopyTextureToTexture(encoder, &source, &destination, &copySize);
}

pub fn commandEncoderFinish(encoder: CommandEncoder, descriptor: ?CommandBufferDescriptor) CommandBuffer {
    return cdef.wgpuCommandEncoderFinish(encoder, if (descriptor) |d| &d else null);
}

pub fn deviceCreateBindGroup(device: Device, descriptor: BindGroupDescriptor) BindGroup {
    return cdef.wgpuDeviceCreateBindGroup(device, &descriptor);
}

pub fn deviceCreateBindGroupLayout(device: Device, descriptor: BindGroupLayoutDescriptor) BindGroupLayout {
    return cdef.wgpuDeviceCreateBindGroupLayout(device, &descriptor);
}

pub fn deviceCreateBuffer(device: Device, descriptor: BufferDescriptor) Buffer {
    return cdef.wgpuDeviceCreateBuffer(device, &descriptor);
}

pub fn deviceCreateCommandEncoder(device: Device, descriptor: ?CommandEncoderDescriptor) CommandEncoder {
    return cdef.wgpuDeviceCreateCommandEncoder(device, if (descriptor) |d| &d else null);
}

pub fn deviceCreateComputePipeline(device: Device, descriptor: ComputePipelineDescriptor) ComputePipeline {
    return cdef.wgpuDeviceCreateComputePipeline(device, &descriptor);
}

pub fn deviceCreateComputePipelineAsync(device: Device, descriptor: ComputePipelineDescriptor, callback: DeviceCreateComputePipelineAsyncCallback, userdata: ?*const anyopaque) void {
    return cdef.wgpuDeviceCreateComputePipelineAsync(device, &descriptor, callback, userdata);
}

pub fn deviceCreatePipelineLayout(device: Device, descriptor: PipelineLayoutDescriptor) PipelineLayout {
    return cdef.wgpuDeviceCreatePipelineLayout(device, &descriptor);
}

pub fn deviceCreateQuerySet(device: Device, descriptor: QuerySetDescriptor) QuerySet {
    return cdef.wgpuDeviceCreateQuerySet(device, &descriptor);
}

pub fn deviceCreateRenderBundleEncoder(device: Device, descriptor: RenderBundleEncoderDescriptor) RenderBundleEncoder {
    return cdef.wgpuDeviceCreateRenderBundleEncoder(device, &descriptor);
}

pub fn deviceCreateRenderPipeline(device: Device, descriptor: RenderPipelineDescriptor) RenderPipeline {
    return cdef.wgpuDeviceCreateRenderPipeline(device, &descriptor);
}

pub fn deviceCreateRenderPipelineAsync(device: Device, descriptor: RenderPipelineDescriptor, callback: DeviceCreateRenderPipelineAsyncCallback, userdata: ?*const anyopaque) void {
    return cdef.wgpuDeviceCreateRenderPipelineAsync(device, &descriptor, callback, userdata);
}

pub fn deviceCreateSampler(device: Device, descriptor: ?SamplerDescriptor) Sampler {
    return cdef.wgpuDeviceCreateSampler(device, if (descriptor) |d| &d else null);
}

pub fn deviceCreateShaderModule(device: Device, descriptor: ShaderModuleDescriptor) ShaderModule {
    return cdef.wgpuDeviceCreateShaderModule(device, &descriptor);
}

pub fn deviceCreateTexture(device: Device, descriptor: TextureDescriptor) Texture {
    return cdef.wgpuDeviceCreateTexture(device, &descriptor);
}

pub fn deviceDestroy(device: Device) void {
    cdef.wgpuDeviceDestroy(device);
}

pub fn deviceEnumerateFeatures(device: Device, alloc: Allocator) Allocator.Error![]FeatureName {
    const count = cdef.wgpuDeviceEnumerateFeatures(device, null);
    const features = try alloc.alloc(FeatureName, count);
    _ = cdef.wgpuDeviceEnumerateFeatures(device, @ptrCast(features));
    return features;
}

pub fn deviceGetLimits(device: Device) ?SupportedLimits {
    var limits = SupportedLimits{};
    if (cdef.wgpuDeviceGetLimits(device, &limits) == .true) {
        return limits;
    }
    return null;
}

pub fn deviceHasFeature(device: Device, feature: FeatureName) bool {
    return cdef.wgpuDeviceHasFeature(device, feature) != .false;
}

pub fn instanceCreateSurface(instance: Instance, descriptor: SurfaceDescriptor) Surface {
    return cdef.wgpuInstanceCreateSurface(instance, &descriptor);
}

pub fn instanceHasWGSLLanguageFeature(instance: Instance, feature: WGSLFeatureName) bool {
    return cdef.wgpuInstanceHasWGSLLanguageFeature(instance, feature) == .true;
}

pub fn instanceRequestAdapterAsync(instance: Instance, options: ?RequestAdapterOptions, callback: InstanceRequestAdapterCallback, userdata: ?*const anyopaque) void {
    cdef.wgpuInstanceRequestAdapter(instance, if (options) |o| &o else null, callback, userdata);
}

pub fn queueSubmit(queue: Queue, commands: []const CommandBuffer) void {
    cdef.wgpuQueueSubmit(queue, commands.len, commands.ptr);
}

pub fn queueWriteBuffer(queue: Queue, buffer: Buffer, bufferOffset: u64, data: []const u8) void {
    cdef.wgpuQueueWriteBuffer(queue, buffer, bufferOffset, data.ptr, data.len);
}

pub fn queueWriteTexture(queue: Queue, destination: ImageCopyTexture, data: []const u8, dataLayout: TextureDataLayout, writeSize: Extent3D) void {
    cdef.wgpuQueueWriteTexture(queue, &destination, data.ptr, data.len, &dataLayout, &writeSize);
}

pub fn renderBundleEncoderFinish(encoder: RenderBundleEncoder, descriptor: ?RenderBundleDescriptor) RenderBundle {
    return cdef.wgpuRenderBundleEncoderFinish(encoder, if (descriptor) |d| &d else null);
}

pub fn renderBundleEncoderSetBindGroup(encoder: RenderBundleEncoder, groupIndex: u32, group: ?BindGroup, dynamicOffsets: []const u32) void {
    cdef.wgpuRenderBundleEncoderSetBindGroup(encoder, groupIndex, group, dynamicOffsets.len, dynamicOffsets.ptr);
}

pub fn renderPassExecuteBundles(encoder: RenderPassEncoder, bundles: []const RenderBundle) void {
    cdef.wgpuRenderPassEncoderExecuteBundles(encoder, bundles.len, bundles.ptr);
}

pub fn renderPassSetBindGroup(encoder: RenderPassEncoder, groupIndex: u32, group: ?BindGroup, dynamicOffsets: []const u32) void {
    cdef.wgpuRenderPassEncoderSetBindGroup(encoder, groupIndex, group, dynamicOffsets.len, dynamicOffsets.ptr);
}

pub fn renderPassSetBlendConstant(encoder: RenderPassEncoder, color_: Color) void {
    cdef.wgpuRenderPassEncoderSetBlendConstant(encoder, &color_);
}

pub fn surfaceConfigure(surface: Surface, config: SurfaceConfiguration) void {
    cdef.wgpuSurfaceConfigure(surface, &config);
}

pub fn surfaceGetCapabilities(surface: Surface, adapter: Adapter) SurfaceCapabilities {
    var capabilities = SurfaceCapabilities{};
    cdef.wgpuSurfaceGetCapabilities(surface, adapter, &capabilities);
    return capabilities;
}

pub fn surfaceGetCurrentTexture(surface: Surface) SurfaceTexture {
    var texture = SurfaceTexture{};
    cdef.wgpuSurfaceGetCurrentTexture(surface, &texture);
    return texture;
}

pub fn textureCreateView(texture: Texture, descriptor: ?TextureViewDescriptor) TextureView {
    return cdef.wgpuTextureCreateView(texture, if (descriptor) |d| &d else null);
}

pub fn devicePoll(device: Device, wait: bool, wrappedSubmissionIndex: ?WrappedSubmissionIndex) bool {
    return cdef.wgpuDevicePoll(device, if (wait) .true else .false, if (wrappedSubmissionIndex) |i| &i else null) == .true;
}

pub fn generateReport(instance: Instance) GlobalReport {
    var report = GlobalReport{};
    cdef.wgpuGenerateReport(instance, &report);
    return report;
}

pub fn instanceEnumerateAdapters(instance: Instance, alloc: Allocator, options: ?InstanceEnumerateAdapterOptions) []Adapter {
    const count = cdef.wgpuInstanceEnumerateAdapters(instance, if (options) |o| &o else null, null);
    const adapters = try alloc.alloc(Adapter, count);
    _ = cdef.wgpuInstanceEnumerateAdapters(instance, if (options) |o| &o else null, @ptrCast(adapters));
    return adapters;
}

pub fn queueSubmitForIndex(queue: Queue, commands: []const CommandBuffer) SubmissionIndex {
    return cdef.wgpuQueueSubmitForIndex(queue, commands.len, commands.ptr);
}

pub fn renderPassSetPushConstants(encoder: RenderPassEncoder, stages: ShaderStageFlags, offset: u32, data: []const u8) void {
    cdef.wgpuRenderPassEncoderSetPushConstants(encoder, stages, offset, @intCast(data.len), data.ptr);
}

pub const adapterInfoFreeMembers = cdef.wgpuAdapterInfoFreeMembers;
pub const adapterReference = cdef.wgpuAdapterReference;
pub const adapterRelease = cdef.wgpuAdapterRelease;
pub const bindGroupLayoutReference = cdef.wgpuBindGroupLayoutReference;
pub const bindGroupLayoutRelease = cdef.wgpuBindGroupLayoutRelease;
pub const bindGroupLayoutSetLabel = cdef.wgpuBindGroupLayoutSetLabel;
pub const bindGroupReference = cdef.wgpuBindGroupReference;
pub const bindGroupRelease = cdef.wgpuBindGroupRelease;
pub const bindGroupSetLabel = cdef.wgpuBindGroupSetLabel;
pub const bufferDestroy = cdef.wgpuBufferDestroy;
pub const bufferGetMapState = cdef.wgpuBufferGetMapState;
pub const bufferGetSize = cdef.wgpuBufferGetSize;
pub const bufferGetUsage = cdef.wgpuBufferGetUsage;
pub const bufferMapAsync = cdef.wgpuBufferMapAsync;
pub const bufferReference = cdef.wgpuBufferReference;
pub const bufferRelease = cdef.wgpuBufferRelease;
pub const bufferSetLabel = cdef.wgpuBufferSetLabel;
pub const bufferUnmap = cdef.wgpuBufferUnmap;
pub const commandBufferReference = cdef.wgpuCommandBufferReference;
pub const commandBufferRelease = cdef.wgpuCommandBufferRelease;
pub const commandBufferSetLabel = cdef.wgpuCommandBufferSetLabel;
pub const commandEncoderCopyBufferToBuffer = cdef.wgpuCommandEncoderCopyBufferToBuffer;
pub const commandEncoderInsertDebugMarker = cdef.wgpuCommandEncoderInsertDebugMarker;
pub const commandEncoderPopDebugGroup = cdef.wgpuCommandEncoderPopDebugGroup;
pub const commandEncoderPushDebugGroup = cdef.wgpuCommandEncoderPushDebugGroup;
pub const commandEncoderReference = cdef.wgpuCommandEncoderReference;
pub const commandEncoderRelease = cdef.wgpuCommandEncoderRelease;
pub const commandEncoderResolveQuerySet = cdef.wgpuCommandEncoderResolveQuerySet;
pub const commandEncoderSetLabel = cdef.wgpuCommandEncoderSetLabel;
pub const commandEncoderWriteTimestamp = cdef.wgpuCommandEncoderWriteTimestamp;
pub const computePassDispatchWorkgroups = cdef.wgpuComputePassEncoderDispatchWorkgroups;
pub const computePassDispatchWorkgroupsIndirect = cdef.wgpuComputePassEncoderDispatchWorkgroupsIndirect;
pub const computePassEnd = cdef.wgpuComputePassEncoderEnd;
pub const computePassInsertDebugMarker = cdef.wgpuComputePassEncoderInsertDebugMarker;
pub const computePassPopDebugGroup = cdef.wgpuComputePassEncoderPopDebugGroup;
pub const computePassPushDebugGroup = cdef.wgpuComputePassEncoderPushDebugGroup;
pub const computePassReference = cdef.wgpuComputePassEncoderReference;
pub const computePassRelease = cdef.wgpuComputePassEncoderRelease;
pub const computePassSetBindGroup = cdef.wgpuComputePassEncoderSetBindGroup;
pub const computePassSetLabel = cdef.wgpuComputePassEncoderSetLabel;
pub const computePassSetPipeline = cdef.wgpuComputePassEncoderSetPipeline;
pub const computePipelineGetBindGroupLayout = cdef.wgpuComputePipelineGetBindGroupLayout;
pub const computePipelineReference = cdef.wgpuComputePipelineReference;
pub const computePipelineRelease = cdef.wgpuComputePipelineRelease;
pub const computePipelineSetLabel = cdef.wgpuComputePipelineSetLabel;
pub const deviceGetQueue = cdef.wgpuDeviceGetQueue;
pub const devicePopErrorScope = cdef.wgpuDevicePopErrorScope;
pub const devicePushErrorScope = cdef.wgpuDevicePushErrorScope;
pub const deviceReference = cdef.wgpuDeviceReference;
pub const deviceRelease = cdef.wgpuDeviceRelease;
pub const deviceSetLabel = cdef.wgpuDeviceSetLabel;
pub const getProcAddress = cdef.wgpuGetProcAddress;
pub const instanceProcessEvents = cdef.wgpuInstanceProcessEvents;
pub const instanceReference = cdef.wgpuInstanceReference;
pub const instanceRelease = cdef.wgpuInstanceRelease;
pub const pipelineLayoutReference = cdef.wgpuPipelineLayoutReference;
pub const pipelineLayoutRelease = cdef.wgpuPipelineLayoutRelease;
pub const pipelineLayoutSetLabel = cdef.wgpuPipelineLayoutSetLabel;
pub const querySetDestroy = cdef.wgpuQuerySetDestroy;
pub const querySetGetCount = cdef.wgpuQuerySetGetCount;
pub const querySetGetType = cdef.wgpuQuerySetGetType;
pub const querySetReference = cdef.wgpuQuerySetReference;
pub const querySetRelease = cdef.wgpuQuerySetRelease;
pub const querySetSetLabel = cdef.wgpuQuerySetSetLabel;
pub const queueOnSubmittedWorkDone = cdef.wgpuQueueOnSubmittedWorkDone;
pub const queueReference = cdef.wgpuQueueReference;
pub const queueRelease = cdef.wgpuQueueRelease;
pub const queueSetLabel = cdef.wgpuQueueSetLabel;
pub const renderBundleEncoderDraw = cdef.wgpuRenderBundleEncoderDraw;
pub const renderBundleEncoderDrawIndexed = cdef.wgpuRenderBundleEncoderDrawIndexed;
pub const renderBundleEncoderDrawIndexedIndirect = cdef.wgpuRenderBundleEncoderDrawIndexedIndirect;
pub const renderBundleEncoderDrawIndirect = cdef.wgpuRenderBundleEncoderDrawIndirect;
pub const renderBundleEncoderInsertDebugMarker = cdef.wgpuRenderBundleEncoderInsertDebugMarker;
pub const renderBundleEncoderPopDebugGroup = cdef.wgpuRenderBundleEncoderPopDebugGroup;
pub const renderBundleEncoderPushDebugGroup = cdef.wgpuRenderBundleEncoderPushDebugGroup;
pub const renderBundleEncoderReference = cdef.wgpuRenderBundleEncoderReference;
pub const renderBundleEncoderRelease = cdef.wgpuRenderBundleEncoderRelease;
pub const renderBundleEncoderSetIndexBuffer = cdef.wgpuRenderBundleEncoderSetIndexBuffer;
pub const renderBundleEncoderSetLabel = cdef.wgpuRenderBundleEncoderSetLabel;
pub const renderBundleEncoderSetPipeline = cdef.wgpuRenderBundleEncoderSetPipeline;
pub const renderBundleEncoderSetVertexBuffer = cdef.wgpuRenderBundleEncoderSetVertexBuffer;
pub const renderBundleReference = cdef.wgpuRenderBundleReference;
pub const renderBundleRelease = cdef.wgpuRenderBundleRelease;
pub const renderBundleSetLabel = cdef.wgpuRenderBundleSetLabel;
pub const renderPassBeginOcclusionQuery = cdef.wgpuRenderPassEncoderBeginOcclusionQuery;
pub const renderPassDraw = cdef.wgpuRenderPassEncoderDraw;
pub const renderPassDrawIndexed = cdef.wgpuRenderPassEncoderDrawIndexed;
pub const renderPassDrawIndexedIndirect = cdef.wgpuRenderPassEncoderDrawIndexedIndirect;
pub const renderPassDrawIndirect = cdef.wgpuRenderPassEncoderDrawIndirect;
pub const renderPassEnd = cdef.wgpuRenderPassEncoderEnd;
pub const renderPassEndOcclusionQuery = cdef.wgpuRenderPassEncoderEndOcclusionQuery;
pub const renderPassInsertDebugMarker = cdef.wgpuRenderPassEncoderInsertDebugMarker;
pub const renderPassPopDebugGroup = cdef.wgpuRenderPassEncoderPopDebugGroup;
pub const renderPassPushDebugGroup = cdef.wgpuRenderPassEncoderPushDebugGroup;
pub const renderPassReference = cdef.wgpuRenderPassEncoderReference;
pub const renderPassRelease = cdef.wgpuRenderPassEncoderRelease;
pub const renderPassSetIndexBuffer = cdef.wgpuRenderPassEncoderSetIndexBuffer;
pub const renderPassSetLabel = cdef.wgpuRenderPassEncoderSetLabel;
pub const renderPassSetPipeline = cdef.wgpuRenderPassEncoderSetPipeline;
pub const renderPassSetScissorRect = cdef.wgpuRenderPassEncoderSetScissorRect;
pub const renderPassSetStencilReference = cdef.wgpuRenderPassEncoderSetStencilReference;
pub const renderPassSetVertexBuffer = cdef.wgpuRenderPassEncoderSetVertexBuffer;
pub const renderPassSetViewport = cdef.wgpuRenderPassEncoderSetViewport;
pub const renderPipelineGetBindGroupLayout = cdef.wgpuRenderPipelineGetBindGroupLayout;
pub const renderPipelineReference = cdef.wgpuRenderPipelineReference;
pub const renderPipelineRelease = cdef.wgpuRenderPipelineRelease;
pub const renderPipelineSetLabel = cdef.wgpuRenderPipelineSetLabel;
pub const samplerReference = cdef.wgpuSamplerReference;
pub const samplerRelease = cdef.wgpuSamplerRelease;
pub const samplerSetLabel = cdef.wgpuSamplerSetLabel;
pub const shaderModuleGetCompilationInfo = cdef.wgpuShaderModuleGetCompilationInfo;
pub const shaderModuleReference = cdef.wgpuShaderModuleReference;
pub const shaderModuleRelease = cdef.wgpuShaderModuleRelease;
pub const shaderModuleSetLabel = cdef.wgpuShaderModuleSetLabel;
pub const surfacePresent = cdef.wgpuSurfacePresent;
pub const surfaceReference = cdef.wgpuSurfaceReference;
pub const surfaceRelease = cdef.wgpuSurfaceRelease;
pub const surfaceSetLabel = cdef.wgpuSurfaceSetLabel;
pub const surfaceUnconfigure = cdef.wgpuSurfaceUnconfigure;
pub const textureDestroy = cdef.wgpuTextureDestroy;
pub const textureGetDepthOrArrayLayers = cdef.wgpuTextureGetDepthOrArrayLayers;
pub const textureGetDimension = cdef.wgpuTextureGetDimension;
pub const textureGetFormat = cdef.wgpuTextureGetFormat;
pub const textureGetHeight = cdef.wgpuTextureGetHeight;
pub const textureGetMipLevelCount = cdef.wgpuTextureGetMipLevelCount;
pub const textureGetSampleCount = cdef.wgpuTextureGetSampleCount;
pub const textureGetUsage = cdef.wgpuTextureGetUsage;
pub const textureGetWidth = cdef.wgpuTextureGetWidth;
pub const textureReference = cdef.wgpuTextureReference;
pub const textureRelease = cdef.wgpuTextureRelease;
pub const textureSetLabel = cdef.wgpuTextureSetLabel;
pub const textureViewReference = cdef.wgpuTextureViewReference;
pub const textureViewRelease = cdef.wgpuTextureViewRelease;
pub const textureViewSetLabel = cdef.wgpuTextureViewSetLabel;
pub const surfaceCapabilitiesFreeMembers = cdef.wgpuSurfaceCapabilitiesFreeMembers;

// wgpu-native extras (wgpu.h)
pub const computePassBeginPipelineStatisticsQuery = cdef.wgpuComputePassEncoderBeginPipelineStatisticsQuery;
pub const computePassEndPipelineStatisticsQuery = cdef.wgpuComputePassEncoderEndPipelineStatisticsQuery;
pub const setLogCallback = cdef.wgpuSetLogCallback;
pub const setLogLevel = cdef.wgpuSetLogLevel;
pub const getVersion = cdef.wgpuGetVersion;

pub const Adapter = *opaque {
    pub const enumerateFeatures = wgpu.adapterEnumerateFeatures;
    pub const getInfo = wgpu.adapterGetInfo;
    pub const getLimits = wgpu.adapterGetLimits;
    pub const hasFeature = wgpu.adapterHasFeature;
    pub const reference = wgpu.adapterReference;
    pub const release = wgpu.adapterRelease;
    pub const requestDevice = wgpu.adapterRequestDevice;
    pub const requestDeviceAsync = wgpu.adapterRequestDeviceAsync;
};

pub const BindGroup = *opaque {
    pub const reference = wgpu.bindGroupReference;
    pub const release = wgpu.bindGroupRelease;
    pub const setLabel = wgpu.bindGroupSetLabel;
};

pub const BindGroupLayout = *opaque {
    pub const reference = wgpu.bindGroupLayoutReference;
    pub const release = wgpu.bindGroupLayoutRelease;
    pub const setLabel = wgpu.bindGroupLayoutSetLabel;
};

pub const Buffer = *opaque {
    pub const destroy = wgpu.bufferDestroy;
    pub const getMapState = wgpu.bufferGetMapState;
    pub const getSize = wgpu.bufferGetSize;
    pub const getUsage = wgpu.bufferGetUsage;
    pub const mapAsync = wgpu.bufferMapAsync;
    pub const reference = wgpu.bufferReference;
    pub const release = wgpu.bufferRelease;
    pub const setLabel = wgpu.bufferSetLabel;
    pub const unmap = wgpu.bufferUnmap;
};

pub const CommandBuffer = *opaque {
    pub const reference = wgpu.commandBufferReference;
    pub const release = wgpu.commandBufferRelease;
    pub const setLabel = wgpu.commandBufferSetLabel;
};

pub const CommandEncoder = *opaque {
    pub const beginComputePass = wgpu.commandEncoderBeginComputePass;
    pub const beginRenderPass = wgpu.commandEncoderBeginRenderPass;
    pub const copyBufferToBuffer = wgpu.commandEncoderCopyBufferToBuffer;
    pub const copyBufferToTexture = wgpu.commandEncoderCopyBufferToTexture;
    pub const copyTextureToBuffer = wgpu.commandEncoderCopyTextureToBuffer;
    pub const copyTextureToTexture = wgpu.commandEncoderCopyTextureToTexture;
    pub const finish = wgpu.commandEncoderFinish;
    pub const insertDebugMarker = wgpu.commandEncoderInsertDebugMarker;
    pub const popDebugGroup = wgpu.commandEncoderPopDebugGroup;
    pub const pushDebugGroup = wgpu.commandEncoderPushDebugGroup;
    pub const reference = wgpu.commandEncoderReference;
    pub const release = wgpu.commandEncoderRelease;
    pub const resolveQuerySet = wgpu.commandEncoderResolveQuerySet;
    pub const setLabel = wgpu.commandEncoderSetLabel;
    pub const writeTimestamp = wgpu.commandEncoderWriteTimestamp;
};

pub const ComputePassEncoder = *opaque {
    pub const dispatchWorkgroups = wgpu.computePassDispatchWorkgroups;
    pub const dispatchWorkgroupsIndirect = wgpu.computePassDispatchWorkgroupsIndirect;
    pub const end = wgpu.computePassEnd;
    pub const insertDebugMarker = wgpu.computePassInsertDebugMarker;
    pub const popDebugGroup = wgpu.computePassPopDebugGroup;
    pub const pushDebugGroup = wgpu.computePassPushDebugGroup;
    pub const reference = wgpu.computePassReference;
    pub const release = wgpu.computePassRelease;
    pub const setBindGroup = wgpu.computePassSetBindGroup;
    pub const setLabel = wgpu.computePassSetLabel;
    pub const setPipeline = wgpu.computePassSetPipeline;

    // wgpu-native extras (wgpu.h)
    pub const beginPipelineStatisticsQuery = wgpu.computePassBeginPipelineStatisticsQuery;
    pub const endPipelineStatisticsQuery = wgpu.computePassEndPipelineStatisticsQuery;
};

pub const ComputePipeline = *opaque {
    pub const getBindGroupLayout = wgpu.computePipelineGetBindGroupLayout;
    pub const reference = wgpu.computePipelineReference;
    pub const release = wgpu.computePipelineRelease;
    pub const setLabel = wgpu.computePipelineSetLabel;
};

pub const Device = *opaque {
    pub const createBindGroup = wgpu.deviceCreateBindGroup;
    pub const createBindGroupLayout = wgpu.deviceCreateBindGroupLayout;
    pub const createBuffer = wgpu.deviceCreateBuffer;
    pub const createCommandEncoder = wgpu.deviceCreateCommandEncoder;
    pub const createComputePipeline = wgpu.deviceCreateComputePipeline;
    pub const createComputePipelineAsync = wgpu.deviceCreateComputePipelineAsync;
    pub const createPipelineLayout = wgpu.deviceCreatePipelineLayout;
    pub const createQuerySet = wgpu.deviceCreateQuerySet;
    pub const createRenderBundleEncoder = wgpu.deviceCreateRenderBundleEncoder;
    pub const createRenderPipeline = wgpu.deviceCreateRenderPipeline;
    pub const createRenderPipelineAsync = wgpu.deviceCreateRenderPipelineAsync;
    pub const createSampler = wgpu.deviceCreateSampler;
    pub const createShaderModule = wgpu.deviceCreateShaderModule;
    pub const createTexture = wgpu.deviceCreateTexture;
    pub const destroy = wgpu.deviceDestroy;
    pub const enumerateFeatures = wgpu.deviceEnumerateFeatures;
    pub const getLimits = wgpu.deviceGetLimits;
    pub const getProcAddress = wgpu.getProcAddress;
    pub const getQueue = wgpu.deviceGetQueue;
    pub const hasFeature = wgpu.deviceHasFeature;
    pub const popErrorScope = wgpu.devicePopErrorScope;
    pub const pushErrorScope = wgpu.devicePushErrorScope;
    pub const reference = wgpu.deviceReference;
    pub const release = wgpu.deviceRelease;
    pub const setLabel = wgpu.deviceSetLabel;

    // wgpu-native extras (wgpu.h)
    pub const poll = wgpu.devicePoll;
};

pub const Instance = *opaque {
    pub const createSurface = wgpu.instanceCreateSurface;
    pub const hasWGSLLanguageFeature = wgpu.instanceHasWGSLLanguageFeature;
    pub const processEvents = wgpu.instanceProcessEvents;
    pub const reference = wgpu.instanceReference;
    pub const release = wgpu.instanceRelease;
    pub const requestAdapter = wgpu.instanceRequestAdapter;
    pub const requestAdapterAsync = wgpu.instanceRequestAdapterAsync;

    // wgpu-native extras (wgpu.h)
    pub const generateReport = wgpu.generateReport;
    pub const enumerateAdapters = wgpu.instanceEnumerateAdapters;
};

pub const PipelineLayout = *opaque {
    pub const reference = wgpu.pipelineLayoutReference;
    pub const release = wgpu.pipelineLayoutRelease;
    pub const setLabel = wgpu.pipelineLayoutSetLabel;
};

pub const QuerySet = *opaque {
    pub const destroy = wgpu.querySetDestroy;
    pub const getCount = wgpu.querySetGetCount;
    pub const getType = wgpu.querySetGetType;
    pub const reference = wgpu.querySetReference;
    pub const release = wgpu.querySetRelease;
    pub const setLabel = wgpu.querySetSetLabel;
};

pub const Queue = *opaque {
    pub const onSubmittedWorkDone = wgpu.queueOnSubmittedWorkDone;
    pub const reference = wgpu.queueReference;
    pub const release = wgpu.queueRelease;
    pub const setLabel = wgpu.queueSetLabel;
    pub const submit = wgpu.queueSubmit;
    pub const writeBuffer = wgpu.queueWriteBuffer;
    pub const writeTexture = wgpu.queueWriteTexture;

    // wgpu-native extras (wgpu.h)
    pub const submitForIndex = wgpu.queueSubmitForIndex;
};

pub const RenderBundle = *opaque {
    pub const reference = wgpu.renderBundleReference;
    pub const release = wgpu.renderBundleRelease;
    pub const setLabel = wgpu.renderBundleSetLabel;
};

pub const RenderBundleEncoder = *opaque {
    pub const draw = wgpu.renderBundleEncoderDraw;
    pub const drawIndexed = wgpu.renderBundleEncoderDrawIndexed;
    pub const drawIndexedIndirect = wgpu.renderBundleEncoderDrawIndexedIndirect;
    pub const drawIndirect = wgpu.renderBundleEncoderDrawIndirect;
    pub const finish = wgpu.renderBundleEncoderFinish;
    pub const insertDebugMarker = wgpu.renderBundleEncoderInsertDebugMarker;
    pub const popDebugGroup = wgpu.renderBundleEncoderPopDebugGroup;
    pub const pushDebugGroup = wgpu.renderBundleEncoderPushDebugGroup;
    pub const reference = wgpu.renderBundleEncoderReference;
    pub const release = wgpu.renderBundleEncoderRelease;
    pub const setBindGroup = wgpu.renderBundleEncoderSetBindGroup;
    pub const setIndexBuffer = wgpu.renderBundleEncoderSetIndexBuffer;
    pub const setLabel = wgpu.renderBundleEncoderSetLabel;
    pub const setPipeline = wgpu.renderBundleEncoderSetPipeline;
    pub const setVertexBuffer = wgpu.renderBundleEncoderSetVertexBuffer;
};

pub const RenderPassEncoder = *opaque {
    pub const beginOcclusionQuery = wgpu.renderPassBeginOcclusionQuery;
    pub const draw = wgpu.renderPassDraw;
    pub const drawIndexed = wgpu.renderPassDrawIndexed;
    pub const drawIndexedIndirect = wgpu.renderPassDrawIndexedIndirect;
    pub const drawIndirect = wgpu.renderPassDrawIndirect;
    pub const end = wgpu.renderPassEnd;
    pub const endOcclusionQuery = wgpu.renderPassEndOcclusionQuery;
    pub const executeBundles = wgpu.renderPassExecuteBundles;
    pub const insertDebugMarker = wgpu.renderPassInsertDebugMarker;
    pub const popDebugGroup = wgpu.renderPassPopDebugGroup;
    pub const pushDebugGroup = wgpu.renderPassPushDebugGroup;
    pub const reference = wgpu.renderPassReference;
    pub const release = wgpu.renderPassRelease;
    pub const setBindGroup = wgpu.renderPassSetBindGroup;
    pub const setBlendConstant = wgpu.renderPassSetBlendConstant;
    pub const setIndexBuffer = wgpu.renderPassSetIndexBuffer;
    pub const setLabel = wgpu.renderPassSetLabel;
    pub const setPipeline = wgpu.renderPassSetPipeline;
    pub const setScissorRect = wgpu.renderPassSetScissorRect;
    pub const setStencilReference = wgpu.renderPassSetStencilReference;
    pub const setVertexBuffer = wgpu.renderPassSetVertexBuffer;
    pub const setViewport = wgpu.renderPassSetViewport;

    // wgpu-native extras (wgpu.h)
    pub const beginPipelineStatisticsQuery = cdef.wgpuRenderPassEncoderBeginPipelineStatisticsQuery;
    pub const endPipelineStatisticsQuery = cdef.wgpuRenderPassEncoderEndPipelineStatisticsQuery;
    pub const multiDrawIndexedIndirect = cdef.wgpuRenderPassEncoderMultiDrawIndexedIndirectCount;
    pub const multiDrawIndexedIndirectCount = cdef.wgpuRenderPassEncoderMultiDrawIndexedIndirectCount;
    pub const multiDrawIndirect = cdef.wgpuRenderPassEncoderMultiDrawIndirectCount;
    pub const multiDrawIndirectCount = cdef.wgpuRenderPassEncoderMultiDrawIndirectCount;
    pub const setPushConstants = wgpu.renderPassSetPushConstants;
};

pub const RenderPipeline = *opaque {
    pub const getBindGroupLayout = wgpu.renderPipelineGetBindGroupLayout;
    pub const reference = wgpu.renderPipelineReference;
    pub const release = wgpu.renderPipelineRelease;
    pub const setLabel = wgpu.renderPipelineSetLabel;
};

pub const Sampler = *opaque {
    pub const reference = wgpu.samplerReference;
    pub const release = wgpu.samplerRelease;
    pub const setLabel = wgpu.samplerSetLabel;
};

pub const ShaderModule = *opaque {
    pub const getCompilationInfo = wgpu.shaderModuleGetCompilationInfo;
    pub const reference = wgpu.shaderModuleReference;
    pub const release = wgpu.shaderModuleRelease;
    pub const setLabel = wgpu.shaderModuleSetLabel;
};

pub const Surface = *opaque {
    pub const configure = wgpu.surfaceConfigure;
    pub const getCapabilities = wgpu.surfaceGetCapabilities;
    pub const getCurrentTexture = wgpu.surfaceGetCurrentTexture;
    pub const present = wgpu.surfacePresent;
    pub const reference = wgpu.surfaceReference;
    pub const release = wgpu.surfaceRelease;
    pub const setLabel = wgpu.surfaceSetLabel;
    pub const unconfigure = wgpu.surfaceUnconfigure;
};

pub const Texture = *opaque {
    pub const createView = wgpu.textureCreateView;
    pub const destroy = wgpu.textureDestroy;
    pub const getDepthOrArrayLayers = wgpu.textureGetDepthOrArrayLayers;
    pub const getDimension = wgpu.textureGetDimension;
    pub const getFormat = wgpu.textureGetFormat;
    pub const getHeight = wgpu.textureGetHeight;
    pub const getMipLevelCount = wgpu.textureGetMipLevelCount;
    pub const getSampleCount = wgpu.textureGetSampleCount;
    pub const getUsage = wgpu.textureGetUsage;
    pub const getWidth = wgpu.textureGetWidth;
    pub const reference = wgpu.textureReference;
    pub const release = wgpu.textureRelease;
    pub const setLabel = wgpu.textureSetLabel;
};

pub const TextureView = *opaque {
    pub const reference = wgpu.textureViewReference;
    pub const release = wgpu.textureViewRelease;
    pub const setLabel = wgpu.textureViewSetLabel;
};

// ==== wgpu-native extras (wgpu.h) ================================================================
pub const LogLevel = enum(u32) {
    off = 0,
    @"error",
    warn,
    info,
    debug,
    trace,
};

pub const Dx12Compiler = enum(u32) {
    undefined = 0,
    fxc,
    dxc,
};

pub const Gles3MinorVersion = enum(u32) {
    automatic = 0,
    version0,
    version1,
    version2,
};

pub const PipelineStatisticName = enum(u32) {
    vertex_shader_invocations = 0,
    clipper_invocations,
    clipper_primitives_out,
    fragment_shader_invocations,
    compute_shader_invocations,
};

pub const SubmissionIndex = u64;
pub const LogCallback = ?*const fn (level: LogLevel, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

pub const InstanceBackendFlags = packed struct(u32) {
    pub const all = InstanceBackendFlags{};
    pub const primary = InstanceBackendFlags{ .vulkan = true, .metal = true, .dx12 = true };
    pub const secondary = InstanceBackendFlags{ .gl = true, .dx11 = true };

    vulkan: bool = false,
    gl: bool = false,
    metal: bool = false,
    dx12: bool = false,
    dx11: bool = false,
    browser_webgpu: bool = false,
    _padding: u26 = 0,
};

pub const InstanceFlags = packed struct(u32) {
    pub const default = InstanceFlags{};

    debug: bool = false,
    validation: bool = false,
    discard_hal_labels: bool = false,
    _padding: u29 = 0,
};

pub const InstanceExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .instance_extras },
    backends: InstanceBackendFlags,
    flags: InstanceFlags,
    dx12_shader_compiler: Dx12Compiler,
    gles3_minor_version: Gles3MinorVersion,
    dxil_path: [*:0]const u8,
    dxc_path: [*:0]const u8,
};

pub const DeviceExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .device_extras },
    trace_path: [*:0]const u8,
};

pub const NativeLimits = extern struct {
    max_push_constant_size: u32 = 0,
    max_non_sampler_bindings: u32 = 0,
};

pub const RequiredLimitsExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .required_limits_extras },
    limits: NativeLimits = .{},
};

pub const SupportedLimitsExtras = extern struct {
    chain: ChainedStructOut = .{ .s_type = .supported_limits_extras },
    limits: NativeLimits = .{},
};

pub const PushConstantRange = extern struct {
    stages: ShaderStageFlags = ShaderStageFlags.none,
    start: u32 = 0,
    end: u32 = 0,
};

pub const PipelineLayoutExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .pipeline_layout_extras },
    push_constant_range_count: usize = 0,
    push_constant_ranges: [*]const PushConstantRange = undefined,
};

pub const WrappedSubmissionIndex = extern struct {
    queue: Queue,
    submission_index: SubmissionIndex,
};

pub const ShaderDefine = extern struct {
    name: [*:0]const u8,
    value: [*:0]const u8,
};

pub const ShaderModuleGLSLDescriptor = extern struct {
    chain: ChainedStruct = .{ .s_type = .shader_module_glsl_descriptor },
    stage: ShaderStageFlags,
    code: [*:0]const u8,
    define_count: u32 = 0,
    defines: [*]ShaderDefine = undefined,
};

pub const MergedShaderModuleGLSLDescriptor = struct {
    label: ?[*:0]const u8 = null,
    hints: []ShaderModuleCompilationHint = &.{},
    stage: ShaderStageFlags,
    code: [*:0]const u8,
    defines: []ShaderDefine = &.{},
};

pub inline fn shaderModuleGLSLDescriptor(descriptor: MergedShaderModuleGLSLDescriptor) ShaderModuleDescriptor {
    return ShaderModuleDescriptor{
        .next_in_chain = @ptrCast(&ShaderModuleGLSLDescriptor{
            .stage = descriptor.stage,
            .code = descriptor.code,
            .define_count = @intCast(descriptor.defines.len),
            .defines = descriptor.defines.ptr,
        }),
        .label = descriptor.label,
        .hint_count = descriptor.hints.len,
        .hints = descriptor.hints.ptr,
    };
}

pub const RegistryReport = extern struct {
    num_allocated: usize = 0,
    num_kept_from_user: usize = 0,
    num_released_from_user: usize = 0,
    num_error: usize = 0,
    element_size: usize = 0,
};

pub const HubReport = extern struct {
    adapters: RegistryReport = .{},
    devices: RegistryReport = .{},
    queues: RegistryReport = .{},
    pipeline_layouts: RegistryReport = .{},
    shader_modules: RegistryReport = .{},
    bind_group_layouts: RegistryReport = .{},
    bind_groups: RegistryReport = .{},
    command_buffers: RegistryReport = .{},
    render_bundles: RegistryReport = .{},
    render_pipelines: RegistryReport = .{},
    compute_pipelines: RegistryReport = .{},
    query_sets: RegistryReport = .{},
    buffers: RegistryReport = .{},
    textures: RegistryReport = .{},
    texture_views: RegistryReport = .{},
    samplers: RegistryReport = .{},
};

pub const GlobalReport = extern struct {
    surfaces: RegistryReport = .{},
    backend_type: BackendType = .undefined,
    vulkan: HubReport = .{},
    metal: HubReport = .{},
    dx12: HubReport = .{},
    gl: HubReport = .{},
};

pub const InstanceEnumerateAdapterOptions = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    backends: InstanceBackendFlags = InstanceBackendFlags.all,
};

pub const BindGroupEntryExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .bind_group_entry_extras },
    buffers: [*]const Buffer = undefined,
    buffer_count: usize = 0,
    samplers: [*]const Sampler = undefined,
    sampler_count: usize = 0,
    texture_views: [*]const TextureView = undefined,
    texture_view_count: usize = 0,
};

pub const BindGroupLayoutEntryExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .bind_group_layout_entry_extras },
    count: u32,
};

pub const QuerySetDescriptorExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .query_set_descriptor_extras },
    pipeline_statistics: [*]const PipelineStatisticName,
    pipeline_statistic_count: usize,
};

pub const SurfaceConfigurationExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .surface_configuration_extras },
    desired_maximum_frame_latency: u32,
};
