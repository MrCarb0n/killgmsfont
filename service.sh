#!/system/bin/sh

(
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

    # wait till proper boot up
    until [ "$(resetprop sys.boot_completed)" = "1" -a -d "/data" ]; do
        sleep 1
    done

    # disable GMS' font service
    STATE_GMSF() {
        local PM="$(which pm)"
        local GMSF="com.google.android.gms/com.google.android.gms.fonts"

        for s in $(ls /data/user); do
            $PM $@ --user $s "$GMSF.update.UpdateSchedulerService"
            $PM $@ --user $s "$GMSF.provider.FontsProvider"
        done
    } &> /dev/null

    # delete GMS' generated fonts
    DEL_GMSF() {
        local GMSFD=com.google.android.gms/files/fonts

        for d in /data/fonts \
            /data/data/$GMSFD \
            /data/user/*/$GMSFD; do
            [ -d $d ] && rm -rf $d
        done
    }

    # run primary tasks
    STATE_GMSF disable; DEL_GMSF
)
