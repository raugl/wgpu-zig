pub usingnamespace @import("../src/types.zig");

pub const WGPUBool = enum(u32) {
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
    opengl_e_s,
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
    undefined = 0,
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
    rg_b_a8_unorm,
    rg_b_a8_unorm_srgb,
    rg_b_a8_snorm,
    rg_b_a8_uint,
    rg_b_a8_sint,
    bgra8_unorm,
    bgra8_unorm_srgb,
    rg_b10_a2_uint,
    rg_b10_a2_unorm,
    rg11_b10_ufloat,
    rg_b9_e5_ufloat,
    rg32_float,
    rg32_uint,
    rg32_sint,
    rg_b_a16_uint,
    rg_b_a16_sint,
    rg_b_a16_float,
    rg_b_a32_float,
    rg_b_a32_uint,
    rg_b_a32_sint,
    stencil8,
    depth16_unorm,
    depth24_plus,
    depth24_plus_stencil8,
    depth32_float,
    depth32_float_stencil8,
    bc1_rg_b_a_unorm,
    bc1_rg_b_a_unorm_srgb,
    bc2_rg_b_a_unorm,
    bc2_rg_b_a_unorm_srgb,
    bc3_rg_b_a_unorm,
    bc3_rg_b_a_unorm_srgb,
    bc4_r_unorm,
    bc4_r_snorm,
    bc5_rg_unorm,
    bc5_rg_snorm,
    bc6_h_rg_b_ufloat,
    bc6_h_rg_b_float,
    bc7_rg_b_a_unorm,
    bc7_rg_b_a_unorm_srgb,
    etc2_rg_b8_unorm,
    etc2_rg_b8_unorm_srgb,
    etc2_rg_b8_a1_unorm,
    etc2_rg_b8_a1_unorm_srgb,
    etc2_rg_b_a8_unorm,
    etc2_rg_b_a8_unorm_srgb,
    eacr11_unorm,
    eacr11_snorm,
    eacr_g11_unorm,
    eacr_g11_snorm,
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

pub const BufferUsage = enum(u32) {
    none = 0,
    map_read,
    map_write,
    copy_src = 4,
    copy_dst = 8,
    index = 16,
    vertex = 32,
    uniform = 64,
    storage = 128,
    indirect = 256,
    query_resolve = 512,
};

pub const ColorWriteMask = enum(u32) {
    none = 0,
    red,
    green,
    blue = 4,
    alpha = 8,
    all = 15,
};

pub const MapMode = enum(u32) {
    none = 0,
    read,
    write,
};

pub const ShaderStage = enum(u32) {
    none = 0,
    vertex,
    fragment,
    compute = 4,
};

pub const TextureUsage = enum(u32) {
    none = 0,
    copy_src,
    copy_dst,
    texture_binding = 4,
    storage_binding = 8,
    render_attachment = 16,
};

pub const ChainedStruct = extern struct {
    next: ?*const ChainedStruct = null,
    s_type: SType,
};

pub const ChainedStructOut = extern struct {
    next: ?*ChainedStructOut = null,
    s_type: SType,
};

pub const AdapterProperties = extern struct {
    next_in_chain: ?*ChainedStructOut = null,
    vendor_i_d: u32,
    vendor_name: [*:0]const u8,
    architecture: [*:0]const u8,
    device_i_d: u32,
    name: [*:0]const u8,
    driver_description: [*:0]const u8,
    adapter_type: AdapterType,
    backend_type: BackendType,
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
    has_dynamic_offset: WGPUBool,
    min_binding_size: u64,
};

pub const BufferDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    usage: BufferUsageFlags,
    size: u64,
    mapped_at_creation: WGPUBool,
};

pub const Color = extern struct {
    r: f64,
    g: f64,
    b: f64,
    a: f64,
};

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
    max_texture_dimension_1d: u32,
    max_texture_dimension_2d: u32,
    max_texture_dimension_3d: u32,
    max_texture_array_layers: u32,
    max_bind_groups: u32,
    max_bind_groups_plus_vertex_buffers: u32,
    max_bindings_per_bind_group: u32,
    max_dynamic_uniform_buffers_per_pipeline_layout: u32,
    max_dynamic_storage_buffers_per_pipeline_layout: u32,
    max_sampled_textures_per_shader_stage: u32,
    max_samplers_per_shader_stage: u32,
    max_storage_buffers_per_shader_stage: u32,
    max_storage_textures_per_shader_stage: u32,
    max_uniform_buffers_per_shader_stage: u32,
    max_uniform_buffer_binding_size: u64,
    max_storage_buffer_binding_size: u64,
    min_uniform_buffer_offset_alignment: u32,
    min_storage_buffer_offset_alignment: u32,
    max_vertex_buffers: u32,
    max_buffer_size: u64,
    max_vertex_attributes: u32,
    max_vertex_buffer_array_stride: u32,
    max_inter_stage_shader_components: u32,
    max_inter_stage_shader_variables: u32,
    max_color_attachments: u32,
    max_color_attachment_bytes_per_sample: u32,
    max_compute_workgroup_storage_size: u32,
    max_compute_invocations_per_workgroup: u32,
    max_compute_workgroup_size_x: u32,
    max_compute_workgroup_size_y: u32,
    max_compute_workgroup_size_z: u32,
    max_compute_workgroups_per_dimension: u32,
};

pub const MultisampleState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    count: u32,
    mask: u32,
    alpha_to_coverage_enabled: WGPUBool,
};

pub const Origin3D = extern struct {
    x: u32,
    y: u32,
    z: u32,
};

pub const PipelineLayoutDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    bind_group_layout_count: usize,
    bind_group_layouts_: [*]const BindGroupLayout,

    pub fn bind_group_layouts(self: PipelineLayoutDescriptor) []BindGroupLayout {
        return self.bind_group_layouts_[0..self.bind_group_layout_count];
    }
};

pub const PrimitiveDepthClipControl = extern struct {
    chain: ChainedStruct,
    unclipped_depth: WGPUBool,
};

pub const PrimitiveState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    topology: PrimitiveTopology,
    strip_index_format: IndexFormat,
    front_face: FrontFace,
    cull_mode: CullMode,
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

pub const RenderBundleDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const RenderBundleEncoderDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    color_format_count: usize,
    color_formats_: [*]const TextureFormat,
    depth_stencil_format: TextureFormat,
    sample_count: u32,
    depth_read_only: WGPUBool,
    stencil_read_only: WGPUBool,

    pub fn color_formats(self: RenderBundleEncoderDescriptor) []TextureFormat {
        return self.color_formats_[0..self.color_format_count];
    }
};

pub const RenderPassDepthStencilAttachment = extern struct {
    view: TextureView,
    depth_load_op: LoadOp,
    depth_store_op: StoreOp,
    depth_clear_value: f32,
    depth_read_only: WGPUBool,
    stencil_load_op: LoadOp,
    stencil_store_op: StoreOp,
    stencil_clear_value: u32,
    stencil_read_only: WGPUBool,
};

pub const RenderPassDescriptorMaxDrawCount = extern struct {
    chain: ChainedStruct,
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
    power_preference: PowerPreference,
    backend_type: BackendType,
    force_fallback_adapter: WGPUBool,
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
    chain: ChainedStruct,
    code_size: u32,
    code: *const u32,
};

pub const ShaderModuleWGSLDescriptor = extern struct {
    chain: ChainedStruct,
    code: [*:0]const u8,
};

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
    format_count: usize,
    formats_: [*]TextureFormat,
    present_mode_count: usize,
    present_modes_: [*]PresentMode,
    alpha_mode_count: usize,
    alpha_modes_: [*]CompositeAlphaMode,

    pub fn formats(self: SurfaceCapabilities) []TextureFormat {
        return self.formats_[0..self.format_count];
    }

    pub fn present_modes(self: SurfaceCapabilities) []PresentMode {
        return self.present_modes_[0..self.present_mode_count];
    }

    pub fn alpha_modes(self: SurfaceCapabilities) []CompositeAlphaMode {
        return self.alpha_modes_[0..self.alpha_mode_count];
    }
};

pub const SurfaceConfiguration = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    device: Device,
    format: TextureFormat,
    usage: TextureUsageFlags,
    view_format_count: usize,
    view_formats: *const TextureFormat,
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
    chain: ChainedStruct,
    window: *anyopaque,
};

pub const SurfaceDescriptorFromCanvasHTMLSelector = extern struct {
    chain: ChainedStruct,
    selector: [*:0]const u8,
};

pub const SurfaceDescriptorFromMetalLayer = extern struct {
    chain: ChainedStruct,
    layer: *anyopaque,
};

pub const SurfaceDescriptorFromWaylandSurface = extern struct {
    chain: ChainedStruct,
    display: *anyopaque,
    surface: *anyopaque,
};

pub const SurfaceDescriptorFromWindowsHWND = extern struct {
    chain: ChainedStruct,
    hinstance: *anyopaque,
    hwnd: *anyopaque,
};

pub const SurfaceDescriptorFromXcbWindow = extern struct {
    chain: ChainedStruct,
    connection: *anyopaque,
    window: u32,
};

pub const SurfaceDescriptorFromXlibWindow = extern struct {
    chain: ChainedStruct,
    display: *anyopaque,
    window: u64,
};

pub const SurfaceTexture = extern struct {
    texture: Texture,
    suboptimal: WGPUBool,
    status: SurfaceGetCurrentTextureStatus,
};

pub const TextureBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    sample_type: TextureSampleType,
    view_dimension: TextureViewDimension,
    multisampled: WGPUBool,
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
    mip_level_count: u32,
    base_array_layer: u32,
    array_layer_count: u32,
    aspect: TextureAspect,
};

pub const VertexAttribute = extern struct {
    format: VertexFormat,
    offset: u64,
    shader_location: u32,
};

pub const BindGroupDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    layout: BindGroupLayout,
    entry_count: usize,
    entries: *const BindGroupEntry,
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
    message_count: usize,
    messages: *const CompilationMessage,
};

pub const ComputePassDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    timestamp_writes: ?*const ComputePassTimestampWrites = null,
};

pub const DepthStencilState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    format: TextureFormat,
    depth_write_enabled: WGPUBool,
    depth_compare: CompareFunction,
    stencil_front: StencilFaceState,
    stencil_back: StencilFaceState,
    stencil_read_mask: u32,
    stencil_write_mask: u32,
    depth_bias: int32_t,
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
    constant_count: usize,
    constants: *const ConstantEntry,
};

pub const RenderPassColorAttachment = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    view: ?TextureView = null,
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
    hint_count: usize,
    hints: *const ShaderModuleCompilationHint,
};

pub const SupportedLimits = extern struct {
    next_in_chain: ?*ChainedStructOut = null,
    limits: Limits,
};

pub const TextureDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    usage: TextureUsageFlags,
    dimension: TextureDimension,
    size: Extent3D,
    format: TextureFormat,
    mip_level_count: u32,
    sample_count: u32,
    view_format_count: usize,
    view_formats: *const TextureFormat,
};

pub const VertexBufferLayout = extern struct {
    array_stride: u64,
    step_mode: VertexStepMode,
    attribute_count: usize,
    attributes: *const VertexAttribute,
};

pub const BindGroupLayoutDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    entry_count: usize,
    entries: *const BindGroupLayoutEntry,
};

pub const ColorTargetState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    format: TextureFormat,
    blend: ?*const BlendState = null,
    write_mask: ColorWriteMaskFlags,
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
    required_feature_count: usize,
    required_features: *const FeatureName,
    required_limits: ?*const RequiredLimits = null,
    default_queue: QueueDescriptor,
    device_lost_callback: DeviceLostCallback,
    device_lost_userdata: *anyopaque,
};

pub const RenderPassDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    color_attachment_count: usize,
    color_attachments: *const RenderPassColorAttachment,
    depth_stencil_attachment: ?*const RenderPassDepthStencilAttachment = null,
    occlusion_query_set: ?QuerySet = null,
    timestamp_writes: ?*const RenderPassTimestampWrites = null,
};

pub const VertexState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    module: ShaderModule,
    entry_point: ?[*:0]const u8 = null,
    constant_count: usize,
    constants: *const ConstantEntry,
    buffer_count: usize,
    buffers: *const VertexBufferLayout,
};

pub const FragmentState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    module: ShaderModule,
    entry_point: ?[*:0]const u8 = null,
    constant_count: usize,
    constants: *const ConstantEntry,
    target_count: usize,
    targets: *const ColorTargetState,
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
