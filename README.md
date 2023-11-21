
<!---
 ╭─────────────────────────────────────────╮
 │    Kill GMS Font Module. | @MrCarb0n    │
 ├─────────────────────────────────────────┤
 │   Give proper credit before doing any   │
 │      distribution or modification.      │
 │        All files licensed under         │
 │     GNU General Public License v3.0     │
 ├─────────────────────────────────────────┤
 │ https://github.com/MrCarb0n/killgmsfont │
 ╰─────────────────────────────────────────╯
-->

# Kill GMS Font :skull:

[Google Mobile Services][1] a.k.a GMS has an internal [Font API Service][2] that provides
fonts for [Google Apps][3] and others too. Here, [KillGMSFont][4] revokes GMS's font
service during boot time to ensure [Google Apps][3] rely on system-provided or custom
installed fonts.

> *Many app interfaces rely on in-built shipped custom fonts; they won't be affected
> by KillGMSFont. Instead, ask the app developer to use [GMS's Font Provider][2] service or
> system font.*

### Download

> *[KillGMSFont][4] comes in two variants: the first is a universal Magisk module,
> fitted without any font mod/tweak, and the second is an [OMF][10] extension. Download your
> desired variant below.*

- [Magisk Module][5]
> *Just download and flash through the Magisk app as a regular installation.*
- [OMF Extension][6]
> *Extract the zip to the `OhMyFont` folder in internal storage before installing OMF or OFM template
> based modules.*

### Requirements
- [Magisk v20.4+][7]
- [OhMyFont v2022.07.03+][8]
- [OMF Template v2022.07.07+][9]

### Credits to
- [OMF Community][10] for inspiration

### Partner projects
- [Oh My Font!][11]
- [Magisk Flashable Font Module][12]

[1]: https://www.android.com/gms
[2]: https://developer.android.com/guide/topics/ui/look-and-feel/downloadable-fonts
[3]: https://play.google.com/store/apps/dev?id=5700313618786177705
[4]: https://github.com/MrCarb0n/killgmsfont
[5]: https://github.com/MrCarb0n/killgmsfont/releases/download/v1.5/KillGMSFont_v1.5.zip
[6]: /extension/killgmsfont.zip?raw=true
[7]: https://github.com/topjohnwu/Magisk/releases
[8]: https://gitlab.com/nongthaihoang/oh_my_font/-/raw/master/releases/OMF.zip
[9]: https://gitlab.com/nongthaihoang/omftemplate
[10]: https://t.me/ohmyfont
[11]: https://gitlab.com/nongthaihoang/oh_my_font
[12]: https://t.me/MFFMMain
