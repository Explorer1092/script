#!/bin/bash
# NOTE: should run as root

  sudo  ./sipp -sn uac \
    -i 192.168.78.239 \
    -p 5058 \
    -inf uac_reg_then_invite.csv \
    -sf uac_reg_then_invite.xml \
    -r 1 \
    -m 1 \
    192.168.78.211:5060


