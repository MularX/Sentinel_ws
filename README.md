Sentinel_ws

Workspace ROS 2 dla robota Sentinel.

Tworzenie workspace
mkdir -p ros2_ws/src
cd ros2_ws
colcon build --symlink-install
source install/setup.bash

ROS 2 Humble

Pakiety z apt są w /opt/ros/humble.

source /opt/ros/humble/setup.bash


Automatyczne sourcowanie:

nano ~/.bashrc


Dodaj na końcu:

source /opt/ros/humble/setup.bash

Zależności
sudo apt install -y python3-colcon-common-extensions python3-rosdep git

Navigation2 + SLAM
sudo apt install ros-humble-navigation2 ros-humble-nav2-bringup
sudo apt install ros-humble-slam-toolbox

Raspberry Pi – silniki i czujniki

Repo:
https://github.com/MularX/Motor_control

SSH:

ssh -Y user@ip

Uruchamianie na Raspberry Pi

Silniki:

ros2 run motor_control ros_control


Lidar:

ros2 run rplidar_ros rplidar_composition --ros-args -p serial_port:=/dev/ttyUSB0 -p serial_baudrate:=256000


Lidar (Standard):

ros2 run rplidar_ros rplidar_composition --ros-args -p serial_port:=/dev/ttyUSB0 -p serial_baudrate:=256000 -p scan_mode:=Standard


IMU + EKF:

ros2 launch motor_control robot_imu_ekf_launch.py


Ultradźwięki:

ros2 run motor_control ultrasonic_scan

Sentinel workspace (PC)

Repo:
https://github.com/MularX/Sentinel_ws/tree/main

cd Sentinel_ws
colcon build --symlink-install
source install/setup.bash
ros2 launch sentinel launch_robot.launch.py

RViz
rviz2

SLAM
ros2 launch slam_toolbox online_async_launch.py

Sterowanie ręczne
ros2 run teleop_twist_keyboard teleop_twist_keyboard

Zapis mapy
ros2 run nav2_map_server map_saver_cli --free 0.15 --fmt png -f ./maps/map

Lokalizacja na mapie
ros2 run nav2_map_server map_server --ros-args -p yaml_filename:=/home/user/map.yaml

ros2 lifecycle set /map_server configure
ros2 lifecycle set /map_server activate


RViz:

Fixed Frame: /map

Topic map → Durability Transient Local

Lokalizacja (Nav2)
ros2 launch nav2_bringup localization_launch.py map:=./maps/map.yaml use_sim_time:='False'

Nawigacja
ros2 launch nav2_bringup navigation_launch.py use_sim_time:='False'

ros2 launch sentinel_control navigation_launch.py

Autonomiczne mapowanie
ros2 launch sentinel_control autonomous_mapping_launch.py
