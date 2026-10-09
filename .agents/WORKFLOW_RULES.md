# DocScanner SDK — Workflow Rules

## Independent releases

Each platform SDK (`DocScannerSDK-Android`, `-iOS`, `-Flutter`, …) is released
**independently**. Do not mirror branches or force-sync version numbers across repos.

## Flutter is a wrapper

- **Android**: depend on JitPack `DocScannerSDK-Android` — never copy Kotlin into Flutter.
- **iOS / macOS**: keep a **source snapshot** under `flutter/ios` / `flutter/macos`.
- **Web**: Dart MediaDevices implementation (does not have to npm-depend on `@docscanner/sdk-web`).
- Implement camera / white crop overlay / crop math in **native** SDKs only.

## Issues

Open issues in the repo that owns the files. Always set assignee, labels,
milestone, and project (`DocScanner`) — see `.cursor/rules/github-issues.mdc`.

## Docs sync

After any product change, sweep README / EXAMPLES / TESTING / CHANGELOG /
PUBLISHING_GUIDE / `.agents/*` / issue templates across umbrella + affected SDKs
(`.cursor/rules/docs-sync.mdc`).

## Releases

A git tag is not a GitHub Release. Workflows must call `softprops/action-gh-release`
(`.cursor/rules/github-releases.mdc`).

## Merged branches

Delete remote + local feature branches after merge
(`.cursor/rules/delete-merged-branches.mdc`).
