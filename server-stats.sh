#!/bin/bash


set -euo pipefail

# CPU usage (calculated from /proc/stat deltas)
get_cpu_usage() {
    read _ user nice system idle iowait irq softirq steal _ < /proc/stat
    total=$((user + nice + system + idle + iowait + irq + softirq + steal))

    if [[ -n "${prev_total:-}" ]]; then
        diff_total=$((total - prev_total))
        diff_idle=$((idle - prev_idle))
        usage=$((100 * (diff_total - diff_idle) / diff_total))
        echo "$usage"
    else
        echo "0"
    fi

    prev_total=$total
    prev_idle=$idle
}

# RAM stats (MemTotal / MemAvailable)
get_mem_stats() {
    mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    mem_avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    mem_used=$((mem_total - mem_avail))
    mem_usage=$((100 * mem_used / mem_total))

    echo "$mem_total $mem_used $mem_usage"
}

# Disk stats for root filesystem
get_disk_stats() {
    read total used < <(df -k / --output=size,used | tail -1)
    usage=$((100 * used / total))
    echo "$total $used $usage"
}

# Format uptime
get_uptime() {
    sec=$(cut -d. -f1 /proc/uptime)
    days=$((sec / 86400))
    hours=$((sec % 86400 / 3600))
    mins=$((sec % 3600 / 60))
    echo "${days}d ${hours}h ${mins}m"
}

clear
echo "Collecting initial CPU reference…"
get_cpu_usage > /dev/null   # Prime the function
sleep 1                     # Needed to get proper delta

while true; do
    clear

    # CPU
    cpu=$(get_cpu_usage)

    # RAM
    read mem_total mem_used mem_usage < <(get_mem_stats)

    # Disk
    read disk_total disk_used disk_usage < <(get_disk_stats)

    # Load averages
    read load1 load5 load15 _ < /proc/loadavg

    # Active users
    user_count=$(who | wc -l)

    # OS version
    os_version="$(uname -s) $(uname -r)"

    # Uptime
    uptime=$(get_uptime)

    echo "=== Server Performance Stats ==="
    echo "OS:        $os_version"
    echo "Uptime:    $uptime"
    echo "Load:      1m:$load1  5m:$load5  15m:$load15"
    echo "Users:     $user_count"
    echo ""
    echo "CPU:       ${cpu}%"
    echo "RAM:       $((mem_used/1024))MB / $((mem_total/1024))MB  (${mem_usage}%)"
    echo "Disk:      $((disk_used/1024))MB / $((disk_total/1024))MB  (${disk_usage}%)"
    echo ""
    echo "Top 5 processes by CPU:"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    echo ""
    echo "Top 5 processes by RAM:"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6

    sleep 1
done
