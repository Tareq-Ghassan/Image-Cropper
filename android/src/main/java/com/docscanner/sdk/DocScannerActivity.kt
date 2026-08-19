package com.docscanner.sdk

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.NavController
import androidx.navigation.fragment.NavHostFragment
import com.google.android.material.snackbar.Snackbar

/**
 * Main Activity for the Document Scanner SDK
 * Handles camera permissions and navigation between fragments
 */
class DocScannerActivity : AppCompatActivity() {
    
    private lateinit var viewModel: ScanViewModel
    private lateinit var navController: NavController
    
    private val permissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        val allGranted = permissions.entries.all { it.value }
        if (allGranted) {
            navigateToScanner()
        } else {
            showPermissionDenied()
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_doc_scanner)
        
        viewModel = ViewModelProvider(this)[ScanViewModel::class.java]
        
        val navHostFragment = supportFragmentManager
            .findFragmentById(R.id.nav_host_fragment) as NavHostFragment
        navController = navHostFragment.navController
        
        checkAndRequestPermissions()
    }
    
    private fun checkAndRequestPermissions() {
        val permissions = mutableListOf(Manifest.permission.CAMERA)
        
        // Request storage permission only on Android 12 and below
        if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.S_V2) {
            permissions.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
            permissions.add(Manifest.permission.READ_EXTERNAL_STORAGE)
        }
        
        val permissionsToRequest = permissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }
        
        if (permissionsToRequest.isEmpty()) {
            navigateToScanner()
        } else {
            permissionLauncher.launch(permissionsToRequest.toTypedArray())
        }
    }
    
    private fun navigateToScanner() {
        if (navController.currentDestination?.id == R.id.scanFragment) {
            return
        }
        navController.navigate(R.id.scanFragment)
    }
    
    private fun showPermissionDenied() {
        Snackbar.make(
            findViewById(android.R.id.content),
            "Camera permission is required to scan documents",
            Snackbar.LENGTH_LONG
        ).show()
        finish()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        // Clean up temporary files
        viewModel.cleanup()
    }
}
