# DocScanner SDK - Web

[![npm version](https://badge.fury.io/js/@docscanner%2Fsdk-web.svg)](https://www.npmjs.com/package/@docscanner/sdk-web)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.3-blue.svg)](https://www.typescriptlang.org/)

Web SDK for document scanning with fixed crop area overlay. Works in all modern browsers with WebRTC support.

## Features

- 📷 **Camera Access** - WebRTC MediaDevices API
- ⬜ **Fixed Crop Area** - Canvas-based overlay
- 📸 **Auto Crop** - Client-side image cropping
- 🌐 **Cross-Browser** - Works on Chrome, Firefox, Safari, Edge
- 🔄 **Front/Back Support** - Capture both document sides
- 💾 **Blob Output** - Returns image as Blob for upload
- 🎨 **Customizable** - Configure overlay and camera settings

## Browser Support

| Browser | Version | Status |
|---------|---------|--------|
| Chrome | 90+ | ✅ |
| Firefox | 88+ | ✅ |
| Safari | 15+ | ✅ |
| Edge | 90+ | ✅ |
| Opera | 76+ | ✅ |

## Installation

### NPM

```bash
npm install @docscanner/sdk-web
```

### Yarn

```bash
yarn add @docscanner/sdk-web
```

### CDN

```html
<script src="https://unpkg.com/@docscanner/sdk-web@1.0.0/dist/index.js"></script>
```

## Quick Start

### 1. Import the SDK

```typescript
import { DocScanner } from '@docscanner/sdk-web';
```

### 2. Request Camera Permission

```typescript
const scanner = DocScanner.getInstance();

const hasPermission = await scanner.requestCameraPermission();
if (!hasPermission) {
  console.error('Camera permission denied');
}
```

### 3. Scan a Document

```typescript
try {
  const result = await scanner.scanDocument();
  
  if (result.isSuccess && result.frontImageBlob) {
    // Upload or display the image
    const imageUrl = URL.createObjectURL(result.frontImageBlob);
    document.getElementById('preview').src = imageUrl;
  }
} catch (error) {
  console.error('Scan failed:', error);
}
```

### 4. Scan Both Sides

```typescript
try {
  const result = await scanner.scanBothSides();
  
  if (result.isSuccess) {
    if (result.frontImageBlob) {
      const frontUrl = URL.createObjectURL(result.frontImageBlob);
      // Display front
    }
    if (result.backImageBlob) {
      const backUrl = URL.createObjectURL(result.backImageBlob);
      // Display back
    }
  }
} catch (error) {
  console.error('Scan failed:', error);
}
```

## Customization

### Configure Scan Options

```typescript
const options = {
  borderColor: '#00FF00',
  borderWidth: 3,
  borderRadius: 15,
  overlayMargin: 30,
  overlayHeight: 250,
  enableFlash: false,
  enableAutoFocus: true,
  imageQuality: 95
};

const result = await scanner.scanDocument(options);
```

## API Reference

### DocScanner

Main SDK class (singleton).

#### Methods

- `getInstance()` - Get singleton instance
- `requestCameraPermission()` - Request camera access
- `hasCameraPermission()` - Check camera permission
- `scanDocument(options?)` - Scan single document
- `scanBothSides(options?)` - Scan both sides
- `getVersion()` - Get SDK version

### ScanOptions

Configuration interface.

```typescript
interface ScanOptions {
  borderColor?: string;        // Hex color (default: '#FFFFFF')
  borderWidth?: number;        // Border width in px (default: 2)
  borderRadius?: number;       // Corner radius in px (default: 10)
  overlayMargin?: number;      // Margin from edges in px (default: 50)
  overlayHeight?: number;      // Overlay height in px (default: 210)
  enableFlash?: boolean;       // Enable flash (default: false)
  enableAutoFocus?: boolean;   // Enable auto-focus (default: true)
  imageQuality?: number;       // JPEG quality 0-100 (default: 100)
}
```

### ScanResult

Result interface.

```typescript
interface ScanResult {
  frontImagePath?: string;     // Front image path (web: data URL)
  backImagePath?: string;      // Back image path (web: data URL)
  frontImageBlob?: Blob;       // Front image blob
  backImageBlob?: Blob;        // Back image blob
  timestamp: number;           // Timestamp in milliseconds
  isSuccess: boolean;          // Success status
  errorMessage?: string;       // Error message if failed
}
```

## Example

### HTML

```html
<!DOCTYPE html>
<html>
<head>
  <title>Document Scanner</title>
</head>
<body>
  <button id="scanBtn">Scan Document</button>
  <div id="result">
    <img id="frontPreview" />
    <img id="backPreview" />
  </div>
  
  <script type="module" src="app.js"></script>
</body>
</html>
```

### JavaScript

```typescript
import { DocScanner } from '@docscanner/sdk-web';

const scanner = DocScanner.getInstance();
const scanBtn = document.getElementById('scanBtn');
const frontPreview = document.getElementById('frontPreview');
const backPreview = document.getElementById('backPreview');

scanBtn.addEventListener('click', async () => {
  if (!await scanner.hasCameraPermission()) {
    const granted = await scanner.requestCameraPermission();
    if (!granted) {
      alert('Camera permission required');
      return;
    }
  }

  try {
    const result = await scanner.scanBothSides();
    
    if (result.isSuccess) {
      if (result.frontImageBlob) {
        frontPreview.src = URL.createObjectURL(result.frontImageBlob);
      }
      if (result.backImageBlob) {
        backPreview.src = URL.createObjectURL(result.backImageBlob);
      }
    }
  } catch (error) {
    console.error('Scan error:', error);
    alert('Scan failed: ' + error.message);
  }
});
```

## Architecture

```
DocScannerSDK-Web/
├── src/
│   ├── core/
│   │   └── DocScanner.ts
│   ├── utils/
│   │   ├── camera.ts
│   │   └── cropper.ts
│   ├── types/
│   │   └── index.ts
│   └── index.ts
├── dist/
├── example/
├── package.json
├── tsconfig.json
└── README.md
```

## Development

### Build

```bash
npm run build
```

### Watch Mode

```bash
npm run dev
```

### Run Tests

```bash
npm test
```

## License

MIT License - Copyright (c) 2024-2026 Tareq Abu Saleh

## Support

- **Issues**: [GitHub Issues](https://github.com/Tareq-Ghassan/DocScannerSDK-Web/issues)
- **Main Project**: [DocumentScanner-SDK](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)
- **NPM**: [@docscanner/sdk-web](https://www.npmjs.com/package/@docscanner/sdk-web)
