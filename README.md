
---

## Instalacja i Konfiguracja

### 1. Tworzenie Workspace
Otwórz terminal i przygotuj strukturę katalogów:

```bash
mkdir -p ros2_ws/src
cd ros2_ws
colcon build --symlink-install
source install/setup.bash
```

### 2. Automatyzacja Środowiska
Aby środowisko ROS 2 i workspace ładowały się automatycznie przy każdym starcie terminala, dodaj poniższe linie do pliku `~/.bashrc`:

```bash
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

### 3. Instalacja Zależności
Zainstaluj niezbędne narzędzia oraz pakiety nawigacyjne:

```bash
sudo apt update && sudo apt install -y \
  python3-colcon-common-extensions \
  python3-rosdep \
  git \
  ros-humble-navigation2 \
  ros-humble-nav2-bringup \
  ros-humble-slam-toolbox
```

---

## 🍓 Raspberry Pi (Hardware)
*Komendy uruchamiane bezpośrednio na robocie (SSH: `ssh -Y user@ip`).*
**Repozytorium sterowników:** [Motor_control](https://github.com/MularX/Motor_control)

### Uruchamianie modułów sprzętowych:

* **Silniki (Main Control):**
    ```bash
    ros2 run motor_control ros_control
    ```
* **Lidar (RPLidar):**
    ```bash
    ros2 run rplidar_ros rplidar_composition --ros-args -p serial_port:=/dev/ttyUSB0 -p serial_baudrate:=256000 -p scan_mode:=Standard
    ```
* **IMU + EKF (Filtracja danych):**
    ```bash
    ros2 launch motor_control robot_imu_ekf_launch.py
    ```
* **Czujniki Ultradźwiękowe:**
    ```bash
    ros2 run motor_control ultrasonic_scan
    ```

---

## 💻 Sentinel Workspace (PC)
Główne repozytorium: [Sentinel_ws](https://github.com/MularX/Sentinel_ws/tree/main)

### Budowanie i start systemu:
```bash
cd Sentinel_ws
colcon build --symlink-install
source install/setup.bash
ros2 launch sentinel launch_robot.launch.py
```

### Sterowanie i Wizualizacja:
* **Wizualizacja:** `rviz2`
* **Sterowanie klawiaturą:**
    ```bash
    ros2 run teleop_twist_keyboard teleop_twist_keyboard
    ```

---

## 🗺️ SLAM i Nawigacja

### Tworzenie i zapisywanie mapy
1.  **Uruchomienie SLAM:**
    ```bash
    ros2 launch slam_toolbox online_async_launch.py
    ```
2.  **Zapisanie gotowej mapy:**
    ```bash
    ros2 run nav2_map_server map_saver_cli --free 0.15 --fmt png -f ./maps/map
    ```

### Lokalizacja i Autonomia
Aby wczytać mapę i uruchomić nawigację:

1.  **Start serwerów:**
    ```bash
    ros2 run nav2_map_server map_server --ros-args -p yaml_filename:=/home/user/map.yaml
    ros2 lifecycle set /map_server configure
    ros2 lifecycle set /map_server activate
    ```
2.  **Uruchomienie Navigation2:**
    ```bash
    ros2 launch nav2_bringup navigation_launch.py use_sim_time:='False'
    ```
3.  **Autonomiczne Mapowanie:**
    ```bash
    ros2 launch sentinel_control autonomous_mapping_launch.py
    ```

> **💡 Konfiguracja RViz:** Ustaw `Fixed Frame` na `/map`. W ustawieniach tematu `/map` zmień parametr `Durability` na **Transient Local**, aby dane mapy zostały poprawnie wyświetlone.

---
*Projekt Sentinel – 2025*
