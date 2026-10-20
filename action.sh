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

# ── banner ────────────────────────────────────────────────────────
ui_print() { echo "$1"; }

ui_print ' _____ _ _ _ _____ _____ _____ _____         _   '
ui_print '|  |  |_| | |   __|     |   __|   __|___ ___| |_ '
ui_print '|    -| | | |  |  | | | |__   |   __| . |   |  _|'
ui_print '|__|__|_|_|_|_____|_|_|_|_____|__|  |___|_|_|_|  '
ui_print ''
ui_print '- Running KillGMSFont'
ui_print ''

GMSF="com.google.android.gms/com.google.android.gms.fonts"

# ── disable GMS' font service ─────────────────────────────────────
# shortcut: pm enable/disable reject --user all, so profiles are enumerated
# instead. AOSP passes USER_NULL to runSetEnabledSetting, so
# handleIncomingUser throws on -1. Verified on Android 15.
ui_print '- Disabling GMS Font Service'

GMSF_OK=0
GMSF_FAIL=0

STATE_GMSF() {
    UPS=$(ls -d /data/user/* 2>/dev/null)  # Dynamically get user profiles

    for UP in $UPS; do
        for COMP in update.UpdateSchedulerService provider.FontsProvider; do
            # pm prints the resulting state of the component, so trust that
            # instead of the exit code, which is 0 even when nothing changed.
            # Anchored to the end of the output so that other states
            # ("disabled-user") cannot pass for a plain disable.
            OUT=$(pm disable --user "${UP##*/}" "$GMSF.$COMP" 2>&1)
            case "$OUT" in
                *"new state: disabled") GMSF_OK=$((GMSF_OK + 1)) ;;
                *) GMSF_FAIL=$((GMSF_FAIL + 1)); echo "  $OUT" >&2 ;;
            esac
        done
    done
}

STATE_GMSF

if [ "$GMSF_OK" -gt 0 ]; then
    ui_print "  Disabled: $GMSF_OK"
fi
if [ "$GMSF_FAIL" -gt 0 ]; then
    ui_print "  Failed: $GMSF_FAIL"
fi
ui_print ''

# ── delete GMS' generated fonts ───────────────────────────────────
ui_print '- Purging GMS Fonts'

PURGED=0
PURGE_FAIL=0

DEL_GMSF() {
    local GMSFD=com.google.android.gms/files/fonts

    # /data/data has been a symlink to /data/user/<id> since 4.4, so one glob
    # covers every profile without walking all of /data.
    for d in /data/user/*/$GMSFD; do
        [ -d "$d" ] || continue
        rm -rf "$d"
        if [ -d "$d" ]; then
            PURGE_FAIL=$((PURGE_FAIL + 1))
            echo "  Failed to purge $d" >&2
        else
            PURGED=$((PURGED + 1))
        fi
    done
}

DEL_GMSF

if [ "$PURGED" -gt 0 ]; then
    ui_print "  Purged: $PURGED"
fi
if [ "$PURGE_FAIL" -gt 0 ]; then
    ui_print "  Failed: $PURGE_FAIL"
fi
if [ "$PURGED" -eq 0 ] && [ "$PURGE_FAIL" -eq 0 ]; then
    ui_print '  Nothing to purge'
fi
ui_print ''

# ── done ──────────────────────────────────────────────────────────
ui_print '- Done'
if [ "$GMSF_FAIL" -gt 0 ] || [ "$PURGE_FAIL" -gt 0 ]; then
    ui_print '  KillGMSFont: finished with errors, see above'
else
    ui_print '  KillGMSFont: GMS font service disabled and fonts purged'
fi
