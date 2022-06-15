#!/bin/bash
chown -R vrising:vrising /vrising/.wine/drive_c/VRisingServer
exec gosu vrising "$@"