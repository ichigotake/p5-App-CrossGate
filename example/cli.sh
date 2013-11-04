#!/bin/sh

base_dir=$( cd $(dirname $0); pwd );

plackup-auto-mount "$base_dir/apps"

