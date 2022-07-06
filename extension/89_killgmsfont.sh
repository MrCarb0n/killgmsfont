# ╭─────────────────────────────────────────╮
# │   Kill GMS Font OMF Ext. | @MrCarb0n    │
# ├─────────────────────────────────────────┤
# │   Give proper credit before doing any   │
# │      distribution or modification.      │
# │        All files licensed under         │
# │     GNU General Public License v3.0     │
# ├─────────────────────────────────────────┤
# │ https://github.com/MrCarb0n/killgmsfont │
# ╰─────────────────────────────────────────╯

# print version
ui_print '  KillGMSFont v2022.7.6'

IGNR_FR_NW() {
    # disable GMS' font service
    STATE_GMSF() {
        local PM="$(which pm)"
        local GMSF="com.google.android.gms/com.google.android.gms.fonts"

        for u in $(ls /data/user); do
            $PM $@ --user $u "$GMSF.update.UpdateSchedulerService"
            $PM $@ --user $u "$GMSF.provider.FontsProvider"
        done
    } &> /dev/null

    # delete GMS' generated fonts
    DEL_GMSF() {
        local GMSFD=com.google.android.gms/files/fonts

        for d in /data/data /data/user/*; do
            [ -d $d/$GMSFD ] && rm -rf $d/$GMSFD
        done
    }

    # run primary tasks
    STATE_GMSF disable && DEL_GMSF
} # && IGNR_FR_NW

# create service script: svc_killgmsfont.sh
[ ! -d $OMFDIR/service.d ] && mkdir -p $OMFDIR/service.d
{
    echo '(   '
    echo '    # ╭─────────────────────────────────────────╮'
    echo '    # │   Kill GMS Font OMF Ext. | @MrCarb0n    │'
    echo '    # ├─────────────────────────────────────────┤'
    echo '    # │   Give proper credit before doing any   │'
    echo '    # │      distribution or modification.      │'
    echo '    # │        All files licensed under         │'
    echo '    # │     GNU General Public License v3.0     │'
    echo '    # ├─────────────────────────────────────────┤'
    echo '    # │ https://github.com/MrCarb0n/killgmsfont │'
    echo '    # ╰─────────────────────────────────────────╯'
    echo ''
    echo '    # wait till proper boot up'
    echo '    until [ "$(resetprop sys.boot_completed)" = "1" -a -d "/data" ]; do'
    echo '        sleep 1'
    echo '    done'
    echo ''
    echo "    # disable GMS' font service"
    echo '    STATE_GMSF() {'
    echo '        local PM="$(which pm)"'
    echo '        local GMSF="com.google.android.gms/com.google.android.gms.fonts"'
    echo ''
    echo '        for s in $(ls /data/user); do'
    echo '            $PM $@ --user $s "$GMSF.update.UpdateSchedulerService"'
    echo '            $PM $@ --user $s "$GMSF.provider.FontsProvider"'
    echo '        done'
    echo '    } &> /dev/null'
    echo ''
    echo "    # delete GMS' generated fonts"
    echo '    DEL_GMSF() {'
    echo '        local GMSFD=com.google.android.gms/files/fonts'
    echo ''
    echo '        for d in /data/data /data/user/*; do'
    echo '            [ -d $D/$GMSFD ] && rm -rf $d/$GMSFD'
    echo '        done'
    echo '    }'
    echo ''
    echo '    # run primary tasks'
    echo '    STATE_GMSF disable && DEL_GMSF'
    echo ')'
} > $OMFDIR/service.d/svc_killgmsfont.sh

# create uninstall script: uni_killgmsfont.sh
[ ! -d $OMFDIR/uninstall.d ] && mkdir -p $OMFDIR/uninstall.d
{
    echo '('
    echo '    # ╭─────────────────────────────────────────╮'
    echo '    # │   Kill GMS Font OMF Ext. | @MrCarb0n    │'
    echo '    # ├─────────────────────────────────────────┤'
    echo '    # │   Give proper credit before doing any   │'
    echo '    # │      distribution or modification.      │'
    echo '    # │        All files licensed under         │'
    echo '    # │     GNU General Public License v3.0     │'
    echo '    # ├─────────────────────────────────────────┤'
    echo '    # │ https://github.com/MrCarb0n/killgmsfont │'
    echo '    # ╰─────────────────────────────────────────╯'
    echo ''
    echo '    # wait till proper boot up'
    echo '    until [ "$(resetprop sys.boot_completed)" = "1" ]; do'
    echo '        sleep 1'
    echo '    done'
    echo ''
    echo "    # enable GMS' font service"
    echo '    STATE_GMSF() {'
    echo '        local PM="$(which pm)"'
    echo '        local GMSF="com.google.android.gms/com.google.android.gms.fonts"'
    echo ''
    echo '        for u in $(ls /data/user); do'
    echo '            $PM $@ --user $u "$GMSF.update.UpdateSchedulerService"'
    echo '            $PM $@ --user $u "$GMSF.provider.FontsProvider"'
    echo '        done'
    echo '    } &> /dev/null'
    echo ''
    echo '    STATE_GMSF enable'
    echo ')'
} > $OMFDIR/uninstall.d/uni_killgmsfont.sh

# assign module ver
ver killgmsf
