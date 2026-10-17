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
#
# Behaviour here is intentionally identical to the payloads previously
# inlined in customize.sh and extension/dev_killgmsfont.sh. Queued fixes
# (scope the /data walk, stop wiping /data/fonts, cover every user profile)
# are separate changes so this extraction stays reviewable.

while true; do
    (
        # Wait until proper boot up
        until [ "$(resetprop sys.boot_completed)" = "1" -a -d "/data" ]; do
            sleep 1
        done

        # Disable GMS' font service
        # shortcut: pm enable/disable reject --user all, so profiles are
        # enumerated instead. AOSP passes USER_NULL to runSetEnabledSetting,
        # so handleIncomingUser throws on -1. Verified on Android 15.
        STATE_GMSF() {
            GMSF="com.google.android.gms/com.google.android.gms.fonts"

            for UP in $(ls -d /data/user/* 2>/dev/null); do
                pm "$1" --user "${UP##*/}" "$GMSF.update.UpdateSchedulerService"
                pm "$1" --user "${UP##*/}" "$GMSF.provider.FontsProvider"
            done
        }

        # Delete GMS' generated fonts
        DEL_GMSF() {
            local GMSFD=com.google.android.gms/files/fonts

            # /data/data has been a symlink to /data/user/<id> since 4.4, so
            # one glob covers every profile without walking all of /data.
            for d in /data/user/*/$GMSFD; do
                rm -rf "$d"
            done
        }

        # Run primary tasks
        STATE_GMSF disable >/dev/null 2>&1
        DEL_GMSF
    )

    # Sleep for 3 hours before running again
    sleep 10800 # 3 hours in seconds
done