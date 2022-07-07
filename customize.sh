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

set -x

ui_print ' _____ _ _ _ _____ _____ _____ _____         _   '
ui_print '|  |  |_| | |   __|     |   __|   __|___ ___| |_ '
ui_print '|    -| | | |  |  | | | |__   |   __| . |   |  _|'
ui_print '|__|__|_|_|_|_____|_|_|_|_____|__|  |___|_|_|_|  '
ui_print ''

ui_print '- Installing'
ui_print ''

# check GMS's components state
STATE_GMSF() {
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
}

# Find GMS' generated fonts
FIND_GMSF() {
    ui_print '- Finding GMS Fonts'
    local GMSFD=com.google.android.gms/files/fonts

    for d in /data/fonts \
        /data/data/$GMSFD \
        /data/user/*/$GMSFD; do
        [ -d $d ] &&
            ui_print "  Found: $d"
    done
    ui_print '  Done'
    ui_print ''
}

# cleanup $MODPATH
CLEANUP() {
    ui_print '- Cleaning up'
    find $MODPATH/* -maxdepth 0 \
        ! -name module.prop \
        ! -name service.sh \
        ! -name uninstall.sh -exec basename {} \; |
        while IFS= read -r CLEAN; do
            rm -f $MODPATH/$CLEAN
            ui_print "  Removed: $CLEAN"
        done
    ui_print '  Done'
    ui_print ''
}

# settings permissions
SET_PERM() {
    ui_print '- Setting permissions'
    find $MODPATH/* -maxdepth 0 \
        -exec basename {} \; |
        while IFS= read -r PERM; do
            set_perm $MODPATH/$PERM 0 0 0777 u:object_r:system_file:s0
            ui_print "  Granted: $PERM"
        done
    ui_print '  Done'
    ui_print ''
}

# run functions
STATE_GMSF && FIND_GMSF && CLEANUP && SET_PERM
