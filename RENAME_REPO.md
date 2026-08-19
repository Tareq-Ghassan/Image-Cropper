# Repository Rename Guide

## Current Name
`DocumentScanner-SDK` ❌

## Should Be
`DocumentScanner-SDK` ✅

---

## How to Rename the Repository

### Option 1: Using GitHub Web Interface (Recommended)

1. **Go to repository settings:**
   - Navigate to https://github.com/Tareq-Ghassan/DocumentScanner-SDK
   - Click **Settings** tab
   - Scroll to **Repository name** section

2. **Rename:**
   - Change from: `DocumentScanner-SDK`
   - Change to: `DocumentScanner-SDK`
   - Click **Rename**

3. **GitHub will automatically:**
   - Set up redirects from old name to new name
   - Update all references
   - Preserve issues, PRs, stars, etc.

### Option 2: Using GitHub CLI

```bash
gh repo rename DocumentScanner-SDK --repo Tareq-Ghassan/DocumentScanner-SDK
```

---

## Update Local Repository

After renaming on GitHub, update your local clone:

```bash
cd /path/to/local/repo

# Update remote URL
git remote set-url origin https://github.com/Tareq-Ghassan/DocumentScanner-SDK.git

# Verify
git remote -v

# Pull latest
git pull
```

---

## Update All References

After renaming, run the automated script:

```bash
chmod +x rename-repo-references.sh
./rename-repo-references.sh
```

This will update:
- All markdown files
- All YAML files
- package.json files
- pubspec.yaml
- build.gradle files

---

## Manual Updates Needed

### 1. Update GitHub Actions Secrets

No action needed - secrets are tied to the repository, not the name.

### 2. Update External References

If you have external links or documentation pointing to the old name, update them.

---

## Benefits of Renaming

1. **Better Branding** - "DocumentScanner-SDK" is more professional
2. **Clear Purpose** - Immediately tells what the project does
3. **SEO** - Better searchability
4. **Consistency** - Matches the new SDK structure
5. **No Conflicts** - Avoids confusion with other image cropping tools

---

## GitHub's Automatic Redirects

Don't worry about breaking links! GitHub automatically:
- Redirects old URLs to new ones
- Preserves all stars, watchers, forks
- Keeps all issues and PRs
- Maintains git history
- Updates clones automatically

---

## Timeline

1. **Rename repository** (2 minutes)
2. **Update local clones** (1 minute)
3. **Run update script** (1 minute)
4. **Commit and push** (1 minute)

**Total: ~5 minutes** ⏱️

---

## Verification Checklist

After renaming, verify:

- [ ] Repository accessible at new URL
- [ ] Old URL redirects to new URL
- [ ] Local git remote updated
- [ ] All references updated
- [ ] PR still accessible
- [ ] Issues still accessible
- [ ] README badges work

---

## Need Help?

GitHub Documentation:
- [Renaming a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/renaming-a-repository)

---

**Rename it now before creating the sub-repositories!** 🚀
