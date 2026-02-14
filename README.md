<p align="center">
    <img src="screenshots/logo.png" width="200" />
    <h1 align="center">渡鸦相机</h1>
    <p align="center">极简黑白相机</p>
    <p align="center">
        简体中文 | <a href="README_en.md">English</a>
    </p>
    <p align="center">
        <a href="https://apps.apple.com/app/id1527902937">
            <img src="https://img.shields.io/badge/App_Store-Download-blue?logo=apple&logoColor=white" alt="App Store" />
        </a>
        <a href="https://developer.apple.com/ios/">
            <img src="https://img.shields.io/badge/platform-iOS_18.6+-lightgrey?logo=apple" alt="Platform" />
        </a>
        <a href="https://swift.org">
            <img src="https://img.shields.io/badge/Swift-5-orange?logo=swift&logoColor=white" alt="Swift" />
        </a>
        <a href="https://github.com/nswbmw/ravencam/blob/master/LICENSE">
            <img src="https://img.shields.io/github/license/nswbmw/ravencam" alt="License" />
        </a>
        <a href="https://swift.org/package-manager/">
            <img src="https://img.shields.io/badge/SPM-compatible-brightgreen?logo=swift" alt="SPM" />
        </a>
    </p>
</p>

## 功能

- **实时黑白滤镜** — 基于 Core Image 的实时预览
- **参数调节** — 曝光、反差、锐化、暗角、噪点、模糊
- **闪光灯控制** — 开 / 关 / 自动
- **摄像头切换** — 一键切换前置 / 后置摄像头
- **日期水印** — 可选的拍摄日期水印
- **无损拍摄** — 高分辨率照片输出
- **地理位置** — 可选的位置信息记录
- **内置相册** — 浏览、缩放、分享、删除照片
- **EXIF 读写** — 照片参数写入 EXIF

## 截图

| 拍摄 | 参数调节 | 相册 |
|:---:|:---:|:---:|
| ![拍摄](screenshots/1.png) | ![参数调节](screenshots/2.png) | ![相册](screenshots/3.png) |

## 要求

- iOS 18.6+
- Xcode 16+
- Swift 5

## 依赖

通过 Swift Package Manager 管理：

- [SnapKit](https://github.com/SnapKit/SnapKit) — Auto Layout DSL
- [DefaultsKit](https://github.com/nmdias/DefaultsKit) — UserDefaults 封装

## 构建

1. 克隆仓库
   ```bash
   git clone https://github.com/nswbmw/ravencam.git
   ```
2. 用 Xcode 打开 `ravencam.xcodeproj`
3. Xcode 会自动拉取 SPM 依赖
4. 选择目标设备，点击运行

## 项目结构

```
ravencam/
├── AppDelegate.swift          # App 生命周期
├── SceneDelegate.swift        # 场景管理
├── Controller/
│   ├── CameraViewController/  # 相机主界面
│   ├── CameraController.swift # 相机控制 & 滤镜处理
│   ├── PageViewController.swift # 页面切换容器
│   ├── AlbumViewController/   # 相册浏览
│   │   └── PhotoPreviewController/ # 照片预览 & 缩放
│   └── SettingViewController/ # 设置页面
├── Model/
│   ├── Photo.swift            # 照片参数模型
│   └── PhotoWithImage.swift   # 带图片的照片模型
├── View/                      # 自定义 UI 组件
├── Util/
│   ├── Cache.swift            # UserDefaults 缓存
│   └── Util.swift             # 工具函数
├── Extension/                 # UIImage / UIView / Float 扩展
├── Class/                     # 手势 & 相册工具类
├── CustomBlurEffectView/      # 自定义模糊效果
└── Resource/                  # 字体资源
```

## 许可证

[MIT](LICENSE)
