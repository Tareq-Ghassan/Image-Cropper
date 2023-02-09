package com.bankofjordan.getcardid;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.Toast;

import com.bankofjordan.getcardidimages.MainActivityLib;

import java.util.function.Function;

public class MainActivity extends AppCompatActivity {

    Button button;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        button = (Button) findViewById(R.id.button);
        button.setOnClickListener(v -> {
            MainActivityLib mm = new MainActivityLib();
            mm.initGetCard(this,test());
        });
    }

    public Function test() {
        Toast.makeText(this, "Hello from main", Toast.LENGTH_SHORT).show();
        return null;
    }

}