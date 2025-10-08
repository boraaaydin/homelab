#!/bin/bash
# Initialize Ceph configuration to bypass disk space check

mkdir -p /etc/ceph
cat > /etc/ceph/ceph.conf <<EOF
[global]
mon_data_avail_crit = 1
mon_data_avail_warn = 10
EOF
