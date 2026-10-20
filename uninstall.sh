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

# Restore GMS' font service to its stock state.
GMSF="com.google.android.gms/com.google.android.gms.fonts"

# shortcut: pm enable/disable reject --user all, so profiles are enumerated
# instead. AOSP passes USER_NULL to runSetEnabledSetting, so
# handleIncomingUser throws on -1 (A11+); on A9/A10 it is a silent no-op.
# Verified on AOSP source for Android 9 through 17.
GMSF_OK=0
GMSF_FAIL=0

STATE_GMSF() {
    UPS=$(ls -d /data/user/* 2>/dev/null)  # Dynamically get user profiles

    for UP in $UPS; do
        for COMP in update.UpdateSchedulerService provider.FontsProvider; do
            # pm prints the resulting state of the component, so trust that
            # instead of the exit code, which is 0 even when nothing changed.
            # Anchored to the end of the output so that other states
            # ("disabled-user") cannot pass for a plain enable.
            OUT=$(pm enable --user "${UP##*/}" "$GMSF.$COMP" 2>&1)
            case "$OUT" in
                *"new state: enabled") GMSF_OK=$((GMSF_OK + 1)) ;;
                *) GMSF_FAIL=$((GMSF_FAIL + 1)); echo "$OUT" ;;
            esac
        done
    done
}

STATE_GMSF

echo "KillGMSFont: restored $GMSF_OK component(s)"
if [ "$GMSF_FAIL" -gt 0 ]; then
    echo "KillGMSFont: failed to restore $GMSF_FAIL component(s)" >&2
fi
