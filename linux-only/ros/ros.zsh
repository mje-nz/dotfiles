# ROS
# If ROS is installed, this loads its setup script and does some tweaks

if [[ -d /opt/ros/indigo/ ]]; then
  source /opt/ros/indigo/setup.zsh
  
  # My aliases
  alias iv='rosrun image_view image_view'
  alias iva='rosrun image_view image_view _autosize:=true'

  rosmaster() {
    local host=$1
    export ROS_MASTER_URI="http://$1:11311"
  }
fi
