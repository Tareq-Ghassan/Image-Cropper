# Setting Up GitHub Token for Cursor Cloud Agent

## Current Issue
The `GITHUB_TOKEN` secret you added isn't being injected into the environment. This happens because the secret needs to be properly configured for this repository.

---

## ✅ Solution: Set Token in Cursor Dashboard

### Step 1: Create GitHub Personal Access Token

1. **Go to GitHub:**
   - Visit: https://github.com/settings/tokens/new

2. **Create Classic Token:**
   - **Name:** `Cursor Cloud Agent - DocScanner SDK`
   - **Expiration:** 30-90 days
   - **Select scopes:**
     - ✅ `repo` (Full control of private repositories)
     - ✅ `workflow` (Update GitHub Action workflows)
     - ✅ `delete_repo` (Delete repositories - optional)

3. **Generate token** and **copy it** (starts with `ghp_`)

---

### Step 2: Add Token to Cursor Secrets

1. **Go to Cursor Dashboard:**
   - Visit: https://cursor.com/settings
   - Or: Cursor App → Settings → Cloud Agent → Secrets

2. **Add Secret:**
   - **Name:** `GITHUB_TOKEN` (exact name, all caps)
   - **Value:** Paste your `ghp_...` token
   - **Scope:** Select this repository (`Image-Cropper`)
   - **Access:** User or Team scoped

3. **Save the secret**

---

### Step 3: Alternative - Set Token Directly (Temporary)

If you want to complete setup immediately without waiting for Cursor to inject the secret:

1. **Export token in the current session:**
```bash
export GITHUB_TOKEN="ghp_your_actual_token_here"
```

2. **Then run the setup:**
```bash
cd /workspace
bash quick-setup.sh
```

This will work for this session only.

---

## 🚀 After Setting Token

Once the token is properly set, I can run:

```bash
bash quick-setup.sh
```

This will automatically:
1. ✅ Rename `Image-Cropper` → `DocumentScanner-SDK`
2. ✅ Create 7 platform repositories
3. ✅ Push all platform code
4. ✅ Set up git submodules
5. ✅ Complete the multi-repo structure

---

## 🐛 Troubleshooting

### Token Not Working?

**Check token type:**
- ✅ Should start with `ghp_` (Personal Access Token)
- ❌ NOT `ghs_` (GitHub App token - has limited permissions)

**Verify token has repo permissions:**
```bash
export GITHUB_TOKEN="your_token_here"
gh auth status
gh api user
```

If you see "Resource not accessible", the token needs `repo` scope.

---

## 📞 Need Help?

If the token still doesn't work after following these steps:

1. Share the error message you see
2. Verify the token starts with `ghp_`
3. Confirm you selected `repo` scope when creating it
4. Make sure you saved it in Cursor with name `GITHUB_TOKEN`

---

## 🔐 Security Note

- The token gives access to your repositories
- Store it only in Cursor Secrets (encrypted)
- You can revoke it after setup is complete
- Never commit it to git or share it publicly

---

## ⚡ Quick Option

If you want to avoid secrets setup, just paste the token directly:

```bash
export GITHUB_TOKEN="ghp_paste_your_token_here"
bash /workspace/quick-setup.sh
```

This completes everything in ~30 seconds! 🚀
