gravity_dam
=====

Fork "gravity_dam" to create a new MOOSE-based application.

For more information see: [https://mooseframework.inl.gov/getting_started/new_users.html#create-an-app](https://mooseframework.inl.gov/getting_started/new_users.html#create-an-app)

## Simulation Overview

This simulation performs a 2D plane strain analysis of a gravity dam subjected to self-weight and hydrostatic pressure. The primary goal is to determine the stress and displacement distribution within the dam and its foundation.

### Model Details

*   **Geometry**: The model consists of two main bodies: the dam body and the foundation.
*   **Materials**: Both the dam and the foundation are modeled as linear elastic, isotropic materials with distinct properties.
*   **Loads**:
    *   **Gravity**: Applied to the entire model to simulate self-weight.
    *   **Hydrostatic Pressure**: Applied to the upstream face of the dam, corresponding to a water level of 90 meters.
*   **Boundary Conditions**: The base of the foundation is fully fixed, with zero displacement in both the x and y directions.

### Analysis Objectives

The simulation calculates the following key outputs:

*   **Displacement Field**: The `disp_x` and `disp_y` variables represent the displacement of the structure.
*   **Crest Displacement**: The `crest_disp_x_max` postprocessor calculates the maximum horizontal displacement at the crest of the dam, a critical indicator of structural stability.
*   **Stress Distribution**: The `stress_yy` postprocessor computes the average vertical stress within the dam body, which is essential for assessing the material's response to the applied loads.

This model serves as a fundamental example for structural analysis in civil engineering and provides a foundation for more advanced simulations, such as those involving material nonlinearity, seismic loads, or fluid-structure interaction.

---

## 项目目标与验证说明

本项目的核心目标是**验证基于MOOSE框架开发的自定义仿真应用 `gravity_damApp` 的核心功能**。我们通过一个经典的重力坝在自重和静水压力下的二维平面应变分析案例，系统性地检验���软件在固体力学仿真流程中的各项关键能力。

### 实验条件

*   **仿真软件**: `gravity_damApp` (基于 MOOSE 框架)
*   **物理模型**: 重力坝二维平面应变模型
*   **分析类型**: 静态力学分析 (Steady-State)
*   **求解方法**: 有限元法 (FEM)
*   **非线性求解器**: 牛顿法 (NEWTON)

### 核心功能验证清单

本次模拟验证了 `gravity_damApp` 对 MOOSE 核心模块的集成和调用能力，具体验证的功能点如下：

1.  **网格处理系统 (`Mesh`)**
    *   `FileMeshGenerator`: 验证了从外部文件 (`.msh`) 成功导入和解析复杂网格的能力。

2.  **变量定义系统 (`Variables`)**
    *   验证了系统能够定义并求解多分量、相互耦合的物理场变量 (`disp_x`, `disp_y`)。

3.  **材料模型系统 (`Materials`)**
    *   `ComputeSmallStrain`: 验证了从位移场计算应变张量的能力。
    *   `ComputeIsotropicElasticityTensor`: 验证了定义各向同性线弹性材料本构关系的能力。
    *   `ComputeLinearElasticStress`: 验证了基于应变和弹性张量计算应力张量的能力。
    *   `GenericConstantMaterial`: 验证了为模型不同区域赋予独立的、恒定的材料属性（如密度）的能力。

4.  **物理内核系统 (`Kernels`)**
    *   `StressDivergenceTensors`: 验证了求解固体力学核心方程——应力散度项的能力，这是处理力学问题的基础。
    *   `Gravity`: 验证了施加体力（如重力）荷载的能力。

5.  **边界条件系统 (`BCs`)**
    *   `DirichletBC`: 验证了施加狄利克雷边界条件（即位移约束）的能力。
    *   `Pressure`: 验证了在指定边界面上施加压力荷载的能力。

6.  **函数解析系统 (`Functions`)**
    *   `ParsedFunction`: 验证了使用字符串表达式定义复杂、非均匀函数（如随水深变化的静水压力）的能力，极大地增强了模型灵活性。

7.  **后处理系统 (`Postprocessors`)**
    *   `NodalExtremeValue`: 验证了在模型的特定区域（如坝顶）自动提取和计算节点变量最值（最大/最小）的能力。
    *   `ElementAverageValue`: 验证了对单元内的物理量（如应力）进行积分和平均计算的能力。

8.  **执行与输出 (`Executioner` & `Outputs`)**
    *   `Steady`: 验证了稳态问题求解器的正常工作。
    *   `Exodus` / `CSV`: 验证了将计算结果以标准格式（如用于可视化的Exodus格式和用于数据分析的CSV格式）输出的能力。

通过以上验证过程，我们确认 `gravity_damApp` 已成功集成了 MOOSE 框架下的关键组件，能够完整、正确地执行一个典型的固体力学仿真任务。

