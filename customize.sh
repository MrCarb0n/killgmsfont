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

local GMS="com.google.android.gms"
local GMFP="$GMS.fonts.provider.FontsProvider"
local GMFS="$GMS.fonts.update.UpdateSchedulerService"

local DCL="disabledComponents:"
local ECL="enabledComponents:"
local HSP="Hidden[[:space:]]system[[:space:]]packages:"

local DATA="dumpsys package $GMS"

CHECK() { $DATA | sed -n "/$1/,/$2/{/$3/p}" | xargs; }

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

local GMSFD=com.google.android.gms/files/fonts

for d in /data/fonts /data/data/$GMSFD /data/user/*/$GMSFD; do
    [ -d $d ] && ui_print "  Found: $d"
done

ui_print '  Done'
ui_print ''

# Generating supporting files
ui_print '- Generating Supporting Files'

cat << 'EOF' > $MODPATH/service.sh
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
EOF
ui_print "  Generated: service.sh"

ui_print '  Done'
ui_print ''

# Remove unnecessary files and print only the filenames
ui_print '- Cleaning up'

EXCEPTIONS="module.prop service.sh uninstall.sh"

for file in $MODPATH/*; do
    [ -e "$file" ] && [[ ! " $EXCEPTIONS " =~ " $(basename "$file") " ]] && {
        rm -f "$file"
        ui_print "  Removed: $(basename "$file")"
    }
done

ui_print '  Done'
ui_print ''

# Set permissions individually for each file and print only the filenames
ui_print '- Setting permissions'

for PERM in $MODPATH/*; do
    if [ -e "$PERM" ]; then
        set_perm "$PERM" 0 0 0755 u:object_r:system_file:s0
        ui_print "  Granted: $(basename "$PERM")"
    fi
done

ui_print '  Done'
ui_print ''
