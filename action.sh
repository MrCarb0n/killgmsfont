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

# Runs from the Magisk/KernelSU app Action button. Single source of the
# module's work: service.sh sources this at boot, so there is one copy of
# the logic and it is never out of step.

MODDIR=${0%/*}

# Disable GMS' font service
# shortcut: pm enable/disable reject --user all, so profiles are enumerated
# instead. AOSP passes USER_NULL to runSetEnabledSetting, so
# handleIncomingUser throws on -1. Verified on Android 15.
STATE_GMSF() {
    GMSF="com.google.android.gms/com.google.android.gms.fonts"

    UPS=$(ls -d /data/user/* 2>/dev/null)  # Dynamically get user profiles

    for UP in $UPS; do
        pm "$1" --user "${UP##*/}" "$GMSF.update.UpdateSchedulerService"
        pm "$1" --user "${UP##*/}" "$GMSF.provider.FontsProvider"
    done
}

# Delete GMS' generated fonts
DEL_GMSF() {
    local GMSFD=com.google.android.gms/files/fonts

    # /data/data has been a symlink to /data/user/<id> since 4.4, so one glob
    # covers every profile without walking all of /data.
    for d in /data/user/*/$GMSFD; do
        rm -rf "$d"
    done
}

STATE_GMSF "$1"
DEL_GMSF