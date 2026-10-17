# 上游与素材

本项目基于 [M1ddle0/codex-startup-animation](https://github.com/M1ddle0/codex-startup-animation) 的启动动画前端及外部接入思路，基准提交 `52bf7c7377663c42aad0730ab4868a48c1e1d2be`。上游 fork 来自 [panding999/codex-startup-animation](https://github.com/panding999/codex-startup-animation)。

HTML/CSS/Canvas 启动时间线、图片导入和轮廓提取、临时 iframe、透明壁纸样式、CDP 客户端与目标窗口筛选继承并适配上游。Windows MSIX 激活、监听校验、GIF 保存与统一裁切、一键安装及更新/卸载在本项目中实现。

`assets/avatar.svg`、`assets/artwork.svg` 是本项目用代码绘制的几何图案，JPEG 与 ICO 从这些图案生成，轮廓从默认背景提取。不包含蜡笔小新、亚丝娜、个人照片或 OpenAI 官方图标。用户导入的素材由用户自行选择，运行时不从网络下载。

所读取的上游提交未附明确 LICENSE 文件。本项目保留来源和修改说明，不把上游代码标记为 MIT 或其他未经确认的授权。代码与图片的权利应分别处理。

这是非官方社区项目，与 OpenAI 无官方关联，不修改官方安装包。
