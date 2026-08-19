# DocScanner SDK - Linux

[![Platform](https://img.shields.io/badge/platform-Linux-orange.svg)](https://www.linux.org/)
[![C++](https://img.shields.io/badge/C%2B%2B-17-blue.svg)](https://isocpp.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Linux SDK for document scanning with fixed crop area overlay.

## Status

🚧 **Under Development**

This SDK is currently being developed. Expected features:

- 📷 **V4L2** - Camera access via Video4Linux2
- ⬜ **OpenCV Overlay** - Fixed crop area overlay
- 📸 **Auto Crop** - OpenCV-based cropping
- 🎯 **High Performance** - Native C++ performance
- 🖥️ **GTK/Qt Support** - UI framework integration

## Requirements

- Linux kernel 4.4 or later
- C++17 compatible compiler (GCC 7+ or Clang 5+)
- CMake 3.15 or later
- OpenCV 4.5+
- V4L2 (Video4Linux2)

### Ubuntu/Debian

```bash
sudo apt install build-essential cmake
sudo apt install libopencv-dev
sudo apt install v4l-utils libv4l-dev
sudo apt install libgtk-3-dev  # For GTK UI (optional)
sudo apt install qtbase5-dev   # For Qt UI (optional)
```

### Fedora

```bash
sudo dnf install gcc-c++ cmake
sudo dnf install opencv-devel
sudo dnf install v4l-utils libv4l-devel
```

## Planned Installation

### Building from Source

```bash
git clone https://github.com/Tareq-Ghassan/DocScannerSDK-Linux.git
cd DocScannerSDK-Linux
mkdir build && cd build
cmake ..
make
sudo make install
```

## Planned API

```cpp
#include <docscanner/DocScanner.hpp>

using namespace docscanner;

DocScanner scanner;

// Request camera permission (checks device access)
if (scanner.requestCameraPermission()) {
    // Configure options
    ScanOptions options;
    options.borderColor = {255, 255, 255};  // White
    options.borderWidth = 2.0;
    options.overlayHeight = 210.0;
    
    // Scan document
    ScanResult result = scanner.scanDocument(options);
    
    if (result.isSuccess && !result.frontImagePath.empty()) {
        cv::Mat image = cv::imread(result.frontImagePath);
        // Use image
    }
}
```

## Architecture

```
DocScannerSDK-Linux/
├── include/docscanner/
│   ├── DocScanner.hpp
│   ├── ScanOptions.hpp
│   ├── ScanResult.hpp
│   └── Camera.hpp
├── src/
│   ├── DocScanner.cpp
│   ├── Camera.cpp
│   ├── ImageCropper.cpp
│   └── OverlayRenderer.cpp
├── examples/
│   ├── simple_scan.cpp
│   └── gtk_example.cpp
├── tests/
├── CMakeLists.txt
└── README.md
```

## Planned Features

### Core

- V4L2 camera capture
- OpenCV image processing
- Fixed crop overlay rendering
- Automatic image cropping
- Multi-camera support

### UI Support

- **GTK 3** - Native Linux desktop
- **Qt 5/6** - Cross-platform UI
- **Raw OpenCV** - Headless operation

### Python Bindings (Optional)

```python
import docscanner

scanner = docscanner.DocScanner()
result = scanner.scan_document()

if result.is_success:
    print(f"Image saved to: {result.front_image_path}")
```

## Supported Distributions

- Ubuntu 20.04+
- Debian 11+
- Fedora 35+
- Arch Linux
- openSUSE Leap 15.3+

## Contributing

Contributions welcome! This SDK is in early development.

## License

MIT License - Copyright (c) 2024-2026 Tareq Abu Saleh

## Support

- **Issues**: [GitHub Issues](https://github.com/Tareq-Ghassan/DocScannerSDK-Linux/issues)
- **Main Project**: [DocumentScanner-SDK](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)

## Roadmap

- [ ] V4L2 camera integration
- [ ] OpenCV overlay rendering
- [ ] Image cropping implementation
- [ ] GTK UI example
- [ ] Qt UI example
- [ ] Python bindings
- [ ] Wayland support
- [ ] Documentation
- [ ] Unit tests
