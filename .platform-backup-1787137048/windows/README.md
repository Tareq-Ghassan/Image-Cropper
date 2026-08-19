# DocScanner SDK - Windows

[![Platform](https://img.shields.io/badge/platform-Windows%2010%2B-blue.svg)](https://www.microsoft.com/windows)
[![.NET](https://img.shields.io/badge/.NET-6.0-purple.svg)](https://dotnet.microsoft.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![NuGet](https://img.shields.io/badge/NuGet-soon-orange.svg)](https://www.nuget.org/)

Windows SDK for document scanning with fixed crop area overlay.

## Status

🚧 **Under Development**

This SDK is currently being developed. Expected features:

- 📷 **Media Foundation** - Camera access via Windows Media Foundation
- ⬜ **WPF/WinUI Overlay** - Fixed crop area overlay
- 📸 **Auto Crop** - Bitmap cropping
- 🎯 **High Performance** - Native Windows performance

## Requirements

- Windows 10 version 1903 or later
- Windows 11
- .NET 6.0 or later
- Visual Studio 2022

## Planned Installation

### NuGet (Coming Soon)

```xml
<PackageReference Include="DocScanner.SDK.Windows" Version="1.0.0" />
```

## Planned API

```csharp
using DocScanner.SDK.Windows;

var scanner = new DocScanner();
await scanner.RequestCameraPermissionAsync();

var result = await scanner.ScanDocumentAsync();
if (result.IsSuccess && result.FrontImagePath != null)
{
    var bitmap = new BitmapImage(new Uri(result.FrontImagePath));
    // Use bitmap
}
```

## Architecture

```
DocScanner.SDK.Windows/
├── Core/
│   ├── DocScanner.cs
│   ├── CameraManager.cs
│   └── ImageCropper.cs
├── Models/
│   ├── ScanOptions.cs
│   └── ScanResult.cs
├── UI/
│   ├── ScannerWindow.xaml
│   └── OverlayControl.xaml
└── DocScanner.SDK.Windows.csproj
```

## Contributing

Contributions welcome! This SDK is in early development.

## License

MIT License - Copyright (c) 2024-2026 Tareq Abu Saleh

## Support

- **Issues**: [GitHub Issues](https://github.com/Tareq-Ghassan/DocScannerSDK-Windows/issues)
- **Main Project**: [DocumentScanner-SDK](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)
