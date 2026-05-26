# Magic Vision Patch

对 Magic 视界的 Patch 脚本文件和 NSIS.nsi 脚本文件。

适用于 Magic 视界 10.0.0.37(C233HONOR)。

> [!WARNING]
> 本开源项目提供的所有服务及内容均旨在促进合法的学习交流活动，严禁用户将其用于任何非法、违规或侵犯他人权益的目的。敬请所有用户严格遵守相关法律法规，在使用本开源项目的过程中秉持合法、正当与诚信原则，切勿涉足任何违法用途。如有违反，相关法律责任将由行为人自负。

## 第一次使用？

请在本地计算机安装 NSIS：https://nsis.sourceforge.io/Download

如果你使用 [Chocolatey](https://chocolatey.org/)：

```bash
choco install nsis
```

然后，将 `[nsis].nsi` 文件、`files_section.nsh` 文件和 `apply_patches.py` 文件放进解压后的 Magic 视界文件夹内。

在 Magic 视界文件夹内安装以下 PyPI 依赖（计算机需要 Python 环境）：

```bash
pip install pefile
```

如果你使用 [Astral uv](https://docs.astral.sh/uv/)：

```bash
uv add pefile
```

## Patch 与打包

执行 `apply_patches.py` 文件：

```bash
py apply_patches.py
```

如果你使用 Astral uv：

```bash
uv run apply_patches.py
```

将生成的 `Launcher.exe.patched` 和 `Util.dll.patched` 文件去掉 `.patched` 扩展名，替换安装包原有 `Launcher.exe` 和 `Util.dll` 文件。

最后，在 Magic 视界文件夹执行以下命令以打包 NSIS 安装包（请注意把 `path\to\` 更改为 NSIS 实际地址）：

```bash
& "path\to\NSIS\makensis.exe" "[NSIS].nsi"
```

## 剥离 Patch 文件数字签名

考虑到 Patch 后文件无法匹配原有数字签名，可能导致一些检测环境的安全软件报告异常，因此这里提供了 `remove_signature.py` Python 脚本以剥离 `Launcher.exe` 和 `Util.dll` 文件的数字签名。

在 Magic 视界根目录执行 `remove_signature.py` 文件：

```bash
py remove_signature.py
```

如果你使用 Astral uv：

```bash
uv run remove_signature.py
```

## 原理说明

1. 荣耀 Magic 视界独立安装包，包含在荣耀电脑管家里，是标准 NSIS 打包。
2. 机型校验逻辑在 `Launcher.exe` 和 `Util.dll` 这两个文件里。Patch 脚本会尝试使相关校验 Point always True。
3. `[NSIS].nsi` 是 NSIS 打包脚本文件。
