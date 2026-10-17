# Codex Startup Animation for Windows

给 Microsoft Store 版 Codex 添加启动动画和应用内图片背景。基于已验证的便携运行时（`CodexStartup.exe` + MSIX 官方激活），支持更换头像、背景和文字，背景支持大图与 GIF。

这是非官方项目，官方应用需要另行安装。

## 安装

适用于 Windows 10/11、Microsoft Store 版 `OpenAI.Codex`。无需管理员权限，无需单独安装 Node.js。

用下面任一方式取得代码：

**git clone**

```powershell
git clone https://github.com/seetimee/codex-startup-animation-windows.git
cd codex-startup-animation-windows
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\install-windows.ps1
```

**GitHub 压缩包**

1. 打开仓库页面，点击 **Code → Download ZIP**，解压到一个固定目录。
2. 在该目录打开 PowerShell，运行：

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\install-windows.ps1
   ```

安装会创建桌面快捷方式 **Codex Animation** 和 **Codex Image Settings**。项目文件夹需要保留；移动后请重新运行安装脚本。

也可以直接双击仓库根目录的 `CodexStartup.exe` 启动。

## 使用

1. 先安装 Microsoft Store 版官方 Codex。
2. 从托盘完全退出 Codex。
3. 打开桌面 **Codex Animation**，或双击 `CodexStartup.exe`。
4. 换图片：桌面 **Codex Image Settings**，或主窗口 `Ctrl+Alt+B`。

头像支持 PNG、JPEG、WebP；背景还可以使用 GIF，单张不超过 80 MB。GIF 保存后继续循环，线稿取其中一帧。设置保存在本机，不会上传。

### 4k红瞳少女动态壁纸

可选背景示例。从网盘保存到本机后，在图片设置里导入。仓库不包含该文件。

```
https://www.alipan.com/s/dakiZZ9nPLq
提取码: i0u9
点击链接保存，或者复制本段内容，打开「阿里云盘」APP ，无需下载极速在线查看，视频原画倍速播放。
```

## 常见问题

**直接点官方图标没有动画：** 使用本项目的 **Codex Animation** 或 `CodexStartup.exe`。

**提示应用正在运行：** 从托盘完全退出 Codex 后，再用动画入口打开。

**想停用：** 完全退出 Codex，之后使用官方入口打开。删除本项目的两个快捷方式即可。

日志：`%LOCALAPPDATA%\CodexStartupWindows\launcher.log`。

给其他 agent 的安装说明见 [SKILL.md](SKILL.md)。来源见 [references.md](references.md)。
