package com.docscanner.sdk

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class DocScannerSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pendingResult: Result? = null
    
    companion object {
        private const val CHANNEL_NAME = "doc_scanner_sdk"
        private const val REQUEST_SCAN = 1001
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "requestCameraPermission" -> {
                // Permissions are handled by the DocScannerActivity
                result.success(true)
            }
            
            "hasCameraPermission" -> {
                result.success(true)
            }
            
            "scanDocument" -> {
                if (activity == null) {
                    result.error("NO_ACTIVITY", "Activity not available", null)
                    return
                }
                
                pendingResult = result
                val options = call.arguments as? Map<String, Any>
                
                val intent = Intent(activity, DocScannerActivity::class.java)
                intent.putExtra("SCAN_BOTH_SIDES", false)
                options?.let { opts ->
                    intent.putExtra("OPTIONS", HashMap(opts))
                }
                
                activity?.startActivityForResult(intent, REQUEST_SCAN)
            }
            
            "scanBothSides" -> {
                if (activity == null) {
                    result.error("NO_ACTIVITY", "Activity not available", null)
                    return
                }
                
                pendingResult = result
                val options = call.arguments as? Map<String, Any>
                
                val intent = Intent(activity, DocScannerActivity::class.java)
                intent.putExtra("SCAN_BOTH_SIDES", true)
                options?.let { opts ->
                    intent.putExtra("OPTIONS", HashMap(opts))
                }
                
                activity?.startActivityForResult(intent, REQUEST_SCAN)
            }
            
            "getVersion" -> {
                result.success("1.0.0")
            }
            
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_SCAN) {
            val result = pendingResult ?: return false
            
            if (resultCode == Activity.RESULT_OK && data != null) {
                val response = HashMap<String, Any>()
                
                data.getStringExtra("FRONT_IMAGE_PATH")?.let {
                    response["frontImagePath"] = it
                }
                
                data.getStringExtra("BACK_IMAGE_PATH")?.let {
                    response["backImagePath"] = it
                }
                
                response["timestamp"] = System.currentTimeMillis()
                response["isSuccess"] = true
                
                result.success(response)
            } else {
                result.error("SCAN_CANCELLED", "Scan was cancelled", null)
            }
            
            pendingResult = null
            return true
        }
        return false
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
