# SPDX-License-Identifier: GPL-3.0-only
# Copyright (c) 2022-present MrCarb0n <https://github.com/MrCarb0n/killgmsfont>
#
# ╭─────────────────────────────────────────╮
# │    Kill GMS Font Module. | @MrCarb0n    │
# ├─────────────────────────────────────────┤
# │   Give proper credit before doing any   │
# │      distribution or modification.      │
# │        All files licensed under         │
# │     GNU General Public License v3.0     │
# ├─────────────────────────────────────────┤
# │ https://github.com/MrCarb0n/killgmsfont │
# ╰─────────────────────────────────────────╯

# set -x

ui_print ' _____ _ _ _ _____ _____ _____ _____         _   '
ui_print '|  |  |_| | |   __|     |   __|   __|___ ___| |_ '
ui_print '|    -| | | |  |  | | | |__   |   __| . |   |  _|'
ui_print '|__|__|_|_|_|_____|_|_|_|_____|__|  |___|_|_|_|  '
ui_print ''

ui_print '- Installing'
ui_print ''

# Check GMS's components state
ui_print '- Checking Components'

GMS="com.google.android.gms"
GMFP="$GMS.fonts.provider.FontsProvider"
GMFS="$GMS.fonts.update.UpdateSchedulerService"

DCL="disabledComponents:"
ECL="enabledComponents:"
HSP="Hidden[[:space:]]system[[:space:]]packages:"

DATA="dumpsys package $GMS"

# tr collapses the line breaks sed leaves behind; xargs would also strip
# quotes and backslashes, which dumpsys output is free to contain.
CHECK() { $DATA | sed -n "/$1/,/$2/{/$3/p}" | tr -d '[:space:]'; }

for g in $GMFP $GMFS; do
    case $g in
        $(CHECK $DCL $ECL $g))
            case $g in
                $GMFP) ui_print "  Provider: Disabled" ;;
                $GMFS) ui_print "  Service: Disabled" ;;
            esac
            ;;
        $(CHECK $ECL $HSP $g))
            case $g in
                $GMFP) ui_print "  Provider: Enabled" ;;
                $GMFS) ui_print "  Service: Enabled" ;;
            esac
            ;;
    esac
done
ui_print ''

# Find GMS' generated fonts
ui_print '- Finding GMS Fonts'

GMSFD=com.google.android.gms/files/fonts

# Only the paths action.sh actually purges. /data/data is a symlink to
# /data/user/0, and /data/fonts is the system font dir, which we leave alone.
for d in /data/user/*/$GMSFD; do
    [ -d $d ] && ui_print "  Found: $d"
done

ui_print ''

# Set permissions individually for each file and print only the filenames
ui_print '- Setting permissions'

for PERM in $MODPATH/*; do
    if [ -e "$PERM" ]; then
        set_perm "$PERM" 0 0 0755 u:object_r:system_file:s0
        ui_print "  Granted: $(basename "$PERM")"
    fi
done

ui_print ''
