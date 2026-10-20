## Release v2.0
- **KillGMSFont Module v2.0**
  - Added an Action button in the Magisk or KernelSU app. Tapping it re-runs
    the disable and cache purge without rebooting, which is useful after a GMS
    update.
  - The module now runs once at boot and exits, instead of every three hours.
  - Added `uninstall.sh`, which restores the GMS font service to its stock
    state when the module is removed.
  - The report now shows what the `pm` calls actually did instead of always
    claiming success.
  - Only the font cache GMS owns under `/data/user` is purged. `/data/fonts`
    is the system font directory and is no longer touched.
- **OMF Extension v2.0**
  - The extension now actually disables the font service. It was missing the
    script its boot worker sources, so it did nothing.
  - The extension restores the font service when OMF is removed.
- **Build**
  - Signed with `zipsignerust` and the package contains only the files
    Magisk needs.
  - `LICENSE` and `NOTICE` are included in the module package.

## Release v1.6
- **KillGMSFont Module v1.6**
  - Fixed typographical error :P

## Release v1.5
- **KillGMSFont Module v1.5**
  - Fixed typos in README.md
  - Improved code formatting in customization.sh
  - Enabled automatic execution every 3 hours
- **OMF Extension v2023.12.31**
  - Synchronized codebase with module

## Release v1.0
- **KillGMSFont Module v1.0**
- **OMF Extension v2022.7.8**

## Release v0.1
- Initial Preparation
  - Universal module
  - OhMyFont Extension
