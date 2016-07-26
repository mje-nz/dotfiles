#!/usr/bin/env zsh

# ROS
# If ROS is installed, this loads its setup script and does some tweaks

ros_found=

if [[ -d /opt/ros/indigo/ ]]; then
  source /opt/ros/indigo/setup.zsh
  ros_found=true
elif [[ -d /opt/ros/kinetic/ ]]; then
  source /opt/ros/kinetic/setup.zsh
  ros_found=true
fi

if [[ $ros_found == "true" ]]; then
  # My aliases
  alias iv='rosrun image_view image_view'
  alias iva='rosrun image_view image_view _autosize:=true'
  
  # Set ROS_MASTER_URI
  rosmaster() {
    local host=$1
    export ROS_MASTER_URI="http://$1:11311"
  }
  
  # Source catkin_ws/(space)/setup.zsh
  cs() {
    local space=${1:=devel}
    echo "Overlaying $1 workspace"
    source "$1/setup.zsh"
  }
fi
