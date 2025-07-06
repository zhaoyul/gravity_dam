########################################################################
#  Gravity Dam – 2-D Plane Strain (使用Action系统)
#  本文件遵循 project-defination.org 的精神，使用高层抽象构建。
########################################################################

[Mesh]
  [gmsh_mesh]
    type = FileMeshGenerator
    file = 'gravity_dam.msh'
  []
[]

# ---------------------------------------------------------------------
# 使用高层次的Action系统来简化固体力学问题的设置
# Action系统会自动创建变量(disp_x, disp_y)和核心的力学计算材料/内核
# ---------------------------------------------------------------------
[Physics]
  [./SolidMechanics]
    [./QuasiStatic]
      # 声明为小应变分析
      strain = SMALL
      # 显式提供位移变量名称
      displacements = 'disp_x disp_y'
      # 让Action系统自动创建位移变量
      add_variables = true
      # 指定需要额外计算并输出到结果文件的物理量
      generate_output = 'stress_xx stress_yy strain_xx'
      # 在Action内部定义子块，用于后续的材料块限制
      [./dam]
        block = 'dam_body'
        displacements = 'disp_x disp_y'
      [../]
      [./foundation]
        block = 'foundation_body'
        displacements = 'disp_x disp_y'
      [../]
    [../]
  [../]
[]

# ---------------------------------------------------------------------
# 1. Materials - 只需定义核心本构关系和密度
# ---------------------------------------------------------------------
[Materials]
  # >>> Dam
  [./dam_elastic]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 30e9
    poissons_ratio = 0.2
    block = 'dam_body'
  [../]
  [./dam_stress]
    type = ComputeLinearElasticStress
    block = 'dam_body'
  [../]
  [./dam_rho]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '2400'
    block = 'dam_body'
  [../]

  # >>> Foundation
  [./fdn_elastic]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 50e9
    poissons_ratio = 0.25
    block = 'foundation_body'
  [../]
  [./fdn_stress]
    type = ComputeLinearElasticStress
    block = 'foundation_body'
  [../]
  [./fdn_rho]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '2700'
    block = 'foundation_body'
  [../]
[]

# ---------------------------------------------------------------------
# 2. Kernels - 只需定义额外的物理项，如体力
# ---------------------------------------------------------------------
[Kernels]
  # 重力体力荷载
  [./gravity_y]
    type = Gravity
    variable = disp_y
    # Action系统需要知道此Kernel依赖的位移变量
    displacements = 'disp_x disp_y'
    value = -9.81
    density = density
    block = 'dam_body foundation_body'
  [../]
[]

# ---------------------------------------------------------------------
# 3. Boundary Conditions
# ---------------------------------------------------------------------
[BCs]
  [./fix_base_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'base_boundary'
    value = 0
  [../]
  [./fix_base_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'base_boundary'
    value = 0
  [../]

  [./hydrostatic_pressure]
    type = Pressure
    variable = disp_x
    boundary = 'upstream_face'
    function = hydrostatic_pressure_func
    displacements = 'disp_x disp_y'
  [../]
[]

# ---------------------------------------------------------------------
# 4. Functions
# ---------------------------------------------------------------------
[Functions]
  [./hydrostatic_pressure_func]
    type = ParsedFunction
    expression = 'max(0, rho_water * g * (water_level - y))'
    symbol_names = 'rho_water g water_level'
    symbol_values = '1000 9.81 90'
  [../]
[]

# ---------------------------------------------------------------------
# 5. Executioner
# ---------------------------------------------------------------------
[Executioner]
  type = Steady
  solve_type = NEWTON
[]

# ---------------------------------------------------------------------
# 6. Postprocessors
# ---------------------------------------------------------------------
[Postprocessors]
  [./crest_disp_x_max]
    type = NodalExtremeValue
    variable = disp_x
    boundary = 'crest_boundary'
    value_type = max
  [../]
[]

# ---------------------------------------------------------------------
# 7. Outputs
# ---------------------------------------------------------------------
[Outputs]
  exodus = true
  csv = true
[]