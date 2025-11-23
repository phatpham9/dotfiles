#!/bin/bash

# create symbolic links
create_symlink() {
  ln -sf "$1" "$2"
  
  echo "-> Symlink created for $1"
}
