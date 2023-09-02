package com.bankofjordan.getcardidimages;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.Navigation;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import java.io.File;

public class MainActivityLib extends AppCompatActivity {
    private final int CAMERA_REQ = 101;
    private final int WRITE_REQ = 102;
    private final int READ_REQ = 103;
    private IdViewModel viewModel;
    Runnable callback;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_lib);
        viewModel = new ViewModelProvider(this).get(IdViewModel.class);
        Navigation.findNavController((Activity) this, R.id.nav_host_fragment);
        permissions();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        String front = viewModel.getFrontFile().getValue();
        String back = viewModel.getBackFile().getValue();
        front = (front == null) ? "" : front;
        back = (back == null) ? "" : back;
        if (front.length() > 0) {
            new File(front).delete();
        }
        if (back.length() > 0) {
            new File(back).delete();
        }
    }

    // This is the function you have to call inside your app
    public void initGetCard(Context context, final Runnable func) {
        callback = func;
        callback.run();
        Intent myIntent = new Intent(context, MainActivityLib.class);
        context.startActivity(myIntent);

    }


    //********************************Check Permission*****************************//
    private final void permissions() {
        this.checkPermissions("android.permission.CAMERA", "camera", this.CAMERA_REQ);
        this.checkPermissions("android.permission.WRITE_EXTERNAL_STORAGE", "write external storage", this.WRITE_REQ);
        this.checkPermissions("android.permission.READ_EXTERNAL_STORAGE", "read external storage", this.READ_REQ);
    }

    private final void checkPermissions(String permission, String name, int reqCode) {
        if (Build.VERSION.SDK_INT >= 23 && ContextCompat.checkSelfPermission(this.getApplicationContext(), permission) != 0) {
            ActivityCompat.requestPermissions((Activity) this, new String[]{permission}, reqCode);
        }
    }
}
