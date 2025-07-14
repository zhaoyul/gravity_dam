// --------------------- 几何参数 ---------------------
dam_height = 100.0;
dam_base_width = 80.0;
dam_crest_width = 10.0;
foundation_depth = 40.0;
thickness = 30.0;                     // 跨坝厚度

// --------------------- 坐标点 ---------------------
Point(1) = {0, 0, 0, 5.0};                                                 // 坝踵底部
Point(2) = {dam_base_width, 0, 0, 5.0};                                    // 坝趾底部
Point(3) = {dam_base_width, dam_height, 0, 5.0};                           // 坝趾顶部
Point(4) = {dam_base_width - dam_crest_width, dam_height, 0, 5.0};        // 坝顶下游点
Point(5) = {0, dam_height, 0, 5.0};                                        // 坝顶上游点
Point(6) = {-2 * dam_height, -foundation_depth, 0, 10.0};                 // 地基左下角
Point(7) = {3 * dam_base_width, -foundation_depth, 0, 10.0};              // 地基右下角

// --------------------- 边界线段 ---------------------
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 1};

Line(6) = {1, 6};
Line(7) = {6, 7};
Line(8) = {7, 2};

// --------------------- 闭合区域 ---------------------
Line Loop(10) = {1, 2, 3, 4, 5};
Plane Surface(20) = {10};

Line Loop(11) = {-1, 6, 7, 8};
Plane Surface(21) = {11};

// --------------------- 三维拉伸 ---------------------
// 先拉伸边界线以生成侧面标记
base_sur[] = Extrude {0, 0, thickness} { Line{7}; Layers{1}; };
upstream_sur[] = Extrude {0, 0, thickness} { Line{5}; Layers{1}; };
contact_sur[] = Extrude {0, 0, thickness} { Line{1}; Layers{1}; };
crest_sur[] = Extrude {0, 0, thickness} { Line{4}; Layers{1}; };

// 然后拉伸区域生成体网格
out_dam[] = Extrude {0, 0, thickness} { Surface{20}; Layers{1}; Recombine; };
out_fdn[] = Extrude {0, 0, thickness} { Surface{21}; Layers{1}; Recombine; };

// --------------------- 物理分组 ---------------------
// Block（区域）
Physical Volume("dam_body", 101) = {out_dam[1]};
Physical Volume("foundation_body", 102) = {out_fdn[1]};

// Sideset（边界）
Physical Surface("base_boundary", 201) = {base_sur[1]};
Physical Surface("upstream_face", 202) = {upstream_sur[1]};
Physical Surface("dam_foundation_interface", 203) = {contact_sur[1]};
Physical Surface("crest_boundary", 204) = {crest_sur[1]};

// --------------------- 网格控制 & 生成 ---------------------
Mesh.ElementOrder = 1;              // 一阶单元即可
Mesh.Algorithm = 5;                 // 网格划分算法（Frontal-Delaunay）
Mesh.MshFileVersion = 2.2;          // 使用 MSH v2 以便与 MOOSE 兼容

// 生成网格
Mesh 3;                             // 生成三维单元
