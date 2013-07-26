# HW configuration file for nypon

# Proximity sensor configuration (NOA3402)
dev=/sys/devices/platform/nmk-i2c.2/i2c-2/2-0037
echo 1300 0e00 > $dev/ps_threshold # Hysteresis thershold values in hex (<hi> <lo>)

display_id=`cat /sys/devices/mcde_display_panel.0/ddb_id`
case "$display_id" in
        "021e8423")
                fw=incell_fw_120hz.img
        ;;
        *)
                fw=incell_fw_default.img
        ;;
esac
echo $display_id
echo $fw

semc_rmi4_fwloader -b /system/etc/firmware/$fw -d /sys/bus/rmi4/devices/sensor00

# Audio jack configuration
dev=/sys/devices/platform/simple_remote.0
echo 0,301,1901 > $dev/accessory_min_vals
echo 300,1900  > $dev/accessory_max_vals
echo 0,51,251,511,851 > $dev/button_min_vals
echo 50,250,510,850,5000  > $dev/button_max_vals


#XPERIENCE CONFIGS
# Configure governor based on system property
governor_name=`getprop ro.cpufreq.governor`
case "$governor_name" in
    "interactive")
        echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 800000 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
        echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
        chown system /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
        chown system /sys/devices/system/cpu/cpufreq/interactive/timer_rate
       ;;
    *)
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
        echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
        echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        chown system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        chown system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        chown system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
      ;;
esac

#XPE_Modules_BACKPORTED TO XPeria GO
insmod /system/lib/modules/axperiau_ondemandax.ko
insmod /system/lib/modules/axperiau_pegasusq.ko
insmod /system/lib/modules/axperiau_sio_iosched.ko
insmod /system/lib/modules/axperiau_smartass2.ko
insmod /system/lib/modules/axperiau_vr_iosched.ko
insmod /system/lib/modules/axperiau_lulzactiveq.ko


# free pagecache, dentries and inodes
sync && echo 3 > /proc/sys/vm/drop_caches

#XPE fast GPU
dev=/system/lib/elg
echo 1 > $dev/libEGL_mali.so
