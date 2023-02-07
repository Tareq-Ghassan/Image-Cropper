package com.bankofjordan.getcardid;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;

import com.bankofjordan.getcardidimages.MainActivityLib;

public class MainActivity extends AppCompatActivity {

    Button button;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        button = (Button) findViewById(R.id.button);
        button.setOnClickListener(v -> {
            Intent myIntent = new Intent(MainActivity.this, MainActivityLib.class);
            startActivity(myIntent);
        });
    }


}