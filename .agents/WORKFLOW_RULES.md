# Workflow Rules for DocumentScanner SDK

This document defines the workflow rules and best practices for managing the multi-repository DocumentScanner SDK project.

## Repository Structure

The project consists of:
- **1 Umbrella Repository**: `DocumentScanner-SDK` (main repo with submodules)
- **7 Platform Repositories**: Each platform SDK in its own repo

## Branching Strategy

### Main Branch
- Each repository has a `main` branch
- `main` is always stable and deployable
- Direct commits to `main` are discouraged

### Feature Branches
- Create feature branches from `main`
- Use descriptive names: `feature/camera-improvements`, `fix/memory-leak`
- Delete branch after merging

### Release Branches
- Not typically needed for SDKs
- Use tags for releases instead

## Versioning

Follow [Semantic Versioning](https://semver.org/):
- `MAJOR.MINOR.PATCH`
- Example: `1.2.3`

### Version Increments

- **MAJOR** (1.0.0 → 2.0.0): Breaking API changes
- **MINOR** (1.0.0 → 1.1.0): New features, backward compatible
- **PATCH** (1.0.0 → 1.0.1): Bug fixes, backward compatible

### Independent Versioning

Each platform SDK has its own version number. They don't need to match.

Example:
- Android SDK: v2.3.1
- iOS SDK: v2.1.5
- Web SDK: v1.8.2
- Flutter Plugin: v3.0.0

## Release Process

### For Platform SDKs (Android, iOS, Web, etc.)

1. **Make Changes**
   ```bash
   cd android/
   # Make your changes
   ```

2. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: add flash toggle support"
   git push
   ```

3. **Create Tag**
   ```bash
   git tag -a v1.2.0 -m "Release v1.2.0: Add flash toggle"
   git push origin v1.2.0
   ```

4. **Create GitHub Release**
   - Go to repository on GitHub
   - Click "Releases" → "Create a new release"
   - Select the tag (v1.2.0)
   - Write release notes
   - Publish release

5. **Publish to Package Manager**
   - **Android**: JitPack auto-publishes from releases
   - **iOS**: `pod trunk push` (if using CocoaPods)
   - **Web**: `npm publish`
   - **Flutter**: `flutter pub publish`

6. **Update Umbrella Repo**
   ```bash
   cd /path/to/DocumentScanner-SDK
   git submodule update --remote android
   git add android
   git commit -m "chore: update Android SDK to v1.2.0"
   git push
   ```

### For Flutter Plugin

1. Update `pubspec.yaml` version
2. Update `CHANGELOG.md`
3. Commit, tag, and release (same as above)
4. Run `flutter pub publish`

## Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, build config)
- `ci`: CI/CD changes

### Examples

```bash
feat(android): add flash toggle support

Add ability to enable/disable camera flash through ScanOptions.
Includes UI toggle in PhotoFragment.

Closes #42
```

```bash
fix(ios): resolve memory leak in camera preview

Camera stream was not being properly released when dismissing
the scanner view controller.

Fixes #38
```

```bash
docs: update README with iOS 17 compatibility info
```

## Pull Request Workflow

### Creating a PR

1. Create feature branch
2. Make changes and commit
3. Push to GitHub
4. Create Pull Request
5. Fill out PR template (if exists)
6. Request review

### PR Title Format

Use conventional commit format:
```
feat(android): add orientation support
```

### Reviewing PRs

- At least 1 approval required for platform SDKs
- Check for breaking changes
- Verify tests pass
- Check code style
- Test locally if needed

### Merging PRs

- Use "Squash and merge" for cleaner history
- Delete branch after merge

## Tagging Rules

### Tag Format
- Use annotated tags: `git tag -a v1.2.0 -m "Release message"`
- Never use lightweight tags for releases
- Format: `vMAJOR.MINOR.PATCH`

### Creating Releases from Tags

A tag alone is NOT enough. You MUST create a GitHub Release:

1. Tag the commit: `git tag -a v1.2.0 -m "Release v1.2.0"`
2. Push the tag: `git push origin v1.2.0`
3. **Create GitHub Release** with that tag

The GitHub Release is what triggers publishing to package managers.

## Branch Protection Rules

Recommended settings for `main` branch:

- ✅ Require pull request before merging
- ✅ Require approvals (1)
- ✅ Require status checks to pass
- ✅ Require branches to be up to date
- ❌ Do NOT require linear history (makes rebasing difficult)

## Submodule Management

### Updating Submodule in Umbrella Repo

```bash
# Update specific submodule
cd DocumentScanner-SDK/
git submodule update --remote android
git add android
git commit -m "chore: update Android SDK"
git push
```

### Cloning with Submodules

```bash
git clone --recurse-submodules https://github.com/Tareq-Ghassan/DocumentScanner-SDK.git
```

### Working on Submodule

Always commit and push changes in the submodule directory, then update the umbrella repo.

## CI/CD Pipeline

Each platform SDK should have:

1. **Automated Tests**
   - Run on every PR
   - Run on push to main

2. **Linting**
   - Code style checks
   - Static analysis

3. **Build Verification**
   - Ensure project builds successfully
   - Check for compilation errors

4. **Publishing**
   - Automated publishing on GitHub Release creation
   - For Android/iOS/Web/Flutter

### Example GitHub Actions

```yaml
name: Android CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
      - name: Build with Gradle
        run: ./gradlew build
      - name: Run tests
        run: ./gradlew test
```

## Breaking Changes

### When Making Breaking Changes

1. Bump MAJOR version
2. Document in CHANGELOG
3. Add migration guide
4. Consider deprecation period first

### Deprecation Process

1. Mark as deprecated in code
2. Add deprecation notice in docs
3. Log warning when used
4. Keep for at least 1 minor version
5. Remove in next major version

## Issue Management

### Issue Labels

- `bug`: Something isn't working
- `feature`: New feature request
- `documentation`: Documentation improvements
- `enhancement`: Improvement to existing feature
- `platform:android`: Android-specific
- `platform:ios`: iOS-specific
- `platform:web`: Web-specific
- `platform:flutter`: Flutter plugin
- `priority:high`: High priority
- `priority:low`: Low priority
- `good first issue`: Good for newcomers

### Issue Templates

Create templates for:
- Bug reports
- Feature requests
- Questions

## Documentation

### README Files

Each platform SDK must have:
- Clear description
- Installation instructions
- Quick start guide
- API reference
- Examples
- License

### Keeping Docs in Sync

When updating APIs:
1. Update code
2. Update inline documentation
3. Update README
4. Update Flutter plugin if applicable
5. Update umbrella repo README

## Security

### Reporting Security Issues

- Do NOT open public issues for security vulnerabilities
- Email security concerns to: security@example.com
- Allow time for fix before disclosure

### Dependency Updates

- Regularly update dependencies
- Check for security advisories
- Use automated tools (Dependabot)

## Code Review Checklist

- [ ] Code follows project style guide
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or MAJOR version bump)
- [ ] Commit messages follow convention
- [ ] PR description is clear
- [ ] Backward compatibility maintained
- [ ] Performance impact considered

## Don't

❌ Don't force push to main
❌ Don't commit directly to main
❌ Don't create tags without GitHub Releases
❌ Don't merge untested code
❌ Don't break backward compatibility in MINOR/PATCH versions
❌ Don't create matching branches across repos (use tags/releases)
❌ Don't rewrite published history

## Do

✅ Write clear commit messages
✅ Test before pushing
✅ Update documentation
✅ Use feature branches
✅ Create GitHub Releases for tags
✅ Follow semantic versioning
✅ Keep submodules updated
✅ Write tests for new features

---

**Questions?**
- Open a discussion on GitHub
- Check existing issues
- Read the documentation
