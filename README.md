1. Tworzenie workspace ROS 2

Utwórz workspace oraz katalog src:

mkdir -p ros2_ws/src
cd ros2_ws


Do katalogu src należy pobrać pakiety, które zamierza się wykorzystać.

Budowanie workspace:

colcon build --symlink-install


Sourcowanie workspace:

source install/setup.bash

2. Sourcowanie ROS 2 Humble

Pakiety instalowane przez apt znajdują się w:

/opt/ros/humble/share


Sourcowanie ROS 2 Humble:

source /opt/ros/humble/setup.bash

Automatyczne sourcowanie przy starcie terminala

Edytuj plik .bashrc:

nano ~/.bashrc


Dodaj na końcu pliku:

source /opt/ros/humble/setup.bash

3. Instalacja zależności
sudo apt install -y python3-colcon-common-extensions python3-rosdep git

4. Navigation2 i SLAM Toolbox
Navigation2 (Steve Macenski)
sudo apt install ros-humble-navigation2 ros-humble-nav2-bringup

SLAM Toolbox
sudo apt install ros-humble-slam-toolbox

5. Raspberry Pi – napęd i czujniki

Repozytorium sterujące silnikami i czujnikami:

https://github.com/MularX/Motor_control

Połączenie SSH
ssh -Y użytkownik@ip


Przykład:

ssh -Y maciej@192.168.57.50

6. Uruchamianie komponentów na Raspberry Pi
Silniki
ros2 run motor_control ros_control

Lidar (RPLidar)

Tryb standardowy:

ros2 run rplidar_ros rplidar_composition --ros-args \
-p serial_port:=/dev/ttyUSB0 \
-p serial_baudrate:=256000 \
-p scan_mode:=Standard


Tryb domyślny:

ros2 run rplidar_ros rplidar_composition --ros-args \
-p serial_port:=/dev/ttyUSB0 \
-p serial_baudrate:=256000

IMU + EKF
ros2 launch motor_control robot_imu_ekf_launch.py

Czujniki ultradźwiękowe
ros2 run motor_control ultrasonic_scan

7. Workspace Sentinel (komputer centralny)

Repozytorium:

https://github.com/MularX/Sentinel_ws/tree/main

Budowanie workspace:

cd Sentinel_ws
colcon build --symlink-install
source install/setup.bash


Uruchomienie modelu robota:

ros2 launch sentinel launch_robot.launch.py

8. RViz – wizualizacja
rviz2


Możliwe elementy wizualizacji:

LaserScan

RobotModel

TF

Map

9. Mapowanie (SLAM)
ros2 launch slam_toolbox online_async_launch.py

10. Sterowanie ręczne
ros2 run teleop_twist_keyboard teleop_twist_keyboard

11. Zapisywanie mapy
ros2 run nav2_map_server map_saver_cli \
--free 0.15 \
--fmt png \
-f ./maps/map

12. Lokalizacja na zapisanej mapie

Uruchomienie serwera mapy:

ros2 run nav2_map_server map_server --ros-args \
-p yaml_filename:=/home/user/map.yaml


Zmiana stanu lifecycle:

ros2 lifecycle set /map_server configure
ros2 lifecycle set /map_server activate


W RViz:

Fixed Frame: /map

Topic map → Durability: Transient Local

13. Lokalizacja (Nav2)
ros2 launch nav2_bringup localization_launch.py \
map:=./maps/map.yaml \
use_sim_time:='False'

14. Nawigacja autonomiczna
ros2 launch nav2_bringup navigation_launch.py use_sim_time:='False'


Launch z pakietu Sentinel Control:

ros2 launch sentinel_control navigation_launch.py

15. Autonomiczne mapowanie
ros2 launch sentinel_control autonomous_mapping_launch.py
