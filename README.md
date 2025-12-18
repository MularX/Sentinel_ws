# Sentinel_ws 🤖
Workspace ROS 2 dla robota mobilnego **Sentinel**. Projekt obejmuje pełną integrację sprzętową z Raspberry Pi oraz zaawansowane funkcje nawigacji i mapowania (SLAM).

---

## ⚙️ Konfiguracja Środowiska

### Tworzenie Workspace
Wykonaj poniższe komendy, aby zainicjalizować przestrzeń roboczą:

```bash
mkdir -p ros2_ws/src
cd ros2_ws
colcon build --symlink-install
source install/setup.bash
ROS 2 Humble
Projekt bazuje na dystrybucji ROS 2 Humble. Pakiety systemowe znajdują się w /opt/ros/humble.

Aby zautomatyzować sourcowanie środowiska, dodaj poniższe linie do pliku ~.bashrc:

Bash

# Otwórz plik konfiguracyjny
nano ~/.bashrc

# Dodaj na samym końcu:
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
Wymagane Zależności
Zainstaluj niezbędne narzędzia oraz pakiety do nawigacji:

Bash

sudo apt update
sudo apt install -y python3-colcon-common-extensions python3-rosdep git
sudo apt install -y ros-humble-navigation2 ros-humble-nav2-bringup ros-humble-slam-toolbox
🍓 Raspberry Pi – Silniki i Czujniki
Repozytorium sterowników: Motor_control

Połączenie
Bash

ssh -Y user@ip_robota
Uruchamianie modułów sprzętowych
Poniższe komendy należy wykonywać bezpośrednio na Raspberry Pi:

Silniki (Hardware Interface):

Bash

ros2 run motor_control ros_control
Lidar (RPLidar) - Tryb domyślny:

Bash

ros2 run rplidar_ros rplidar_composition --ros-args -p serial_port:=/dev/ttyUSB0 -p serial_baudrate:=256000
Lidar (Standard):

Bash

ros2 run rplidar_ros rplidar_composition --ros-args -p serial_port:=/dev/ttyUSB0 -p serial_baudrate:=256000 -p scan_mode:=Standard
IMU + EKF (Filtracja):

Bash

ros2 launch motor_control robot_imu_ekf_launch.py
Czujniki ultradźwiękowe:

Bash

ros2 run motor_control ultrasonic_scan
🖥️ Sentinel Workspace (PC)
Główne repozytorium: Sentinel_ws

Budowanie projektu
Bash

cd Sentinel_ws
colcon build --symlink-install
source install/setup.bash
Główne operacje
Uruchomienie robota:

Bash

ros2 launch sentinel launch_robot.launch.py
Wizualizacja (RViz):

Bash

rviz2
Sterowanie ręczne:

Bash

ros2 run teleop_twist_keyboard teleop_twist_keyboard
🗺️ SLAM i Nawigacja
Tworzenie i zapisywanie mapy
Uruchom SLAM:

Bash

ros2 launch slam_toolbox online_async_launch.py
Zapisz mapę po zakończeniu:

Bash

ros2 run nav2_map_server map_saver_cli --free 0.15 --fmt png -f ./maps/map
Lokalizacja na istniejącej mapie
Uruchom serwer mapy i aktywuj go:

Bash

ros2 run nav2_map_server map_server --ros-args -p yaml_filename:=/home/user/map.yaml

# Aktywacja noda (Lifecycle)
ros2 lifecycle set /map_server configure
ros2 lifecycle set /map_server activate
Wskazówka RViz: Ustaw Fixed Frame: /map oraz zmień Durability na Transient Local w ustawieniach topica mapy.

Nawigacja i Autonomia
Standardowa lokalizacja:

Bash

ros2 launch nav2_bringup localization_launch.py map:=./maps/map.yaml use_sim_time:='False'
Nawigacja Sentinel:

Bash

ros2 launch sentinel_control navigation_launch.py
Autonomiczne mapowanie:

Bash

ros2 launch sentinel_control autonomous_mapping_launch.py
