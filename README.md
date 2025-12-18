# Sentinel_ws

Workspace ROS 2 dla robota **Sentinel**.  
Projekt obejmuje obsługę napędu, czujników, model robota (URDF/XACRO), mapowanie, lokalizację oraz nawigację autonomiczną z wykorzystaniem **Navigation2** i **SLAM Toolbox**.

---

## 1. Tworzenie workspace ROS 2

Utwórz workspace oraz katalog `src`:

```bash
mkdir -p ros2_ws/src
cd ros2_ws
Do katalogu src należy pobrać pakiety, które zamierza się wykorzystać.

Budowanie workspace:

bash
Skopiuj kod
colcon build --symlink-install
Sourcowanie workspace:

bash
Skopiuj kod
source install/setup.bash
2. Sourcowanie ROS 2 Humble
Pakiety instalowane przez apt znajdują się w:

swift
Skopiuj kod
/opt/ros/humble/share
Sourcowanie ROS 2 Humble:

bash
Skopiuj kod
source /opt/ros/humble/setup.bash
Automatyczne sourcowanie przy starcie terminala
Edytuj plik .bashrc:

bash
Skopiuj kod
nano ~/.bashrc
Dodaj na końcu pliku:

bash
Skopiuj kod
source /opt/ros/humble/setup.bash
3. Instalacja zależności
bash
Skopiuj kod
sudo apt install -y python3-colcon-common-extensions python3-rosdep git
4. Navigation2 i SLAM Toolbox
Navigation2 (Steve Macenski)
bash
Skopiuj kod
sudo apt install ros-humble-navigation2 ros-humble-nav2-bringup
SLAM Toolbox
bash
Skopiuj kod
sudo apt install ros-humble-slam-toolbox
5. Raspberry Pi – napęd i czujniki
Repozytorium sterujące silnikami i czujnikami:

arduino
Skopiuj kod
https://github.com/MularX/Motor_control
Połączenie SSH
bash
Skopiuj kod
ssh -Y użytkownik@ip
Przykład:

bash
Skopiuj kod
ssh -Y maciej@192.168.57.50
6. Uruchamianie komponentów na Raspberry Pi
Silniki
bash
Skopiuj kod
ros2 run motor_control ros_control
Lidar (RPLidar)
Tryb standardowy:

bash
Skopiuj kod
ros2 run rplidar_ros rplidar_composition --ros-args \
-p serial_port:=/dev/ttyUSB0 \
-p serial_baudrate:=256000 \
-p scan_mode:=Standard
Tryb domyślny:

bash
Skopiuj kod
ros2 run rplidar_ros rplidar_composition --ros-args \
-p serial_port:=/dev/ttyUSB0 \
-p serial_baudrate:=256000
IMU + EKF
bash
Skopiuj kod
ros2 launch motor_control robot_imu_ekf_launch.py
Czujniki ultradźwiękowe
bash
Skopiuj kod
ros2 run motor_control ultrasonic_scan
7. Workspace Sentinel (komputer centralny)
Repozytorium:

bash
Skopiuj kod
https://github.com/MularX/Sentinel_ws/tree/main
Budowanie workspace:

bash
Skopiuj kod
cd Sentinel_ws
colcon build --symlink-install
source install/setup.bash
Uruchomienie modelu robota:

bash
Skopiuj kod
ros2 launch sentinel launch_robot.launch.py
8. RViz – wizualizacja
bash
Skopiuj kod
rviz2
Możliwe elementy wizualizacji:

LaserScan

RobotModel

TF

Map

9. Mapowanie (SLAM)
bash
Skopiuj kod
ros2 launch slam_toolbox online_async_launch.py
10. Sterowanie ręczne
bash
Skopiuj kod
ros2 run teleop_twist_keyboard teleop_twist_keyboard
11. Zapisywanie mapy
bash
Skopiuj kod
ros2 run nav2_map_server map_saver_cli \
--free 0.15 \
--fmt png \
-f ./maps/map
12. Lokalizacja na zapisanej mapie
Uruchomienie serwera mapy:

bash
Skopiuj kod
ros2 run nav2_map_server map_server --ros-args \
-p yaml_filename:=/home/user/map.yaml
Zmiana stanu lifecycle:

bash
Skopiuj kod
ros2 lifecycle set /map_server configure
ros2 lifecycle set /map_server activate
W RViz:

Fixed Frame: /map

Topic map → Durability: Transient Local

13. Lokalizacja (Nav2)
bash
Skopiuj kod
ros2 launch nav2_bringup localization_launch.py \
map:=./maps/map.yaml \
use_sim_time:='False'
14. Nawigacja autonomiczna
bash
Skopiuj kod
ros2 launch nav2_bringup navigation_launch.py use_sim_time:='False'
Launch z pakietu Sentinel Control:

bash
Skopiuj kod
ros2 launch sentinel_control navigation_launch.py
15. Autonomiczne mapowanie
bash
Skopiuj kod
ros2 launch sentinel_control autonomous_mapping_launch.py
