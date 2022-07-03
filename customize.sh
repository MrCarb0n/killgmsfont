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

# set -xv
DEBUG=true

ui_print ' _____ _ _ _ _____ _____ _____ _____         _   '
ui_print '|  |  |_| | |   __|     |   __|   __|___ ___| |_ '
ui_print '|    -| | | |  |  | | | |__   |   __| . |   |  _|'
ui_print '|__|__|_|_|_|_____|_|_|_|_____|__|  |___|_|_|_|  '
ui_print ''

ui_print '- Installing'
ui_print ''

# disable GMS' font service
STATE_GMSF() {
    ui_print '- Disabling components'
    local PM="$(which pm)"
    local GMSF="com.google.android.gms/com.google.android.gms.fonts"

    for u in $(ls /data/user); do
        $PM $@ --user $u "$GMSF.update.UpdateSchedulerService" |
            awk -F':' '{gsub(/ /,"");print $2}' |
            while IFS= read -r STATE; do
                ui_print "  Service: $STATE"
            done

        $PM $@ --user $u "$GMSF.provider.FontsProvider" |
            awk -F':' '{gsub(/ /,"");print $2}' |
            while IFS= read -r STATE; do
                ui_print "  Provider: $STATE"
            done
    done
    ui_print ''
}

# delete GMS' generated fonts
DEL_GMSF() {
    ui_print '- Deleting GMS Font'
    local GMSFD=com.google.android.gms/files/fonts

    for d in /data/data /data/user/*; do
        [ -d $d/$GMSFD ] &&
            ui_print "  Found: $d/$GMSFD" &&
            rm -rf $d/$GMSFD
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
        ! -name uninstall.sh -delete
    ui_print '  Done'
    ui_print ''
}

# settings permissions
SET_PERM() {
    ui_print '- Setting permissions'
    set_perm_recursive $MODPATH 0 0 0755 0777 u:object_r:system_file:s0
    ui_print '  Done'
    ui_print ''
}

# run functions
STATE_GMSF disable && DEL_GMSF && CLEANUP && SET_PERM
