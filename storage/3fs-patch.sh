sed -i "s/mgmtd_server_addresses = \[\]/mgmtd_server_addresses = [\"${MGMTD_SERVER_ADDRESSES//,/\",\"}\"]/" *
