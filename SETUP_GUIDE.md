# Flutter Quill 项目配置指南

## 📋 项目概述

Flutter Quill 是一个功能丰富的富文本编辑器，支持移动端和 Web 平台。本项目包含以下模块：

- **flutter_quill**: 核心富文本编辑器库
- **flutter_quill_extensions**: 扩展功能（图片、视频、数学公式等）
- **example**: 示例应用

---

## 🔧 环境要求

- **Flutter SDK**: 3.22.2（通过 FVM 管理）
- **Dart SDK**: 3.4.3（包含在 Flutter SDK 中）
- **FVM**: 用于 Flutter 版本管理

---

## 🚀 快速开始

### 1. 安装 FVM

如果还没有安装 FVM，请运行：

```bash
dart pub global activate fvm
```

安装后，需要将 FVM 添加到 PATH：

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

**建议**: 将上述命令添加到你的 shell 配置文件中（如 `~/.zshrc` 或 `~/.bashrc`）：

```bash
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

### 2. 安装 Flutter 版本

项目已配置 `.fvmrc` 文件，指定使用 Flutter 3.22.2：

```bash
fvm install
```

### 3. 获取依赖

使用 FVM 管理的 Flutter 版本获取依赖：

```bash
fvm flutter pub get
```

### 4. 运行示例应用

```bash
cd example
fvm flutter run
```

---

## 🔍 依赖冲突解决方案

### 问题描述

项目中的 `math_keyboard` 包（用于数学公式编辑功能）依赖 `intl ^0.18.0`，但 `flutter_localizations` 需要 `intl 0.19.0`，导致版本冲突。

### 解决方案

通过在 `pubspec.yaml` 中使用 `dependency_overrides` 强制指定 `intl` 版本为 `0.18.1`：

```yaml
dependency_overrides:
  intl: 0.18.1
```

此配置已添加到以下三个文件：

- `/pubspec.yaml` - 主项目
- `/flutter_quill_extensions/pubspec.yaml` - 扩展模块
- `/example/pubspec.yaml` - 示例应用

**注意**: 使用 `dependency_overrides` 会强制所有依赖项使用指定版本。虽然可能存在潜在的兼容性问题，但经测试，当前配置可以正常工作。

---

## 📦 主要功能模块

### 1. flutter_quill（核心库）

提供富文本编辑的核心功能：

- 文本格式化（粗体、斜体、下划线等）
- 列表（有序、无序）
- 对齐方式
- 颜色和字体
- 撤销/重做

### 2. flutter_quill_extensions（扩展库）

提供嵌入式内容支持：

- ✅ **图片嵌入** - 支持拍照、从相册选择
- ✅ **视频嵌入** - 支持本地视频和 YouTube 视频
- ✅ **数学公式** - 通过 `math_keyboard` 包实现（已解决版本冲突）

**使用方法**：

```dart
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

// 在编辑器中使用
QuillEditor.basic(
  controller: controller,
  embedBuilders: FlutterQuillEmbeds.builders(),
);

// 在工具栏中使用
QuillToolbar.basic(
  controller: controller,
  embedButtons: FlutterQuillEmbeds.buttons(),
);
```

---

## ⚙️ SDK 版本配置

### 更新内容

将所有模块的 SDK 版本约束从 `>=2.12.0 <3.0.0` 更新为 `>=2.12.0 <4.0.0`，以支持 Dart 3.4.3。

**修改的文件**：

- `/pubspec.yaml`
- `/flutter_quill_extensions/pubspec.yaml`
- `/example/pubspec.yaml`

---

## 🛠️ 常用命令

### 使用 FVM

```bash
# 查看已安装的 Flutter 版本
fvm list

# 切换 Flutter 版本
fvm use 3.22.2

# 运行 Flutter 命令
fvm flutter --version
fvm flutter pub get
fvm flutter run
fvm flutter build apk
```

### 依赖管理

```bash
# 获取依赖
fvm flutter pub get

# 查看过时的包
fvm flutter pub outdated

# 升级依赖
fvm flutter pub upgrade
```

### 代码分析

```bash
# 静态代码分析
fvm flutter analyze

# 格式化代码
fvm flutter format .
```

---

## 📝 已知问题

1. **math_keyboard 依赖冲突** - ✅ 已通过 `dependency_overrides` 解决
2. **部分包已过时** - 运行 `fvm flutter pub outdated` 查看可升级的包
3. **废弃 API 警告** - 项目使用了一些 Flutter 废弃的 API，但不影响功能使用

---

## 🔄 更新历史

### 2025-10-31

- ✅ 配置 FVM 使用 Flutter 3.22.2
- ✅ 解决 `math_keyboard` 与 `intl` 的版本冲突
- ✅ 更新 SDK 版本约束支持 Dart 3.4.3
- ✅ 保留所有功能（包括数学公式编辑）

---

## 📞 技术支持

如遇到问题，请参考：

- [官方文档](https://github.com/singerdmx/flutter-quill)
- [中文文档](./doc_cn.md)
- [代码介绍](./CodeIntroduction.md)

---

## 💡 最佳实践

1. **始终使用 FVM 命令** - 确保使用正确的 Flutter 版本
2. **定期更新依赖** - 关注安全更新和 bug 修复
3. **测试后再升级** - 升级主要版本前，确保充分测试
4. **版本控制** - `.fvmrc` 文件已提交，确保团队使用相同版本

---

**享受使用 Flutter Quill！** 🎉
