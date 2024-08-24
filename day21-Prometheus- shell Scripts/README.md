# Day 21 Task

## Project Overview:

The goal of this capstone project is to combine shell scripting with system monitoring and log management practices. You will create a set of automated tools using shell scripts to manage logs, monitor system performance using Prometheus and Node Exporter, and generate insights using PromQL queries. The project will require a systematic approach, covering scripting fundamentals, log management, and monitoring setup.

## Project Deliverables:

### 1. Shell Scripts for Basic Operations:

### Task:
Write shell scripts to perform basic system operations, such as checking disk usage, memory usage, and CPU load.

### Commands:

### Step 1: Make the Script Executable

First, ensure the script is executable by changing its permissions:

```
chmod +x metrics.sh
``` 

**• metrics.sh**

```bash
#!/bin/bash

LOGFILE="system_metrics.log"

log_message() {
    echo "$1" | tee -a "$LOGFILE"
}

check_disk_usage() {
    log_message "Disk Usage:"
    df -h | tee -a "$LOGFILE"
}

check_memory_usage() {
    log_message "Memory Usage:"
    free -h | tee -a "$LOGFILE"
}

check_cpu_load() {
    log_message "CPU Load:"
    top -bn1 | grep "Cpu(s)" | tee -a "$LOGFILE"
}

check_disk_usage
check_memory_usage
check_cpu_load

# Error handling
if [ $? -ne 0 ]; then
    log_message "Error occurred while collecting system metrics."
    exit 1
fi

log_message "System metrics collection completed successfully."
```

### Step 2: Run the Script

```
./metrics.sh
```

![Alt text](/images/1.png)
![Alt text](/images/1.2.png)

### 2. Log Management Script

### Task: 
Create a script to automate log management tasks.

### Script:
• `log_management.sh`: Automates log rotation and archiving.

```bash
#!/bin/bash

LOGFILE="log_report.txt"

check_log() {
    echo "logs are shown below :-"
    cat /var/log/syslog | tail -n 4
    echo
}

if [ -n "$LOGFILE" ]; then
    {
        check_log
    } > "$LOGFILE"

    echo "Report saved to $LOGFILE"
fi
```

#### Make the Script Executable

```
chmod +x log_management.sh
```

#### Run the Script

```
./log_management.sh
```

![Alt text](/images/2.png)

### 3. Advanced Shell Scripting - Loops, Conditions, Functions, and Error Handling

### Scripts:
`metrics_advance.sh:` Combines disk usage, memory usage, and CPU load checks with advanced scripting techniques.


`metrics_advance.sh`


```bash
#!/bin/bash

LOGFILE="metrics_advance.log"
TMPFILE="/tmp/system_metrics_temp.log"

# Ensure the log file exists and is writable
if [ ! -w "$(dirname "$LOGFILE")" ]; then
    echo "Log directory is not writable: $(dirname "$LOGFILE")" >&2
    exit 1
fi

log_message() {
    local message="$1"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp - $message" | tee -a "$LOGFILE"
}

check_disk_usage() {
    log_message "Checking disk usage..."
    df -h > "$TMPFILE" 2>> "$LOGFILE"
    if [ $? -eq 0 ]; then
        log_message "Disk Usage:"
        cat "$TMPFILE" | tee -a "$LOGFILE"
    else
        log_message "Error checking disk usage."
    fi
}

check_memory_usage() {
    log_message "Checking memory usage..."
    free -h > "$TMPFILE" 2>> "$LOGFILE"
    if [ $? -eq 0 ]; then
        log_message "Memory Usage:"
        cat "$TMPFILE" | tee -a "$LOGFILE"
    else
        log_message "Error checking memory usage."
    fi
}

check_cpu_load() {
    log_message "Checking CPU load..."
    top -bn1 | grep "Cpu(s)" > "$TMPFILE" 2>> "$LOGFILE"
    if [ $? -eq 0 ]; then
        log_message "CPU Load:"
        cat "$TMPFILE" | tee -a "$LOGFILE"
    else
        log_message "Error checking CPU load."
    fi
}

{
    log_message "Starting system metrics collection."
    check_disk_usage
    check_memory_usage
    check_cpu_load
    log_message "System metrics collection completed successfully."
} || {
    log_message "An error occurred during the system metrics collection."
    exit 1
}

# Clean up temporary file
rm -f "$TMPFILE"
```

#### Make the Script Executable
```
chmod +x metrics_advance.sh
```

### run script
```
./metrics_advance.sh
```

![Alt text](/images/3.png)
![Alt text](/images/3.1.png)

### 4. Log Checking and Troubleshooting

### Task
Develop a script to analyze system and application logs.

### Script
`log_troubleshooting.sh`: Analyzes logs for common issues and provides troubleshooting steps.

```
log_troubleshooting.sh
```

```bash
#!/bin/bash

LOGFILES=("/var/log/syslog" "/var/log/auth.log")
REPORT_FILE="log_troubleshooting_report.log"

# Function to check for common issues
check_logs() {
    for logfile in "${LOGFILES[@]}"; do
        if [ -f "$logfile" ]; then
            echo "Checking $logfile" | tee -a "$REPORT_FILE"
            grep -i "out of memory\|failed\|error" "$logfile" | tee -a "$REPORT_FILE"
        else
            echo "$logfile does not exist" | tee -a "$REPORT_FILE"
        fi
    done
}

# Function to provide troubleshooting steps
troubleshoot() {
    echo "Troubleshooting steps:" | tee -a "$REPORT_FILE"
    echo "1. Check system memory and processes using 'top' or 'free'." | tee -a "$REPORT_FILE"
    echo "2. Verify service status using 'systemctl status <service>'." | tee -a "$REPORT_FILE"
    echo "3. Inspect configurations or restart services as needed." | tee -a "$REPORT_FILE"
}

check_logs
troubleshoot

# Error handling
if [ $? -ne 0 ]; then
    echo "Log checking or troubleshooting failed" | tee -a "$REPORT_FILE"
    exit 1
fi
```

#### Make the Script Executable
```
chmod +x log_troubleshooting.sh
```

#### Run the Script
```
./log_troubleshooting.sh
```

![Alt text](/images/4.png)

### 5. Installation and Setup of Prometheus and Node Exporter

#### Task: 
Install and configure Prometheus and Node Exporter.

```
wget https://github.com/prometheus/prometheus/releases/download/v2.53.1/prometheus-2.53.1.linux-amd64.tar.gz
```
![Alt text](/images/5.png)

**unzip prometheus**
```
tar -xvf prometheus-2.53.1.linux-amd64.tar.gz
cd prometheus-2.53.1.linux-amd64/
```

Configure Prometheus: Update the `prometheus.yml` configuration file to include Node Exporter as a scrape target.


```yaml
scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
```

![Alt text](/images/5.1.png)

**start prometheus**
```
./prometheus
```

![Alt text](/images/5.2.png)
![Alt text](/images/5.3.png)

#### Installing Node Exporter

• download node_exporter

```
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
```

• unzip node_exporter

```
tar -xvf node_exporter-1.8.2.linux-amd64.tar.gz
cd node_exporter-1.8.2.linux-amd64/
```
![Alt text](/images/5.4.png)

• start node_exporter
```
./node_exporter
```
![Alt text](/images/5.5.png)
![Alt text](/images/5.6.png)

Updating config file and adding new job in scrape_config

```yaml
scrape_configs:
  - job_name: "node"
    static_configs:
      - targets: ["<ip_addr>:9100"]
```

Prometheus scraping metrics from Node Exporter

![Alt text](/images/5.7.png)

### 6. Prometheus Query Language (PromQL) Basic Queries

#### Task
Create a series of PromQL queries to monitor system performance, such as CPU usage, memory usage, and disk I/O.

### Commands
• monitor CPU usage
```
rate(node_cpu_seconds_total[5m])
```
![Alt text](/images/6.png)

• monitor memory usage

```
100 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100)
```

![Alt text](/images/6.1.png)

• monitor disk I/O

