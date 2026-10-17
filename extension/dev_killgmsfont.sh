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
# OMF sources extensions via `. $OMFDIR/$i`, so $0 here is OMF's own
# customize.sh, not this file. The extension and service.sh both live in
# $OMFDIR, so resolve the source relative to that.
SRCDIR=$OMFDIR

[ ! -d $OMFDIR/service.d ] && mkdir -p $OMFDIR/service.d
cp "$SRCDIR/service.sh" $OMFDIR/service.d/svc_killgmsfont.sh

# Assign module ver
ver killgmsf