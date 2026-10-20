# Kill GMS Font

Google Play Services includes an internal Font Provider service that supplies
downloadable fonts to Google apps and others. Kill GMS Font disables that
service at boot so those apps fall back to your system or custom fonts.

Apps that bundle their own fonts are unaffected.

## Variants

Kill GMS Font ships in two forms:

- **Magisk module** — universal, works on any Magisk or KernelSU setup with no
  font mod required.
- **OhMyFont extension** — for use alongside OhMyFont or OMF-template modules.

## Download

- [Magisk module](https://github.com/MrCarb0n/killgmsfont/releases/download/v2.0/killgmsfont_v2.0.zip)
- [OhMyFont extension](https://github.com/MrCarb0n/killgmsfont/releases/latest/download/killgmsfont.zip)

The extension is unpacked into the `OhMyFont` folder in internal storage
(`/sdcard/OhMyFont`) before OMF is installed.

## Requirements

- Magisk v20.4+ or KernelSU
- Android 9.0+
- OhMyFont v2022.07.03+ (extension variant only)

## How it works

At boot, the module disables two GMS components for every user profile:

- `com.google.android.gms.fonts.provider.FontsProvider`
- `com.google.android.gms.fonts.update.UpdateSchedulerService`

It then removes the font cache GMS stores under
`/data/user/*/com.google.android.gms/files/fonts`.

The module runs once and exits. It does not touch `/data/fonts` (Android's
system font directory) and does not run in a blocking boot stage.

## Manual re-run

The module registers an Action button in the Magisk or KernelSU app. Tapping it
re-runs the disable and cache purge without rebooting — useful after a GMS
update.

## Uninstall

Removing the module runs `uninstall.sh`, which re-enables both components and
restores stock state.

## Credits

- [Oh My Font!](https://gitlab.com/nongthaihoang/oh_my_font) for inspiration
- [Magisk](https://github.com/topjohnwu/Magisk) for the module framework
- [KernelSU](https://github.com/tiann/KernelSU) for root support

## License

GPL-3.0-only. See [LICENSE](LICENSE) and [NOTICE](NOTICE) for attribution
requirements. Derivative works must retain the copyright notice, state changes,
and link back to this repository.
