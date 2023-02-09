package com.bankofjordan.getcardidimages

import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.Navigation
import java.io.File
import java.util.function.Function

class MainActivityLib : AppCompatActivity() {
    private val CAMERA_REQ = 101
    private val WRITE_REQ = 102
    private val READ_REQ = 103

    private lateinit var viewModel: IdViewModel
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main_lib)

        Navigation.findNavController(this,R.id.nav_host_fragment)

        viewModel = run {
            ViewModelProvider(this)[IdViewModel::class.java]
        }

        permissions()
    }
    override fun onDestroy() {
        super.onDestroy()
        if(!viewModel.FrontFile.value.isNullOrEmpty()){
            File(viewModel.FrontFile.value!!).delete()
        }
        if(!viewModel.BackFile.value.isNullOrEmpty()){
            File(viewModel.BackFile.value!!).delete()
        }
    }

    //********************************Check Permission*****************************//

    private fun permissions(){
        checkPermissions(android.Manifest.permission.CAMERA,"camera",CAMERA_REQ)
        checkPermissions(android.Manifest.permission.WRITE_EXTERNAL_STORAGE,"write external storage",WRITE_REQ)
        checkPermissions(android.Manifest.permission.READ_EXTERNAL_STORAGE,"read external storage",READ_REQ)
    }

    private fun checkPermissions(permission: String, name: String, reqCode: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            when{
                ContextCompat.checkSelfPermission(applicationContext,permission)== PackageManager.PERMISSION_GRANTED ->{
                }
                else -> ActivityCompat.requestPermissions(this, arrayOf(permission),reqCode)
            }
        }
    }
}