package com.docscanner.sdk

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ImageFormat
import android.graphics.Matrix
import android.graphics.Rect
import android.graphics.YuvImage
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.docscanner.sdk.databinding.FragmentScanBinding
import com.google.android.material.snackbar.Snackbar
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/**
 * Modern Camera Fragment using CameraX API
 * Displays camera preview with fixed crop overlay and captures cropped images
 */
class ScanFragment : Fragment() {
    
    private var _binding: FragmentScanBinding? = null
    private val binding get() = _binding!!
    
    private lateinit var viewModel: ScanViewModel
    private lateinit var cameraExecutor: ExecutorService
    
    private var imageCapture: ImageCapture? = null
    private var camera: Camera? = null
    private var preview: Preview? = null
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        cameraExecutor = Executors.newSingleThreadExecutor()
    }
    
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentScanBinding.inflate(inflater, container, false)
        return binding.root
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        viewModel = ViewModelProvider(requireActivity())[ScanViewModel::class.java]
        
        setupCamera()
        setupUI()
    }
    
    private fun setupUI() {
        binding.captureButton.setOnClickListener {
            capturePhoto()
        }
        
        binding.flashButton.setOnClickListener {
            toggleFlash()
        }
        
        // Show instruction
        showInstruction()
    }
    
    private fun setupCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(requireContext())
        
        cameraProviderFuture.addListener({
            val cameraProvider = cameraProviderFuture.get()
            bindCameraUseCases(cameraProvider)
        }, ContextCompat.getMainExecutor(requireContext()))
    }
    
    private fun bindCameraUseCases(cameraProvider: ProcessCameraProvider) {
        // Preview use case
        preview = Preview.Builder()
            .build()
            .also {
                it.setSurfaceProvider(binding.previewView.surfaceProvider)
            }
        
        // Image capture use case with high quality
        imageCapture = ImageCapture.Builder()
            .setCaptureMode(ImageCapture.CAPTURE_MODE_MAXIMIZE_QUALITY)
            .setTargetRotation(binding.previewView.display.rotation)
            .build()
        
        // Image analysis for auto-focus and exposure
        val imageAnalyzer = ImageAnalysis.Builder()
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .build()
        
        // Select back camera as default
        val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA
        
        try {
            // Unbind all use cases before rebinding
            cameraProvider.unbindAll()
            
            // Bind use cases to camera
            camera = cameraProvider.bindToLifecycle(
                viewLifecycleOwner,
                cameraSelector,
                preview,
                imageCapture,
                imageAnalyzer
            )
            
            // Enable tap to focus
            setupTapToFocus()
            
        } catch (exc: Exception) {
            Log.e(TAG, "Use case binding failed", exc)
            showError("Failed to start camera")
        }
    }
    
    private fun setupTapToFocus() {
        binding.previewView.setOnTouchListener { _, event ->
            val meteringPointFactory = binding.previewView.meteringPointFactory
            val focusPoint = meteringPointFactory.createPoint(event.x, event.y)
            
            val action = FocusMeteringAction.Builder(focusPoint)
                .setAutoCancelDuration(3, java.util.concurrent.TimeUnit.SECONDS)
                .build()
            
            camera?.cameraControl?.startFocusAndMetering(action)
            
            // Show focus indicator
            showFocusIndicator(event.x, event.y)
            
            true
        }
    }
    
    private fun showFocusIndicator(x: Float, y: Float) {
        // TODO: Show a circle animation at the tap location
    }
    
    private fun capturePhoto() {
        val imageCapture = imageCapture ?: return
        
        binding.captureButton.isEnabled = false
        binding.progressBar.visibility = View.VISIBLE
        
        imageCapture.takePicture(
            cameraExecutor,
            object : ImageCapture.OnImageCapturedCallback() {
                override fun onCaptureSuccess(image: ImageProxy) {
                    val bitmap = imageProxyToBitmap(image)
                    image.close()
                    
                    if (bitmap != null) {
                        val croppedBitmap = cropToOverlay(bitmap)
                        saveCroppedImage(croppedBitmap)
                    } else {
                        showError("Failed to process image")
                        enableCaptureButton()
                    }
                }
                
                override fun onError(exception: ImageCaptureException) {
                    Log.e(TAG, "Photo capture failed", exception)
                    showError("Failed to capture photo")
                    enableCaptureButton()
                }
            }
        )
    }
    
    private fun imageProxyToBitmap(image: ImageProxy): Bitmap? {
        val buffer = image.planes[0].buffer
        val bytes = ByteArray(buffer.remaining())
        buffer.get(bytes)
        
        var bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
        
        // Rotate bitmap if needed
        bitmap = rotateBitmap(bitmap, image.imageInfo.rotationDegrees)
        
        return bitmap
    }
    
    private fun rotateBitmap(bitmap: Bitmap, degrees: Int): Bitmap {
        if (degrees == 0) return bitmap
        
        val matrix = Matrix()
        matrix.postRotate(degrees.toFloat())
        
        return Bitmap.createBitmap(
            bitmap, 0, 0,
            bitmap.width, bitmap.height,
            matrix, true
        )
    }
    
    private fun cropToOverlay(originalBitmap: Bitmap): Bitmap {
        // Get overlay dimensions
        val overlayLeft = binding.overlayView.left
        val overlayTop = binding.overlayView.top
        val overlayWidth = binding.overlayView.width
        val overlayHeight = binding.overlayView.height
        
        // Get preview dimensions
        val previewWidth = binding.previewView.width
        val previewHeight = binding.previewView.height
        
        // Calculate scale factors
        val scaleX = originalBitmap.width.toFloat() / previewWidth
        val scaleY = originalBitmap.height.toFloat() / previewHeight
        
        // Calculate crop bounds
        val cropX = (overlayLeft * scaleX).toInt()
        val cropY = (overlayTop * scaleY).toInt()
        val cropWidth = (overlayWidth * scaleX).toInt()
        val cropHeight = (overlayHeight * scaleY).toInt()
        
        // Ensure bounds are within bitmap
        val safeCropX = cropX.coerceIn(0, originalBitmap.width)
        val safeCropY = cropY.coerceIn(0, originalBitmap.height)
        val safeCropWidth = cropWidth.coerceAtMost(originalBitmap.width - safeCropX)
        val safeCropHeight = cropHeight.coerceAtMost(originalBitmap.height - safeCropY)
        
        return Bitmap.createBitmap(
            originalBitmap,
            safeCropX,
            safeCropY,
            safeCropWidth,
            safeCropHeight
        )
    }
    
    private fun saveCroppedImage(bitmap: Bitmap) {
        try {
            val file = createImageFile()
            
            FileOutputStream(file).use { out ->
                bitmap.compress(Bitmap.CompressFormat.JPEG, 95, out)
            }
            
            // Store path in ViewModel
            if (viewModel.scanMode.value == ScanMode.FRONT) {
                viewModel.setFrontImagePath(file.absolutePath)
                // Check if we need to scan back side
                if (viewModel.needsBackScan()) {
                    viewModel.setScanMode(ScanMode.BACK)
                    showInstruction()
                    enableCaptureButton()
                } else {
                    finishScanning()
                }
            } else {
                viewModel.setBackImagePath(file.absolutePath)
                finishScanning()
            }
            
        } catch (e: Exception) {
            Log.e(TAG, "Error saving image", e)
            showError("Failed to save image")
            enableCaptureButton()
        }
    }
    
    private fun createImageFile(): File {
        val timeStamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(Date())
        val fileName = "DOC_${timeStamp}.jpg"
        val storageDir = requireContext().cacheDir
        return File(storageDir, fileName)
    }
    
    private fun toggleFlash() {
        camera?.let {
            val currentMode = it.cameraInfo.torchState.value
            it.cameraControl.enableTorch(currentMode != TorchState.ON)
            
            // Update flash button icon
            updateFlashButton()
        }
    }
    
    private fun updateFlashButton() {
        camera?.let {
            val isOn = it.cameraInfo.torchState.value == TorchState.ON
            binding.flashButton.setImageResource(
                if (isOn) R.drawable.ic_flash_on else R.drawable.ic_flash_off
            )
        }
    }
    
    private fun showInstruction() {
        val message = when (viewModel.scanMode.value) {
            ScanMode.FRONT -> "Position the front of the document within the frame"
            ScanMode.BACK -> "Position the back of the document within the frame"
            else -> "Position the document within the frame"
        }
        
        binding.instructionText.text = message
    }
    
    private fun finishScanning() {
        requireActivity().setResult(android.app.Activity.RESULT_OK)
        requireActivity().finish()
    }
    
    private fun showError(message: String) {
        requireActivity().runOnUiThread {
            Snackbar.make(binding.root, message, Snackbar.LENGTH_SHORT).show()
        }
    }
    
    private fun enableCaptureButton() {
        requireActivity().runOnUiThread {
            binding.captureButton.isEnabled = true
            binding.progressBar.visibility = View.GONE
        }
    }
    
    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
    
    override fun onDestroy() {
        super.onDestroy()
        cameraExecutor.shutdown()
    }
    
    companion object {
        private const val TAG = "ScanFragment"
    }
}
