#!/bin/bash

# shellcheck disable=all
logo() {
    echo """
       [0;1;34;94m▄▄[0m                                           
      [0;34m████[0m                                          
      [0;34m████[0m     [0;37m██▄████[0m   [0;37m▄█[0;1;30;90m██▄██[0m  [0;1;30;90m██[0m    [0;1;30;90m██[0m  [0;1;34;94m▄▄█████▄[0m
     [0;37m██[0m  [0;37m██[0m    [0;37m██▀[0m      [0;1;30;90m██▀[0m  [0;1;30;90m▀██[0m  [0;1;30;90m█[0;1;34;94m█[0m    [0;1;34;94m██[0m  [0;1;34;94m██▄▄▄▄[0m [0;34m▀[0m
     [0;37m██████[0m    [0;1;30;90m██[0m       [0;1;30;90m██[0m    [0;1;34;94m██[0m  [0;1;34;94m██[0m    [0;1;34;94m██[0m   [0;34m▀▀▀▀██▄[0m
    [0;1;30;90m▄██[0m  [0;1;30;90m██▄[0m   [0;1;30;90m██[0m       [0;1;34;94m▀██▄▄███[0m  [0;1;34;94m█[0;34m█▄▄▄███[0m  [0;34m█▄▄▄▄▄█[0;37m█[0m
    [0;1;30;90m▀▀[0m    [0;1;30;90m▀[0;1;34;94m▀[0m   [0;1;34;94m▀▀[0m        [0;1;34;94m▄▀[0;34m▀▀[0m [0;34m██[0m   [0;34m▀▀▀▀[0m [0;34m▀▀[0m   [0;37m▀▀▀▀▀▀[0m 
                         [0;34m▀████▀▀[0m                    
    """
}
# shellcheck enable=all

IMAGE="rafaeldtinoco/argus:v0.0"

LOG="debug"
MODE="normal"

LOGDIR="/var/log/argus"
STDOUT="$LOGDIR/argus.log"
STDERR="$LOGDIR/argus.err"
EVENTS="$LOGDIR/argus.out"

EXTENSIONS=("argus")
PLUGINS=("argus:procfs" "argus:simple" "argus:netflows" "argus:detections")
PRINTERS=("argus:simple:varlog")
EVENTS_LIST=(
    "argus:netflows:netflow"
    "argus:detections:capabilities_modification"
    "argus:detections:code_modification_through_procfs"
    "argus:detections:core_pattern_access"
    "argus:detections:cpu_fingerprint"
    "argus:detections:credentials_files_access"
    "argus:detections:filesystem_fingerprint"
    "argus:detections:java_debug_wire_proto_load"
    "argus:detections:java_libinstrument_load"
    "argus:detections:machine_fingerprint"
    "argus:detections:os_fingerprint"
    "argus:detections:os_network_fingerprint"
    "argus:detections:os_status_fingerprint"
    "argus:detections:package_repo_config_modification"
    "argus:detections:pam_config_modification"
    "argus:detections:sched_debug_access"
    "argus:detections:shell_config_modification"
    "argus:detections:ssl_certificate_access"
    "argus:detections:sudoers_modification"
    "argus:detections:sysrq_access"
    "argus:detections:unprivileged_bpf_config_access"
)

clean() {
    sudo rm -f $STDOUT $STDERR $EVENTS
}

kernelver() {
    major=$(uname -r | cut -d'-' -f1 | cut -d '.' -f1)
    minor=$(uname -r | cut -d'-' -f1 | cut -d '.' -f2)
    supported=1
    if [[ $major -eq 5 || $major -eq 6 ]]; then
        if [[ $major -eq 5 ]]; then
            if [[ $minor -lt 15 ]]; then
                supported=0
            fi
        fi
    else
        supported=0
    fi
    if [[ $supported -eq 0 ]]; then
        echo "kernel version $(uname -r) not supported"
        exit 1
    fi
}

requirements() {
    kernelver
    sudo mkdir -p $LOGDIR
    clean
}

runcontainer() {
    docker pull $IMAGE
    docker \
        run --rm --name=argus --privileged \
        --pid=host --cgroupns=host --network=host \
        -v /sys:/sys:ro \
        -v /sys/fs/bpf:/sys/fs/bpf:rw \
        -v $LOGDIR:$LOGDIR:rw \
        -e VARLOG_PRINTER_FILE=$EVENTS \
        -d $IMAGE \
        --stdout $STDOUT --stderr $STDERR \
        --log $LOG --mode $MODE \
        $(for ext in "${EXTENSIONS[@]}"; do echo "--extension $ext"; done) \
        $(for plugin in "${PLUGINS[@]}"; do echo "--plugin $plugin"; done) \
        $(for printer in "${PRINTERS[@]}"; do echo "--printer $printer"; done) \
        $(for event in "${EVENTS_LIST[@]}"; do echo "--event $event"; done)
    if [[ $? -ne 0 ]]; then
        echo "Failed to run Argus!"
        exit 1
    else
        echo
        echo "Argus is running."
        echo "Check /var/log/argus/argus.* files"
        echo "To stop, run: docker stop argus"
        echo
    fi
}

run() {
    sudo \
        -E VARLOG_PRINTER_FILE=$EVENTS \
        ./build/loader -d --profiler \
        --stdout $STDOUT --stderr $STDERR \
        --log $LOG --mode $MODE \
        $(for ext in "${EXTENSIONS[@]}"; do echo "--extension $ext"; done) \
        $(for plugin in "${PLUGINS[@]}"; do echo "--plugin $plugin"; done) \
        $(for printer in "${PRINTERS[@]}"; do echo "--printer $printer"; done) \
        $(for event in "${EVENTS_LIST[@]}"; do echo "--event $event"; done)
    if [[ $? -ne 0 ]]; then
        echo "Failed to run Argus!"
        exit 1
    else
        echo
        echo "Argus is running."
        echo "Check /var/log/argus/argus.* files"
        echo "To stop, run: pkill loader"
        echo
    fi
}

command -v docker >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Docker is not installed."
    exit 1
fi

command -v sudo >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "sudo is not installed."
    exit 1
fi

sudo ls /var/log >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "sudo is not configured properly."
    exit 1
fi

requirements
logo
runcontainer
#run
