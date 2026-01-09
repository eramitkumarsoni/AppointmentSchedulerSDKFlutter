# Appointment Scheduler SPM - Quick Setup for iOS Developers

## 🚀 One-Line Setup (Recommended)

If your team lead provided you with a `team_credentials.sh` file:

```bash
chmod +x spm_auth_setup.sh && ./spm_auth_setup.sh
```

That's it! The script will handle everything automatically.

---

## 📋 What You Need

1. This SPM package (you probably already have it)
2. Team credentials file OR your personal Cadmium Git token
3. 2 minutes of your time ⏱️

---

## 🔧 Setup Methods

### Method 1: Using Team Credentials (Easiest - Recommended)

**If your team lead gave you a `team_credentials.sh` file:**

1. **Place the file** in this directory (same folder as this README)

2. **Run the setup script:**
   ```bash
   ./spm_auth_setup.sh
   ```

3. **Select option 1** when prompted

4. **Done!** ✅ You can now add the package in Xcode

---

### Method 2: Using Personal Credentials

**If you want to use your own Cadmium Git token:**

1. **Get your access token:**
   - Go to https://git.gocadmium.dev
   - Navigate to: Settings → Access Tokens
   - Create a token with "read_repository" permission
   - Copy the token

2. **Run the setup script:**
   ```bash
   ./spm_auth_setup.sh
   ```

3. **Select option 2** and enter your credentials

4. **Done!** ✅

---

## 📱 Adding Package to Your iOS Project

Once setup is complete:

### In Xcode:

1. Open your iOS project
2. **File** → **Add Package Dependencies...**
3. Paste this URL:
   ```
   https://git.gocadmium.dev/mobile-app-group/appointmentschedulersdkflutter
   ```
4. Select version (e.g., "Up to Next Major" from `1.0.0`)
5. Click **Add Package**
6. Select target and click **Add Package** again

### In Package.swift:

```swift
dependencies: [
    .package(
        url: "https://git.gocadmium.dev/mobile-app-group/appointmentschedulersdkflutter.git",
        from: "1.4.0"
    )
]
```

---

## 💻 Using in Your Code

```swift
import AppointmentSchedulerSDK

// Initialize and use the scheduler
let scheduler = AppointmentScheduler()
scheduler.configure(apiKey: "your-api-key")

// Present appointment view
let appointmentVC = scheduler.presentAppointmentView()
present(appointmentVC, animated: true)
```

---

## 🔄 What the Setup Script Does

The `spm_auth_setup.sh` script automatically:

1. ✅ Configures your `~/.netrc` file with Git credentials
2. ✅ Saves credentials locally (in `.spm_credentials` - gitignored)
3. ✅ Sets correct file permissions for security
4. ✅ Tests the connection to verify it works
5. ✅ Ensures credentials won't be committed to Git

**You only need to run it once!** (Unless credentials change)

---

## ❓ Troubleshooting

### "Permission denied" when running script

**Fix:**
```bash
chmod +x spm_auth_setup.sh
./spm_auth_setup.sh
```

### "Authentication failed" in Xcode

**Fix:**
```bash
# Run the setup script again
./spm_auth_setup.sh

# Then in Xcode:
# File → Packages → Reset Package Caches
```

### "Could not resolve package dependencies"

**Fix:**
1. Check your internet connection
2. Verify setup script completed successfully
3. Try clearing Xcode's cache:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/
   rm -rf ~/Library/Caches/org.swift.swiftpm/
   ```
4. Restart Xcode

### Package not found

**Fix:**
- Ensure you ran `./spm_auth_setup.sh` successfully
- Check that `~/.netrc` file exists: `ls -la ~/.netrc`
- Verify credentials are correct

---

## 🔒 Security

### What's Safe:

- ✅ `.spm_credentials` file (gitignored - won't be committed)
- ✅ `~/.netrc` file (600 permissions - only you can read)
- ✅ Running `spm_auth_setup.sh` (it's safe, check the code!)

### What to NEVER Do:

- ❌ Don't commit `team_credentials.sh` to public repos
- ❌ Don't share your personal tokens publicly
- ❌ Don't commit `.spm_credentials` to Git
- ❌ Don't give tokens write/admin permissions

---

## 🆘 Need Help?

1. **Check if setup completed successfully:**
   ```bash
   git ls-remote https://git.gocadmium.dev/mobile-app-group/appointmentschedulersdkflutter.git
   ```
   
   If this works, authentication is configured correctly.

2. **Verify .netrc file:**
   ```bash
   cat ~/.netrc
   ```
   
   Should show an entry for `git.gocadmium.dev`

3. **Re-run setup:**
   ```bash
   ./spm_auth_setup.sh
   ```

4. **Contact your team lead** for team credentials or repository access

---

## 📞 Support

**For package issues:**
- Check this README
- Contact package maintainer
- Verify Git repository access

**For access issues:**
- Contact your team lead
- Verify your Cadmium Git account has repository access

---

## 🔄 For Team Leads: Distributing to Your Team

### Creating Team Credentials File:

1. **Create a service account** on Cadmium Git:
   - Username: `appointment-scheduler-bot` (or similar)
   - Create access token with **read-only** permissions

2. **Create the credentials file:**
   ```bash
   cp team_credentials.sh.template team_credentials.sh
   ```

3. **Edit with actual credentials:**
   ```bash
   nano team_credentials.sh
   ```
   
   Replace:
   ```bash
   GIT_USERNAME="appointment-scheduler-bot"
   GIT_TOKEN="actual_token_here"
   ```

4. **Distribute securely to team:**
   - Encrypted email
   - Secure file share (1Password, LastPass shared folder)
   - Team chat (if private/encrypted)
   - **NOT in public Git repository!**

5. **Instruct team members:**
   - Place `team_credentials.sh` in SPM package directory
   - Run `./spm_auth_setup.sh`
   - Select option 1

---

## 📚 Additional Documentation

- [Complete Integration Guide](../IOS_INTEGRATION_GUIDE.md)
- [Technical Flow Documentation](../SPM_PULL_FLOW.md)
- [Package Documentation Index](../README_SPM_DOCS.md)

---

## ⚡ Quick Reference

| Action | Command |
|--------|---------|
| **First-time setup** | `./spm_auth_setup.sh` |
| **Re-configure** | `./spm_auth_setup.sh` (select 'y' to reconfigure) |
| **Test connection** | `git ls-remote https://git.gocadmium.dev/mobile-app-group/appointmentschedulersdkflutter.git` |
| **View saved credentials** | `cat .spm_credentials` |
| **Remove credentials** | `rm .spm_credentials` then edit `~/.netrc` |

---

**Repository:** `git.gocadmium.dev/mobile-app-group/appointmentschedulersdkflutter`  
**Last Updated:** January 2026  
**Minimum iOS Version:** 13.0+
