
# Image Cropper App

This project is an Android application that allows users to capture an image and crop it based on white lines drawn on the screen. The app is structured using the MVVM (Model-View-ViewModel) architecture to ensure a clean separation of concerns and ease of maintainability.

## Features

- Capture images using the device camera
- Draw white lines on the captured image to define the crop area
- Crop the image based on the drawn lines
- MVVM architecture for better code management and scalability

## Getting Started

### Prerequisites

- Android Studio 4.0 or later
- Android SDK
- A physical Android device or emulator running Android 5.0 (Lollipop) or higher

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/Tareq-Ghassan/image-cropper-app.git
   ```

2. Open the project in Android Studio:
   - Go to `File > Open` and select the project directory.

3. Sync the project with Gradle files:
   - Click on the `Sync Project with Gradle Files` button in the toolbar.

### Running the App

1. Connect your Android device or start an emulator.
2. Build and run the app:
   - Click the `Run` button in the toolbar or select `Run > Run 'app'`.

### Permissions

The app requires the following permissions to function correctly:

- Camera: To capture images
- Write External Storage: To save captured images
- Read External Storage: To access saved images

These permissions are requested at runtime as per Android's permission model.

### Handling Permissions

The app checks and requests the necessary permissions at runtime. If permissions are not granted, the app will display a message and close.

### Architecture

The app follows the MVVM architecture pattern:

- **Model**: Handles the data and business logic.
- **View**: UI components (Activities and Fragments).
- **ViewModel**: Manages the UI-related data in a lifecycle-conscious way.

### Code Overview

#### MainActivityLib.java

The main activity that serves as the entry point of the app. It manages navigation between fragments and requests necessary permissions at runtime.

#### IdFragment.kt

A Fragment class that handles the image capture and cropping functionality. It interacts with the `IdViewModel` to manage UI-related data and logic.

#### IdViewModel.kt

A ViewModel class that manages the data and logic for the `IdFragment`. It uses LiveData to observe changes in the data and update the UI accordingly.

#### PhotoFragment.java

A Fragment class that handles photo-related logic. It interacts with the `PhotoViewModel` to manage UI-related data and logic.

#### PhotoViewModel.java

A ViewModel class for the `PhotoFragment`. It manages the photo data and cropping logic.

## Contributing

Contributions are welcome! Please fork the repository and use a feature branch. Pull requests are warmly welcome.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Android Developers](https://developer.android.com/) for documentation and tutorials
- [Stack Overflow](https://stackoverflow.com/) for troubleshooting and code examples
