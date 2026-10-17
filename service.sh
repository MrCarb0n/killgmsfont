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
        STATE_GMSF() {
            PM="$(command -v pm)"
            GMSF="com.google.android.gms/com.google.android.gms.fonts"

            UPS=$(ls -d /data/user/*)  # Dynamically get user profiles

            for UP in $UPS; do
                "$PM" "$@" --user "${UP##*/}" "$GMSF.update.UpdateSchedulerService"
                "$PM" "$@" --user "${UP##*/}" "$GMSF.provider.FontsProvider"
            done
        }

        # Delete GMS' generated fonts
        DEL_GMSF() {
            local GMSFD=com.google.android.gms/files/fonts

            [ -d /data/fonts ] && rm -r /data/fonts

            find /data \
                -type d \
                -path "*$GMSFD*" \
                -exec test -d {} \; -exec rm -r {} \;
        }

        # Run primary tasks
        STATE_GMSF disable >/dev/null 2>&1
        DEL_GMSF
    )

    # Sleep for 3 hours before running again
    sleep 10800 # 3 hours in seconds
done