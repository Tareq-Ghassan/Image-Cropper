package com.docscanner.sdk

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import java.io.File

enum class ScanMode {
    FRONT, BACK, SINGLE
}

/**
 * ViewModel for managing scan state and captured images
 */
class ScanViewModel : ViewModel() {
    
    private val _frontImagePath = MutableLiveData<String?>()
    val frontImagePath: LiveData<String?> = _frontImagePath
    
    private val _backImagePath = MutableLiveData<String?>()
    val backImagePath: LiveData<String?> = _backImagePath
    
    private val _scanMode = MutableLiveData(ScanMode.FRONT)
    val scanMode: LiveData<ScanMode> = _scanMode
    
    private val _requiresBothSides = MutableLiveData(false)
    val requiresBothSides: LiveData<Boolean> = _requiresBothSides
    
    fun setFrontImagePath(path: String) {
        _frontImagePath.value = path
    }
    
    fun setBackImagePath(path: String) {
        _backImagePath.value = path
    }
    
    fun setScanMode(mode: ScanMode) {
        _scanMode.value = mode
    }
    
    fun setRequiresBothSides(requires: Boolean) {
        _requiresBothSides.value = requires
    }
    
    fun needsBackScan(): Boolean {
        return _requiresBothSides.value == true && _backImagePath.value == null
    }
    
    fun cleanup() {
        // Delete temporary files
        _frontImagePath.value?.let { path ->
            try {
                File(path).delete()
            } catch (e: Exception) {
                // Ignore errors
            }
        }
        
        _backImagePath.value?.let { path ->
            try {
                File(path).delete()
            } catch (e: Exception) {
                // Ignore errors
            }
        }
    }
    
    override fun onCleared() {
        super.onCleared()
        cleanup()
    }
}
