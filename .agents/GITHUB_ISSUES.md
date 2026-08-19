# GitHub Issues Template

Create these issues in the main DocumentScanner-SDK repository to track progress.

## Issue 1: Setup Platform Repositories

**Title:** Setup separate GitHub repositories for all platforms

**Labels:** `enhancement`, `infrastructure`

**Body:**
```markdown
## Description

Create separate GitHub repositories for each platform SDK following the multi-platform architecture.

## Repositories to Create

- [ ] DocScannerSDK-Android
- [ ] DocScannerSDK-iOS
- [ ] DocScannerSDK-Web
- [ ] DocScannerSDK-Windows
- [ ] DocScannerSDK-macOS
- [ ] DocScannerSDK-Linux
- [ ] DocScannerSDK-Flutter

## Steps

1. Run `.agents/create-github-repos.sh`
2. Push code from each platform directory to its repository
3. Convert directories to git submodules
4. Update main repository `.gitmodules`

## References

- Architecture: `.agents/MULTI_PLATFORM_ARCHITECTURE.md`
- Setup Guide: `.agents/CREATE_REPOS.md`

## Acceptance Criteria

- All 7 repositories created
- Code pushed to each repository
- Submodules configured in main repo
- All repos have README and LICENSE
```

---

## Issue 2: Publish Android SDK to JitPack

**Title:** Publish Android SDK to JitPack

**Labels:** `android`, `publishing`, `enhancement`

**Body:**
```markdown
## Description

Publish the Android SDK to JitPack for easy integration.

## Steps

1. Push Android code to DocScannerSDK-Android repository
2. Create git tag `v1.0.0`
3. Create GitHub Release
4. Verify JitPack build at https://jitpack.io/#Tareq-Ghassan/DocScannerSDK-Android

## Configuration

- ✅ `build.gradle` configured with maven-publish
- ✅ `jitpack.yml` created
- ✅ GitHub Actions workflow ready

## Testing

Add to test app:
```gradle
implementation 'com.github.Tareq-Ghassan:DocScannerSDK-Android:1.0.0'
```

## Acceptance Criteria

- SDK available on JitPack
- Example app works with JitPack dependency
- Badge updated in README
```

---

## Issue 3: Publish iOS SDK to CocoaPods

**Title:** Publish iOS SDK to CocoaPods and SPM

**Labels:** `ios`, `publishing`, `enhancement`

**Body:**
```markdown
## Description

Publish the iOS SDK to CocoaPods Trunk and ensure SPM support.

## Steps

### CocoaPods

1. Register with CocoaPods Trunk: `pod trunk register email@example.com`
2. Verify podspec: `pod spec lint DocScannerSDK.podspec --allow-warnings`
3. Push to trunk: `pod trunk push DocScannerSDK.podspec --allow-warnings`

### Swift Package Manager

1. Create GitHub release with tag `v1.0.0`
2. SPM will automatically work from the release

## Configuration

- ✅ `DocScannerSDK.podspec` created
- ✅ `Package.swift` created
- ✅ GitHub Actions workflow ready

## Testing

**CocoaPods:**
```ruby
pod 'DocScannerSDK', '~> 1.0.0'
```

**SPM:**
```swift
.package(url: "https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git", from: "1.0.0")
```

## Acceptance Criteria

- Available on CocoaPods
- SPM works from GitHub
- Example app works with both methods
```

---

## Issue 4: Publish Web SDK to NPM

**Title:** Publish Web SDK to NPM

**Labels:** `web`, `publishing`, `enhancement`

**Body:**
```markdown
## Description

Publish the Web SDK to NPM registry.

## Steps

1. Login to NPM: `npm login`
2. Build: `npm run build`
3. Test: `npm test`
4. Publish: `npm publish --access public`

## Configuration

- ✅ `package.json` configured
- ✅ Build scripts ready
- ✅ GitHub Actions workflow ready

## Testing

```bash
npm install @docscanner/sdk-web
```

## Acceptance Criteria

- Published to NPM
- Example works with NPM package
- Badge updated in README
```

---

## Issue 5: Publish Flutter Plugin to pub.dev

**Title:** Publish Flutter plugin to pub.dev

**Labels:** `flutter`, `publishing`, `enhancement`

**Body:**
```markdown
## Description

Publish the Flutter plugin to pub.dev.

## Steps

1. Login: `flutter pub login`
2. Dry run: `flutter pub publish --dry-run`
3. Fix any issues
4. Publish: `flutter pub publish`

## Pana Score Target

**Target: 160/160**

Run check:
```bash
./check-pana-score.sh flutter
```

## Configuration

- ✅ `pubspec.yaml` complete with all metadata
- ✅ All platforms implemented
- ✅ Example app included
- ✅ CHANGELOG.md
- ✅ README.md with examples
- ✅ analysis_options.yaml

## Testing

```yaml
dependencies:
  doc_scanner_sdk: ^1.0.0
```

## Acceptance Criteria

- Published to pub.dev
- Pana score: 160/160
- All platforms work
- Example app runs on all platforms
```

---

## Issue 6: Add Platform-Specific Examples

**Title:** Create comprehensive example apps for all platforms

**Labels:** `documentation`, `examples`, `enhancement`

**Body:**
```markdown
## Description

Create working example applications for each platform SDK.

## Examples Needed

- [x] Flutter example app (completed)
- [x] Android example (README with code)
- [x] iOS example (README with code)
- [x] Web example (README with HTML/TS)
- [ ] macOS example app
- [ ] Windows example app (when SDK ready)
- [ ] Linux example app (when SDK ready)

## Requirements

Each example should demonstrate:
- Permission handling
- Single document scan
- Both sides scan
- Image display
- Error handling

## Acceptance Criteria

- Example for each platform
- Well-commented code
- README with instructions
- Screenshots in docs
```

---

## Issue 7: Run Pana and Achieve 160/160 Score

**Title:** Ensure Flutter plugin achieves perfect pana score (160/160)

**Labels:** `flutter`, `quality`, `documentation`

**Body:**
```markdown
## Description

Run pana analysis and fix any issues to achieve a perfect 160/160 score.

## How to Check

```bash
cd flutter
flutter pub global activate pana
flutter pub global run pana --no-warning
```

## Checklist

- [x] All required fields in pubspec.yaml
- [x] Description > 60 characters
- [x] Homepage, repository, documentation URLs
- [x] Platforms properly configured
- [x] Example app included
- [x] CHANGELOG.md present
- [x] LICENSE file
- [x] README with examples
- [x] analysis_options.yaml
- [ ] Run actual pana check
- [ ] Fix any warnings
- [ ] Verify 160/160 score

## Current Status

All files and structure in place. Need to run actual pana check.

## Acceptance Criteria

- Pana score: 160/160
- No warnings
- All checks pass
- Ready for pub.dev publication
```

---

## Issue 8: Setup CI/CD for All Platforms

**Title:** Verify and test CI/CD workflows for all platforms

**Labels:** `ci/cd`, `automation`, `testing`

**Body:**
```markdown
## Description

Test all GitHub Actions workflows to ensure automated builds and publishing work.

## Workflows to Test

- [x] `android-ci.yml` - Created
- [x] `ios-ci.yml` - Created
- [x] `web-ci.yml` - Created
- [x] `flutter-ci.yml` - Created
- [ ] Test on actual push
- [ ] Test on pull request
- [ ] Test on release

## Required Secrets

Add these to repository settings:

- `COCOAPODS_TRUNK_TOKEN` (iOS)
- `NPM_TOKEN` (Web)
- `PUB_CREDENTIALS` (Flutter)
- `NUGET_API_KEY` (Windows, when ready)

## Acceptance Criteria

- All workflows run successfully
- Build artifacts generated
- Tests pass
- Publishing works on release
```

---

## Issue 9: Create Release Process Documentation

**Title:** Document the release process for all platforms

**Labels:** `documentation`, `process`

**Body:**
```markdown
## Description

Create comprehensive documentation for the release process.

## Documents to Create/Update

- [x] PUBLISHING.md (completed)
- [x] publish.sh script (completed)
- [ ] RELEASE_CHECKLIST.md
- [ ] VERSIONING.md
- [ ] CONTRIBUTING.md

## Release Checklist Template

Should include:
1. Version bump procedure
2. CHANGELOG update
3. Testing checklist
4. Git tagging
5. GitHub release creation
6. Package manager publishing
7. Verification steps
8. Rollback procedure

## Acceptance Criteria

- Clear step-by-step process
- Checklist for each platform
- Examples provided
- Common issues documented
```

---

## Issue 10: Add Screenshots and Media

**Title:** Add screenshots and demo media to all READMEs

**Labels:** `documentation`, `design`

**Body:**
```markdown
## Description

Add visual content to make the documentation more engaging.

## Media Needed

- [ ] Scanner overlay screenshot (Android)
- [ ] Scanner overlay screenshot (iOS)  
- [ ] Web demo screenshot
- [ ] Demo GIF showing scan flow
- [ ] Architecture diagram
- [ ] Platform comparison chart

## Locations

- Main README
- Each platform README
- pub.dev listing (Flutter)
- NPM listing (Web)

## Acceptance Criteria

- Professional screenshots
- Consistent styling
- Added to relevant READMEs
- Proper attribution if using stock images
```

---

## How to Create These Issues

Run this command for each issue:

```bash
gh issue create --title "TITLE" --body "BODY" --label "LABELS"
```

Or use the GitHub web interface:
1. Go to https://github.com/Tareq-Ghassan/DocumentScanner-SDK/issues/new
2. Copy/paste title and body
3. Add labels
4. Submit
