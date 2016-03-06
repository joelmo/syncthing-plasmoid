#! /bin/sh

plasmapkg2 --remove com.github.joelmo.syncthing-plasmoid
plasmapkg2 --install $(dirname $0)/plasmoid
plasmawindowed com.github.joelmo.syncthing-plasmoid
