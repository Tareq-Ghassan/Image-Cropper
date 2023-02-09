package com.bankofjordan.getcardidimages;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.hardware.Camera;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.Navigation;

import android.os.Environment;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Toast;

import com.bankofjordan.getcardidimages.databinding.FragmentPhotoBinding;

import org.jetbrains.annotations.Nullable;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;


public class PhotoFragment extends Fragment implements SurfaceHolder.Callback {
    Camera camera;

    private IdViewModel viewModel;

    SurfaceView surfaceView;
    SurfaceHolder surfaceHolder;
    boolean previewing = false;
    Context context;
    private FragmentPhotoBinding binding;

    Camera.Size previewSizeOptimal;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ((AppCompatActivity) getActivity()).getSupportActionBar().hide();
        View decorView = ((AppCompatActivity) getActivity()).getWindow().getDecorView();
        int uiOptions = View.SYSTEM_UI_FLAG_FULLSCREEN;
        decorView.setSystemUiVisibility(uiOptions);
        this.setRetainInstance(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_photo, container, false);
        binding = FragmentPhotoBinding.bind(view);
        context = getContext();

        surfaceView = (SurfaceView) view.findViewById(R.id.camera_preview_surface);
        surfaceHolder = surfaceView.getHolder();
        surfaceHolder.addCallback(this);
        surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);

        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @androidx.annotation.Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        viewModel = new ViewModelProvider(getActivity()).get(IdViewModel.class);

        binding.makePhotoButton.setOnClickListener(v -> {
            makePhoto();
        });
    }

    /*take Picture function*/
    public void makePhoto() {
        if (camera != null) {
            camera.takePicture(myShutterCallback,
                    myPictureCallback_RAW, myPictureCallback_JPG);
        }
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        camera = Camera.open();
    }


    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        if (previewing) {
            camera.stopPreview();
            previewing = false;
        }

        //set and get camera praameters
        if (camera != null) {
            try {
                Camera.Parameters parameters = camera.getParameters();

                if (camera.getParameters().getFocusMode().contains(Camera.Parameters.FOCUS_MODE_AUTO)) {
                    parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE);
                }
                if (camera.getParameters().getFlashMode().contains(Camera.Parameters.FLASH_MODE_AUTO)) {
                    parameters.setFlashMode(Camera.Parameters.FLASH_MODE_AUTO);
                }

                camera.setParameters(parameters);

                //rotate screen, because camera sensor usually in landscape mode
                Display display = ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();
                if (display.getRotation() == Surface.ROTATION_0) {
                    camera.setDisplayOrientation(90);
                } else if (display.getRotation() == Surface.ROTATION_270) {
                    camera.setDisplayOrientation(180);
                }


                camera.setPreviewDisplay(surfaceHolder);
                camera.startPreview();
                previewing = true;
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                Toast.makeText(context, "Faild! Try Again", Toast.LENGTH_SHORT).show();
                Navigation.findNavController(getView()).popBackStack();
            }
        }
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        camera.stopPreview();
        camera.release();
        camera = null;
        previewing = false;
    }


    Camera.ShutterCallback myShutterCallback = new Camera.ShutterCallback() {
        @Override
        public void onShutter() {

        }
    };
    Camera.PictureCallback myPictureCallback_RAW = new Camera.PictureCallback() {
        @Override
        public void onPictureTaken(byte[] data, Camera camera) {

        }
    };

    /*create picture bitmap*/
    Camera.PictureCallback myPictureCallback_JPG = new Camera.PictureCallback() {
        @Override
        public void onPictureTaken(byte[] data, Camera camera) {
            Bitmap bitmapPicture
                    = BitmapFactory.decodeByteArray(data, 0, data.length);

            Bitmap croppedBitmap = null;


            Display display = ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();
            if (display.getRotation() == Surface.ROTATION_0) {

                //rotate bitmap, because camera sensor usually in landscape mode
                Matrix matrix = new Matrix();
                matrix.postRotate(90);
                Bitmap rotatedBitmap = Bitmap.createBitmap(bitmapPicture, 0, 0, bitmapPicture.getWidth(), bitmapPicture.getHeight(), matrix, true);

                //calculate aspect ratio
                float koefX = (float) rotatedBitmap.getWidth() / (float) binding.previewLayout.getWidth();
                float koefY = (float) rotatedBitmap.getHeight() / (float) binding.previewLayout.getHeight();

                //get viewfinder border size and position on the screen;
                int x1 = binding.borderCamera.getLeft() * 2;
                int y1 = binding.borderCamera.getTop();

                int x2 = binding.borderCamera.getWidth() - (binding.borderCamera.getLeft() * 2);
                int y2 = binding.borderCamera.getHeight();

                //calculate position and size for cropping
                int cropStartX = Math.round(x1 * koefX);
                int cropStartY = Math.round(y1 * koefY);

                int cropWidthX = Math.round(x2 * koefX);
                int cropHeightY = Math.round(y2 * koefY);


                if (cropStartX + cropWidthX <= rotatedBitmap.getWidth() && cropStartY + cropHeightY <= rotatedBitmap.getHeight()) {
                    croppedBitmap = Bitmap.createBitmap(rotatedBitmap, cropStartX, cropStartY, cropWidthX, cropHeightY);
                } else {
                    croppedBitmap = null;
                }

                //save result
                if (croppedBitmap != null) {
                    createImageFile(croppedBitmap);

                }

            } else if (display.getRotation() == Surface.ROTATION_270) {
                // for Landscape mode
            }


            if (camera != null) {
                camera.startPreview();
            }
        }
    };

    /*save picture as file*/
    public void createImageFile(final Bitmap bitmap) {
        File path;
        if (Environment.isExternalStorageEmulated() && Environment.isExternalStorageRemovable()) {
            path = getContext().getFilesDir();
        } else {
            path = Environment.getExternalStoragePublicDirectory(
                    Environment.DIRECTORY_PICTURES);
        }

        String timeStamp = new SimpleDateFormat("MMdd_HHmmssSSS").format(new Date());
        String imageFileName = "region_" + timeStamp + ".jpg";
        final File file = new File(path, imageFileName);

        try {
            // Make sure the Pictures directory exists.
            if (path.mkdirs()) {
                Toast.makeText(context, "Not exist :" + path.getName(), Toast.LENGTH_SHORT).show();
            }

            OutputStream os = new FileOutputStream(file);

            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);

            os.flush();
            os.close();
            Log.i("ExternalStorage", "Writed " + path + file.getName());
            //base46 encoding


            // Tell the media scanner about the new file so that it is
            // immediately available to the user.
            MediaScannerConnection.scanFile(context,
                    new String[]{file.toString()}, null,
                    new MediaScannerConnection.OnScanCompletedListener() {
                        public void onScanCompleted(String path, Uri uri) {
                            Log.i("ExternalStorage", "Scanned " + path + ":");
                            Log.i("ExternalStorage", "-> uri=" + uri);
                        }
                    });

            Toast.makeText(context, file.getName(), Toast.LENGTH_SHORT).show();

            int numButton = viewModel.getNumButton().getValue();

            if (numButton == 2) {
                viewModel.backFile(file.getAbsolutePath());
            } else {
                viewModel.frontFile(file.getAbsolutePath());
            }
            Navigation.findNavController(getView()).popBackStack();

        } catch (Exception e) {
            // Unable to create file, likely because external storage is
            // not currently mounted.
            Log.w("ExternalStorage", "Error writing " + file, e);
            Toast.makeText(context, "Faild! Try Again", Toast.LENGTH_SHORT).show();
            Navigation.findNavController(getView()).popBackStack();
        }
    }
}