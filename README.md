# Server Performance Stats

Simple Bash script to monitor and analyse **basic server performance metrics** including CPU, RAM, and Disk usage, along with top processes by resource usage.

This project is inspired by the [DevOps Roadmap](https://roadmap.sh/projects/server-stats).

---

## Features

- Total **CPU usage** (percentage)
- Total **RAM usage** (used vs available, percentage)
- Total **Disk usage** (used vs total, percentage)
- **Top 5 processes** by CPU usage
- **Top 5 processes** by RAM usage
- Additional info: OS version, uptime, load average, active users
- Refreshes **every second** in terminal

---

## Requirements

- Linux environment
- Bash shell
- Standard Linux tools: `ps`, `df`, `who`, `uname`, `grep`, `awk`

---

## Usage

1. Make the script executable:

```bash
chmod +x server-stats.sh
```

2. Run the script:

```bash
./server-stats.sh
```

3. Press Ctrl+C to exit.

## Example Output
``` bash
=== Server Performance Stats ===
OS:        Linux 6.6.87.2-microsoft-standard-WSL2
Uptime:    0d 1h 28m
Load:      1m:2.53  5m:0.87  15m:0.36
Users:     1

CPU:       51%
RAM:       1175MB / 7862MB  (14%)
Disk:      4194MB / 1031018MB  (0%)

Top 5 processes by CPU:
    PID COMMAND         %CPU
    589 node             2.1
    179 mysqld           1.1
    441 node             0.6
  24735 server-stats.sh  0.5
    717 node             0.2

Top 5 processes by RAM:
    PID COMMAND         %MEM
    179 mysqld           5.9
    589 node             2.2
    441 node             1.4
    717 node             1.0
    754 node             0.7

```