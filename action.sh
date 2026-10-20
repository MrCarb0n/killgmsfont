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

# Set GMSF_MODE=enable before sourcing this file to restore the font
# service instead of disabling it. Runs from the Magisk/KernelSU app Action
# button, at boot via service.sh, and from uninstall.sh, so the disable and
# restore paths share one copy of the work and cannot drift apart.

GMSF_MODE=${GMSF_MODE:-disable}

GMSF="com.google.android.gms/com.google.android.gms.fonts"

ui_print() { echo "$1"; }

if [ "$GMSF_MODE" = enable ]; then
    VERB=enable
    STATE=enabled
    RESULT=Enabled
else
    VERB=disable
    STATE=disabled
    RESULT=Disabled
fi

# ── banner ────────────────────────────────────────────────────────
if [ "$GMSF_MODE" != enable ]; then
    ui_print ' _____ _ _ _ _____ _____ _____ _____         _   '
    ui_print '|  |  |_| | |   __|     |   __|   __|___ ___| |_ '
    ui_print '|    -| | | |  |  | | | |__   |   __| . |   |  _|'
    ui_print '|__|__|_|_|_|_____|_|_|_|_____|__|  |___|_|_|_|  '
    ui_print ''
    ui_print '- Running KillGMSFont'
    ui_print ''
    ui_print '- Disabling GMS Font Service'
fi

# ── set the font service state ────────────────────────────────────
# shortcut: pm enable/disable reject --user all on every Android, so the
# profiles are enumerated instead. AOSP passes USER_NULL to
# runSetEnabledSetting, so handleIncomingUser throws on -1 (A11+), while
# A9/A10 no-op silently. Verified on AOSP source for Android 9-17.
[ "$GMSF_MODE" = enable ] && ui_print '- Restoring GMS Font Service'

STATE_GMSF() {
    UPS=$(ls -d /data/user/* 2>/dev/null)  # Dynamically get user profiles

    for COMP in update.UpdateSchedulerService provider.FontsProvider; do
        case $COMP in
            update.UpdateSchedulerService) NAME=Service ;;
            provider.FontsProvider) NAME=Provider ;;
        esac

        OK=1
        for UP in $UPS; do
            # pm prints the state it ended up in and exits 0 even when
            # nothing changed, so trust the state over the exit code.
            OUT=$(pm $VERB --user "${UP##*/}" "$GMSF.$COMP" 2>&1)
            case "$OUT" in
                *"new state: $STATE") ;;
                *) OK=0; ui_print "  $OUT" ;;
            esac
        done

        if [ "$OK" = 1 ]; then
            ui_print "  $NAME: $RESULT"
        else
            ui_print "  $NAME: Failed"
        fi
    done
}

STATE_GMSF
ui_print ''

# ── delete GMS' generated fonts ───────────────────────────────────
if [ "$GMSF_MODE" != enable ]; then
    ui_print '- Purging GMS Fonts'

    DEL_GMSF() {
        local GMSFD=com.google.android.gms/files/fonts
        local FOUND=0

        # /data/data has been a symlink to /data/user/<id> since 4.4, so one
        # glob covers every profile without walking all of /data.
        for d in /data/user/*/$GMSFD; do
            [ -d "$d" ] || continue
            FOUND=1
            rm -rf "$d"
            if [ -d "$d" ]; then
                ui_print "  Failed to purge $d"
            else
                ui_print "  Purged: $d"
            fi
        done

        [ "$FOUND" = 0 ] && ui_print '  Nothing to purge'
    }

    DEL_GMSF
    ui_print ''
    ui_print '- Done'
fi
