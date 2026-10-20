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
ui_print '  KillGMSFont @VERSION@'

# OMF sources extensions via `. $OMFDIR/$i`, so $0 here is OMF's own
# customize.sh, not this file. The payload therefore lives in $OMFDIR/svc,
# which OMF's src() does not scan (it only looks one level deep).
SRCDIR=$OMFDIR/svc

# Install service script: svc_killgmsfont.sh
# OMF's svc() copies service.d/*.sh into its own module dir and runs them at
# boot, and uninstall.d/*.sh when the module is removed.
[ ! -d $OMFDIR/service.d ] && mkdir -p $OMFDIR/service.d
[ ! -d $OMFDIR/uninstall.d ] && mkdir -p $OMFDIR/uninstall.d

cp "$SRCDIR/service.sh" $OMFDIR/service.d/svc_killgmsfont.sh
cp "$SRCDIR/uninstall.sh" $OMFDIR/uninstall.d/killgmsfont.sh

# The boot worker sources "$MODDIR/action.sh", and $MODDIR is OMF's module
# dir - the same place svc() puts the service script. So the worker has to
# sit next to it, or the extension boots and does nothing. The uninstall hook
# needs it there too, since it restores from the same script.
if [ -n "$MODPATH" ] && [ -d "$MODPATH" ]; then
    cp "$SRCDIR/action.sh" "$MODPATH/action.sh"
fi

# Assign module ver
ver killgmsf
