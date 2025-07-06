// --------------------- 几何参数 ---------------------
dam_height = 100.0;
dam_base_width = 80.0;
dam_crest_width = 10.0;
foundation_depth = 40.0;

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

// --------------------- 物理分组 ---------------------
// Block（区域）
Physical Surface("dam_body", 101) = {20};
Physical Surface("foundation_body", 102) = {21};

// Sideset（边界）
Physical Line("base_boundary", 201) = {7};                    // 地基底边
Physical Line("upstream_face", 202) = {5};                    // 上游水压
Physical Line("dam_foundation_interface", 203) = {1};         // 接触面
Physical Line("crest_boundary", 204) = {4};                   // 坝顶

// --------------------- 网格控制 & 生成 ---------------------
Mesh.ElementOrder = 1;              // 一阶单元即可
Mesh.Algorithm = 5;                 // 网格划分算法（Frontal-Delaunay）

// 生成网格
Mesh 2;
