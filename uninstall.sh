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

# wait till pm is executable
until [ "$(resetprop sys.boot_completed)" = "1" ]; do
    sleep 1
done

# enable GMS' font service
STATE_GMSF() {
    local PM="$(which pm)"
    local GMSF="com.google.android.gms/com.google.android.gms.fonts"

    for u in $(ls /data/user); do
        $PM $@ --user $u "$GMSF.update.UpdateSchedulerService"
        $PM $@ --user $u "$GMSF.provider.FontsProvider"
    done
} &> /dev/null

STATE_GMSF enable

# Don't modify anything after this
if [ -f $INFO ]; then
    while read LINE; do
        if [ "$(echo -n $LINE | tail -c 1)" == "~" ]; then
            continue
        elif [ -f "$LINE~" ]; then
            mv -f $LINE~ $LINE
        else
            rm -f $LINE
            while true; do
                LINE=$(dirname $LINE)
                [ "$(ls -A $LINE 2> /dev/null)" ] && break 1 || rm -rf $LINE
            done
        fi
    done < $INFO
    rm -f $INFO
fi
