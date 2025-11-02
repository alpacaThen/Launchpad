# Quick Fix for macOS Security Warning

If macOS says LaunchpadPlus is "malware" or won't open, follow these steps:

## ✅ Quick Solution

1. **Download** LaunchpadPlus from [GitHub Releases](https://github.com/kristof12345/Launchpad/releases)
2. **Move** LaunchpadPlus.app to your `/Applications` folder
3. **Open Terminal** (Applications > Utilities > Terminal)
4. **Paste this commands** and press Enter:
   ```bash
   codesign --force --deep -s - /Applications/LaunchpadPlus.app
   xattr -cr /Applications/LaunchpadPlus.app
   ```
5. **Launch** LaunchpadPlus from Applications

That's it! LaunchpadPlus will now open normally.

## 🛡️ Is This Safe?

**Yes!** LaunchpadPlus is open-source software. You can:
- View all source code on [GitHub](https://github.com/kristof12345/Launchpad)
- Build it yourself from source
- Review community feedback and security reports

The "malware" warning appears because the app isn't code-signed by Apple (which requires a $99/year developer account). Many open-source Mac apps face this issue.

As an open-source project, we prioritize transparency over certificates. You can always verify the app by reviewing the source code.

---

**Need Help?** [Open an issue](https://github.com/kristof12345/Launchpad/issues) on GitHub
