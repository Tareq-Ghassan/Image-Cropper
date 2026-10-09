# Testing DocScanner SDK

## What to verify (every platform)

1. Live camera preview starts
2. **White crop rectangle** is visible and centered
3. Outside the rectangle is dimmed
4. Capture crops **only** the region inside the rectangle
5. Front / back / single-side flows return correct paths
6. Permission denial is handled cleanly
7. Flutter only launches native UI — no Dart-drawn crop frame on mobile

## Layers

| Layer | Location | Focus |
|-------|----------|-------|
| Native SDK | `android/`, `ios/`, … | Overlay geometry, crop math, camera lifecycle |
| Flutter plugin | `flutter/` | Method channel mapping, Activity/VC presentation |
| Example apps | `*/example` | End-to-end smoke |

## Flutter quality gate (pub.dev)

```bash
cd flutter
../check-pana-score.sh   # expects 160/160
dart format --output=none --set-exit-if-changed lib
flutter analyze
```

CI: `.github/workflows/pana-check.yml` and `flutter/.github/workflows/pana.yml`.

## Platform notes

- **Android / iOS**: full CameraX / AVFoundation crop-on-capture
- **Web**: canvas crop to overlay DOM rect
- **Windows / Linux / macOS**: API surface present; deepen MediaCapture / OpenCV / AppKit in follow-ups
