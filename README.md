# Sentinel_ws - Workspace ROS 2 dla robota Sentinel

Workspace ROS 2 dedykowany dla robota mobilnego **Sentinel** (ROS 2 Humble).

## Tworzenie workspace

```bash
mkdir -p ros2_ws/src
cd ros2_ws
colcon build --symlink-install
source install/setup.bash
Pakiety systemowe ROS 2 Humble znajdują się w /opt/ros/humble.
Automatyczne sourcowanie ROS 2
Bashsource /opt/ros/humble/setup.bash
Aby sourcować automatycznie przy każdym uruchomieniu terminala:
Bashnano ~/.bashrc
Dodaj na końcu pliku:
Bashsource /opt/ros/humble/setup.bash
Instalacja zależności
Bashsudo apt install -y python3-colcon-common-extensions python3-rosdep git
Navigation2 i SLAM
Bashsudo apt install ros-humble-navigation2 ros-humble-nav2-bringup
sudo apt install ros-humble-slam-toolbox
Raspberry Pi – sterowanie silnikami i czujnikami
Repozytorium z pakietem sterowania silnikami i czujnikami:
https://github.com/MularX/Motor_control
Połączenie SSH
Bashssh -Y user@ip
Uruchamianie na Raspberry Pi
Silniki:
Bashros2 run motor_control ros_control
Lidar (RPLIDAR):
Bashros2 run rplidar_ros rplidar_composition --ros-args -p serial_port:=/dev/ttyUSB0 -p serial_baudrate:=256000
Lidar – tryb Standard:
Bashros2 run rplidar_ros rplidar_composition --ros-args -p serial_port:=/dev/ttyUSB0 -p serial_baudrate:=256000 -p scan_mode:=Standard
IMU + Extended Kalman Filter:
Bashros2 launch motor_control robot_imu_ekf_launch.py
Czujniki ultradźwiękowe:
Bashros2 run motor_control ultrasonic_scan
Workspace na PC (Sentinel_ws)
Repozytorium:
https://github.com/MularX/Sentinel_ws
Bashcd Sentinel_ws
colcon build --symlink-install
source install/setup.bash
Uruchomienie całego robota:
Bashros2 launch sentinel launch_robot.launch.py
RViz:
Bashrviz2
SLAM
Bashros2 launch slam_toolbox online_async_launch.py
Sterowanie ręczne (teleop)
Bashros2 run teleop_twist_keyboard teleop_twist_keyboard
Zapis mapy
Bashros2 run nav2_map_server map_saver_cli --free 0.15 --fmt png -f ./maps/map
Lokalizacja na istniejącej mapie
Map server:
Bashros2 run nav2_map_server map_server --ros-args -p yaml_filename:=/home/user/maps/map.yaml
Bashros2 lifecycle set /map_server configure
ros2 lifecycle set /map_server activate
W RViz:

Fixed Frame: map
Topic /map → Durability: Transient Local

Pełne uruchomienie lokalizacji (Nav2):
Bashros2 launch nav2_bringup localization_launch.py map:=./maps/map.yaml use_sim_time:='False'
Nawigacja
Bashros2 launch nav2_bringup navigation_launch.py use_sim_time:='False'
Lub dedykowany launch file:
Bashros2 launch sentinel_control navigation_launch.py
Autonomiczne mapowanie
Bashros2 launch sentinel_control autonomous_mapping_launch.py
