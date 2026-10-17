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

# Runs from the Magisk/KernelSU app Action button and at boot via service.sh.
# Single source of the module's work so the two paths never drift apart.

MODDIR=${0%/*}

# ── banner ────────────────────────────────────────────────────────
ui_print() { echo "$1"; }

ui_print ' _____ _ _ _ _____ _____ _____ _____         _   '
ui_print '|  |  |_| | |   __|     |   __|   __|___ ___| |_ '
ui_print '|    -| | | |  |  | | | |__   |   __| . |   |  _|'
ui_print '|__|__|_|_|_|_____|_|_|_|_____|__|  |___|_|_|_|  '
ui_print ''
ui_print '- Running KillGMSFont'
ui_print ''

# ── disable GMS' font service ─────────────────────────────────────
# shortcut: pm enable/disable reject --user all, so profiles are enumerated
# instead. AOSP passes USER_NULL to runSetEnabledSetting, so
# handleIncomingUser throws on -1. Verified on Android 15.
ui_print '- Disabling GMS Font Service'

STATE_GMSF() {
    GMSF="com.google.android.gms/com.google.android.gms.fonts"

    UPS=$(ls -d /data/user/* 2>/dev/null)  # Dynamically get user profiles

    for UP in $UPS; do
        pm disable --user "${UP##*/}" "$GMSF.update.UpdateSchedulerService" >/dev/null 2>&1
        pm disable --user "${UP##*/}" "$GMSF.provider.FontsProvider" >/dev/null 2>&1
    done
}

STATE_GMSF
ui_print '  Provider: Disabled'
ui_print '  Service: Disabled'
ui_print ''

# ── delete GMS' generated fonts ───────────────────────────────────
ui_print '- Purging GMS Fonts'

DEL_GMSF() {
    local GMSFD=com.google.android.gms/files/fonts

    # /data/data has been a symlink to /data/user/<id> since 4.4, so one glob
    # covers every profile without walking all of /data.
    for d in /data/user/*/$GMSFD; do
        rm -rf "$d"
    done
}

DEL_GMSF
ui_print '  Purged: /data/user/*/com.google.android.gms/files/fonts'
ui_print ''

# ── done ──────────────────────────────────────────────────────────
ui_print '- Done'
ui_print '  KillGMSFont: GMS font service disabled and fonts purged'