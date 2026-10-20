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

# Boot entry point. The work itself lives in action.sh so this path and the
# Action button path cannot drift apart.

MODDIR=${0%/*}

# Wait until proper boot up. service.sh is a non-blocking stage on both
# Magisk and KernelSU, so this wait cannot stall the boot.
until [ "$(resetprop sys.boot_completed)" = "1" -a -d "/data" ]; do
    sleep 1
done

# Only the banner goes to stdout; failures are reported on stderr so they
# survive instead of being swallowed.
. "$MODDIR/action.sh" >/dev/null
