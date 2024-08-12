#!/bin/sh
/usr/local/bin/stunnel /etc/stunnel/stunnel.conf && /usr/bin/cadvisor -logtostderr $@
