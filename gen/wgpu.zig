pub const WGPUBool = enum(u32) {
    false = 0,
    true = 1,
};

pub const NativeSType = enum(u32) {
    // Start at 0003 since that's allocated range for wgpu-native
    extras = 196609,
    ed_limits_extras,
    ne_layout_extras,
    module_gl_s_l_descriptor,
    ted_limits_extras,
    ce_extras,
    oup_entry_extras,
    oup_layout_entry_extras,
    et_descriptor_extras,
    e_configuration_extras,
};

pub const NativeFeature = enum(u32) {
    push_constants = 196609,
    texture_adapter_specific_format_features,
    multi_draw_indirect,
    multi_draw_indirect_count,
    vertex_writable_storage,
    texture_binding_array,
    sampled_texture_and_storage_buffer_array_non_uniform_indexing,
    pipeline_statistics_query,
    storage_resource_binding_array,
    partially_bound_binding_array,
};

pub const LogLevel = enum(u32) {
    off = 0,
    @"error",
    warn,
    info,
    debug,
    trace,
};

pub const InstanceBackend = enum(u32) {
    all = 0,
    vulkan,
    gl,
    metal = 4,
    dx12 = 8,
    dx11 = 16,
    browser_webgpu = 32,
    // WGPUInstanceBackend_Primary = WGPUInstanceBackend_Vulkan | WGPUInstanceBackend_Metal | WGPUInstanceBackend_DX12 | WGPUInstanceBackend_BrowserWebGPU,
    primary = 45,
    // WGPUInstanceBackend_Secondary = WGPUInstanceBackend_GL | WGPUInstanceBackend_DX11,
    secondary = 18,
};

pub const InstanceFlag = enum(u32) {
    default = 0,
    debug,
    validation,
    discard_hal_labels = 4,
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

pub const NativeQueryType = enum(u32) {
    pipeline_statistics = 196608,
};

pub const InstanceExtras = extern struct {
    chain: ?ChainedStruct = null,
    backends: InstanceBackendFlags,
    flags: InstanceFlags,
    dx12_shader_compiler: Dx12Compiler,
    gles3_minor_version: Gles3MinorVersion,
    dxil_path: *charconst,
    dxc_path: *charconst,
};

pub const DeviceExtras = extern struct {
    chain: ?ChainedStruct = null,
    trace_path: *charconst,
};

pub const NativeLimits = extern struct {
    max_push_constant_size: u32,
    max_non_sampler_bindings: u32,
};

pub const RequiredLimitsExtras = extern struct {
    chain: ?ChainedStruct = null,
    limits: NativeLimits,
};

pub const SupportedLimitsExtras = extern struct {
    chain: ?ChainedStructOut = null,
    limits: NativeLimits,
};

pub const PushConstantRange = extern struct {
    stages: ShaderStageFlags,
    start: u32,
    end: u32,
};

pub const PipelineLayoutExtras = extern struct {
    chain: ?ChainedStruct = null,
    push_constant_range_count: usize,
    push_constant_ranges: *const PushConstantRange,
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
    chain: ?ChainedStruct = null,
    stage: ShaderStage,
    code: [*:0]const u8,
    define_count: u32,
    defines: *ShaderDefine,
};

pub const RegistryReport = extern struct {
    num_allocated: usize,
    num_kept_from_user: usize,
    num_released_from_user: usize,
    num_error: usize,
    element_size: usize,
};

pub const HubReport = extern struct {
    adapters: RegistryReport,
    devices: RegistryReport,
    queues: RegistryReport,
    pipeline_layouts: RegistryReport,
    shader_modules: RegistryReport,
    bind_group_layouts: RegistryReport,
    bind_groups: RegistryReport,
    command_buffers: RegistryReport,
    render_bundles: RegistryReport,
    render_pipelines: RegistryReport,
    compute_pipelines: RegistryReport,
    query_sets: RegistryReport,
    buffers: RegistryReport,
    textures: RegistryReport,
    texture_views: RegistryReport,
    samplers: RegistryReport,
};

pub const GlobalReport = extern struct {
    surfaces: RegistryReport,
    backend_type: BackendType,
    vulkan: HubReport,
    metal: HubReport,
    dx12: HubReport,
    gl: HubReport,
};

pub const InstanceEnumerateAdapterOptions = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    backends: InstanceBackendFlags,
};

pub const BindGroupEntryExtras = extern struct {
    chain: ?ChainedStruct = null,
    buffers: *const Buffer,
    buffer_count: usize,
    samplers: *const Sampler,
    sampler_count: usize,
    texture_views: *const TextureView,
    texture_view_count: usize,
};

pub const BindGroupLayoutEntryExtras = extern struct {
    chain: ?ChainedStruct = null,
    count: u32,
};

pub const QuerySetDescriptorExtras = extern struct {
    chain: ?ChainedStruct = null,
    pipeline_statistics: *const PipelineStatisticName,
    pipeline_statistic_count: usize,
};

pub const SurfaceConfigurationExtras = extern struct {
    chain: ?ChainedStruct = null,
    desired_maximum_frame_latency: WGPUBool,
};

