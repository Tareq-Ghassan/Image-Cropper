# Web Example

Example web application demonstrating the DocScanner SDK.

## Setup

### NPM

```bash
npm install @docscanner/sdk-web
```

### CDN

```html
<script src="https://unpkg.com/@docscanner/sdk-web@1.0.0/dist/index.js"></script>
```

## HTML Example

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Scanner Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        
        .preview {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 20px;
        }
        
        .preview img {
            width: 100%;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        button {
            background: #007bff;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        
        button:hover {
            background: #0056b3;
        }
        
        button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <h1>Document Scanner Demo</h1>
    
    <button id="scanBtn">Scan Document</button>
    
    <div class="preview">
        <div>
            <h3>Front</h3>
            <img id="frontPreview" style="display: none;" />
        </div>
        <div>
            <h3>Back</h3>
            <img id="backPreview" style="display: none;" />
        </div>
    </div>
    
    <script type="module">
        import { DocScanner } from '@docscanner/sdk-web';
        
        const scanner = DocScanner.getInstance();
        const scanBtn = document.getElementById('scanBtn');
        const frontPreview = document.getElementById('frontPreview');
        const backPreview = document.getElementById('backPreview');
        
        scanBtn.addEventListener('click', async () => {
            scanBtn.disabled = true;
            scanBtn.textContent = 'Scanning...';
            
            try {
                // Request permission
                const hasPermission = await scanner.hasCameraPermission();
                if (!hasPermission) {
                    const granted = await scanner.requestCameraPermission();
                    if (!granted) {
                        alert('Camera permission required');
                        return;
                    }
                }
                
                // Scan both sides
                const result = await scanner.scanBothSides({
                    borderColor: '#00FF00',
                    borderWidth: 3,
                    overlayHeight: 250
                });
                
                if (result.isSuccess) {
                    // Display front image
                    if (result.frontImageBlob) {
                        const frontUrl = URL.createObjectURL(result.frontImageBlob);
                        frontPreview.src = frontUrl;
                        frontPreview.style.display = 'block';
                    }
                    
                    // Display back image
                    if (result.backImageBlob) {
                        const backUrl = URL.createObjectURL(result.backImageBlob);
                        backPreview.src = backUrl;
                        backPreview.style.display = 'block';
                    }
                } else {
                    alert('Scan failed: ' + result.errorMessage);
                }
            } catch (error) {
                console.error('Error:', error);
                alert('Error: ' + error.message);
            } finally {
                scanBtn.disabled = false;
                scanBtn.textContent = 'Scan Document';
            }
        });
    </script>
</body>
</html>
```

## TypeScript Example

```typescript
import { DocScanner, ScanOptions } from '@docscanner/sdk-web';

class DocumentScannerApp {
    private scanner: DocScanner;
    
    constructor() {
        this.scanner = DocScanner.getInstance();
        this.init();
    }
    
    private init(): void {
        const scanButton = document.getElementById('scan-btn');
        scanButton?.addEventListener('click', () => this.handleScan());
    }
    
    private async handleScan(): Promise<void> {
        try {
            // Check permission
            if (!await this.scanner.hasCameraPermission()) {
                const granted = await this.scanner.requestCameraPermission();
                if (!granted) {
                    throw new Error('Camera permission denied');
                }
            }
            
            // Configure options
            const options: ScanOptions = {
                borderColor: '#FFFFFF',
                borderWidth: 2,
                borderRadius: 10,
                overlayMargin: 50,
                overlayHeight: 210,
                imageQuality: 95
            };
            
            // Scan document
            const result = await this.scanner.scanDocument(options);
            
            if (result.isSuccess && result.frontImageBlob) {
                this.displayImage(result.frontImageBlob);
            } else {
                console.error('Scan failed:', result.errorMessage);
            }
        } catch (error) {
            console.error('Error scanning document:', error);
        }
    }
    
    private displayImage(blob: Blob): void {
        const url = URL.createObjectURL(blob);
        const img = document.createElement('img');
        img.src = url;
        document.body.appendChild(img);
    }
}

// Initialize app
new DocumentScannerApp();
```

## Browser Support

- Chrome 90+
- Firefox 88+
- Safari 15+
- Edge 90+

## Requirements

- HTTPS (required for camera access)
- Modern browser with MediaDevices API support
- Camera permission

See the [main README](../README.md) for more details.
