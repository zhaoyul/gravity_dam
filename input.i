########################################################################
#  Gravity Dam – 2-D Plane Strain (完全手动定义)
########################################################################

[Mesh]
  [gmsh_mesh]
    type = FileMeshGenerator
    file = 'gravity_dam.msh'
  []
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

# ---------------------------------------------------------------------
# 1. Materials - 手动定义所有材料，包括应变
# ---------------------------------------------------------------------
[Materials]
  # >>> Dam
  # 手动添加应变计算
  [./dam_strain] type = ComputeSmallStrain displacements = 'disp_x disp_y' block = 'dam_body' [../]
  [./dam_elastic] type = ComputeIsotropicElasticityTensor youngs_modulus = 30e9  poissons_ratio = 0.2  block = 'dam_body' [../]
  [./dam_stress ] type = ComputeLinearElasticStress         block = 'dam_body' [../]
  [./dam_rho    ] type = GenericConstantMaterial          prop_names = 'density' prop_values = '2400' block='dam_body' [../]

  # >>> Foundation
  # 手动添加应变计算
  [./fdn_strain] type = ComputeSmallStrain displacements = 'disp_x disp_y' block = 'foundation_body' [../]
  [./fdn_elastic] type = ComputeIsotropicElasticityTensor youngs_modulus = 50e9  poissons_ratio = 0.25 block='foundation_body' [../]
  [./fdn_stress ] type = ComputeLinearElasticStress         block = 'foundation_body' [../]
  [./fdn_rho    ] type = GenericConstantMaterial          prop_names = 'density' prop_values = '2700' block='foundation_body' [../]
[]

# ---------------------------------------------------------------------
# 2. Kernels - 显式定义所有物理项
# ---------------------------------------------------------------------
[Kernels]
  # 使用现代的张量版本内核
  [./tmech_x]
    type = StressDivergenceTensors
    variable = disp_x
    component = 0
    displacements = 'disp_x disp_y'
    block = 'dam_body foundation_body'
  [../]
  [./tmech_y]
    type = StressDivergenceTensors
    variable = disp_y
    component = 1
    displacements = 'disp_x disp_y'
    block = 'dam_body foundation_body'
  [../]

  # 重力体力荷载
  [./gravity_y]
    type      = Gravity
    variable  = disp_y
    displacements = 'disp_x disp_y'
    value     = -9.81
    density   = density
    block     = 'dam_body foundation_body'
  [../]
[]

# ---------------------------------------------------------------------
# 3. Boundary Conditions
# ---------------------------------------------------------------------
[BCs]
  [./fix_base_x] type = DirichletBC variable = disp_x boundary = 'base_boundary' value = 0 [../]
  [./fix_base_y] type = DirichletBC variable = disp_y boundary = 'base_boundary' value = 0 [../]

  [./hydrostatic_pressure]
    type          = Pressure
    variable      = disp_x
    boundary      = 'upstream_face'
    function      = hydrostatic_pressure_func
    displacements = 'disp_x disp_y'
  [../]
[]

# ---------------------------------------------------------------------
# 4. Functions
# ---------------------------------------------------------------------
[Functions]
  [./hydrostatic_pressure_func]
    type          = ParsedFunction
    expression    = 'max(0, rho_water * g * (water_level - y))'
    symbol_names  = 'rho_water g water_level'
    symbol_values = '1000 9.81 90'
  [../]
[]

# ---------------------------------------------------------------------
# 5. Executioner
# ---------------------------------------------------------------------
[Executioner]
  type       = Steady
  solve_type = NEWTON
[]

# ---------------------------------------------------------------------
# 6. Postprocessors
# ---------------------------------------------------------------------
[Postprocessors]
  [./crest_disp_x_max]
    type       = NodalExtremeValue
    variable   = disp_x
    boundary   = 'crest_boundary'
    value_type = max
  [../]
  # 为了使用 stress_yy，需要一个材料属性输出
  [./stress_yy]
    type = ElementAverageValue
    variable = disp_y
    block = dam_body
  [../]
  
[]

# ---------------------------------------------------------------------
# 7. Outputs
# ---------------------------------------------------------------------
[Outputs]
  exodus = true
  csv    = true
[]
