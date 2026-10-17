# SPDX-License-Identifier: GPL-3.0-only
# Copyright (c) 2022-present MrCarb0n <https://github.com/MrCarb0n/killgmsfont>
#
# ╭────────────────────────────────────────────╮
# │     Kill GMS Font Module. | @MrCarb0n      │
# ├────────────────────────────────────────────┤
# │   Give proper credit before distribution   │
# │     or modification. All files licensed    │
# │   under GNU General Public License v3.0    │
# ├────────────────────────────────────────────┤
# │  https://github.com/MrCarb0n/killgmsfont   │
# ╰────────────────────────────────────────────╯

# Print version
ui_print '  KillGMSFont v2023.12.31'

# Install service script: svc_killgmsfont.sh
# KernelSU runs module scripts with cwd = the module dir, and Magisk's
# documented convention is MODDIR=${0%/*}. Both give the right dir.
SRCDIR=${0%/*}

[ ! -d $OMFDIR/service.d ] && mkdir -p $OMFDIR/service.d
cp "$SRCDIR/service.sh" $OMFDIR/service.d/svc_killgmsfont.sh

# Assign module ver
ver killgmsf