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

[Google Mobile Services][1] a.k.a GMS has internal [Font Api Service][2] which is provide
fonts among [Google Apps][3] and others too. Here [KillGMSFont][4] do revoke GMS's font
service while boot time to ensure [Google Apps][3] to rely on system provided or custom
installed font.

> Many app's user interfaces rely on in-built shipped custom font, they won't be effective
> by KillGMSFont. Instead ask the app developer to use [GMS's Font Provider][2] service or
> system font.

### Download

> [KillGMSFont][4] have came in two different variant, 1st one is universal magisk module,
> fitted w/o any font mod/tweak and 2nd one is as [OMF][10]'s extension. Download your
> desired variant down below.

- [Magisk Module][5] (WIP)
- [OMF Extension][6]
> extract zip to `OhMyFont` folder at internal storage before installing OMF or OFM template
> based module.

### Requirements
- [Magisk v20.4+][7]
- [OhMyFont v2022.07.03+][8]
- [OMF Template v2022.07.07+][9]

### Credits to
- [OMF Community][10] for inspiration
- [Zackptg5][11] for [MMT-EXTENDED][12]

### Partner projects
- [Oh My Font!][13]
- [Magisk Flashable Font Module][14]

[1]: https://www.android.com/gms
[2]: https://developer.android.com/guide/topics/ui/look-and-feel/downloadable-fonts
[3]: https://play.google.com/store/apps/dev?id=5700313618786177705
[4]: https://github.com/MrCarb0n/killgmsfont
[5]: https://github.com/MrCarb0n/killgmsfont/releases
[6]: https://raw.githubusercontent.com/MrCarb0n/killgmsfont/master/extension/killgmsfont.zip
[7]: https://github.com/topjohnwu/Magisk/releases
[8]: https://gitlab.com/nongthaihoang/oh_my_font/-/raw/master/releases/OMF.zip
[9]: https://gitlab.com/nongthaihoang/omftemplate
[10]: https://t.me/ohmyfont
[11]: https://github.com/Zackptg5
[12]: https://github.com/Zackptg5/MMT-Extended
[13]: https://gitlab.com/nongthaihoang/oh_my_font
[14]: https://t.me/MFFMMain
