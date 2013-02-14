#!/bin/bash

function notInstalled {
  brew info $1 | grep -q "Not installed"
  return $?
}

pkgs=( "cairo" )

for pkg in "${pkgs[@]}"; do
  if notInstalled $pkg; then
    brew install $pkg
  fi
done

export PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig:$PKG_CONFIG_PATH

git submodule init
git submodule update