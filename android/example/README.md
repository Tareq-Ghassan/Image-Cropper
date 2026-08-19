# Android Example

Example Android app demonstrating the DocScanner SDK.

## Setup

1. Add JitPack repository in your `settings.gradle`:
   ```gradle
   dependencyResolutionManagement {
       repositories {
           maven { url 'https://jitpack.io' }
       }
   }
   ```

2. Add dependency in your `app/build.gradle`:
   ```gradle
   dependencies {
       implementation 'com.github.Tareq-Ghassan:DocScannerSDK-Android:1.0.0'
   }
   ```

3. Launch the scanner:
   ```kotlin
   val intent = Intent(this, DocScannerActivity::class.java)
   startActivityForResult(intent, REQUEST_SCAN)
   ```

## Full Example

```kotlin
class MainActivity : AppCompatActivity() {
    companion object {
        const val REQUEST_SCAN = 1001
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<Button>(R.id.scanButton).setOnClickListener {
            startScanner()
        }
    }

    private fun startScanner() {
        val intent = Intent(this, DocScannerActivity::class.java)
        startActivityForResult(intent, REQUEST_SCAN)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
        if (requestCode == REQUEST_SCAN && resultCode == RESULT_OK && data != null) {
            val frontPath = data.getStringExtra("FRONT_IMAGE_PATH")
            val backPath = data.getStringExtra("BACK_IMAGE_PATH")
            
            frontPath?.let { path ->
                val bitmap = BitmapFactory.decodeFile(path)
                findViewById<ImageView>(R.id.frontImage).setImageBitmap(bitmap)
            }
            
            backPath?.let { path ->
                val bitmap = BitmapFactory.decodeFile(path)
                findViewById<ImageView>(R.id.backImage).setImageBitmap(bitmap)
            }
        }
    }
}
```

## Requirements

- Android API 24+
- Camera permission in manifest
- JitPack repository

See the [main README](../README.md) for more details.
