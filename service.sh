#!/system/bin/sh
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

# set -x

MODDIR=${0%/*}

# Wait until proper boot up. service.sh is a non-blocking stage on both
# Magisk and KernelSU, so this wait cannot stall the boot.
until [ "$(resetprop sys.boot_completed)" = "1" -a -d "/data" ]; do
    sleep 1
done

# The work itself lives in action.sh so the Action button and the boot path
# can never drift apart.
. "$MODDIR/action.sh" disable >/dev/null 2>&1