# Sentinel_ws
Należy stworzyć folder workspace (np. ros2_ws) wejść do niego i stworzyć folder src (source). Tam należy pobrać pakiety, które zamierza się wykorzystać. Następnie poleceniem:
 colcon build –symlink-install 
buduje się kod. Komenda:
 source install/setup.bash 
„sourcuje” kod, w ten sposób wskazuje się gdzie szukać kodu. Z reguły sourcuje się w swoim własnym workspace albo w ros2_ws. Jeśli przy instalacji wykorzysta się polecenia apt isntall pakiety będą instalowane w pod adresem /opt/ros/humble/share. W celu sourcowania pakietów w tamtej lokalizacji należałoby użyć polecenia: 
source /opt/ros/humble/setup.bash
W celu uproszczenia całej procedury można dodać to polecenie do pliku bashrc, żeby przestrzeń ta była sourcowana przy każdym uruchomieniu terminala. Najpierw komenda nano ~/.bashrc, następnie na końcu pliku dodać linijkę:
 source /opt/ros/humble/setup.bash
 Żeby zainstalować pakiety Steve’a Macenski’ego, należy przygotować środowisko:
sudo apt install -y python3-colcon-common-extensions python3-rosdep git
Następnie zainstalować poleceniem lub pobrać kod źródłowy z repozytorium:
sudo apt install ros-humble-navigation2 ros-humble-nav2-bringup
Pakiet nawigacji i lokalizacji dopełniany jest przez pakiet do mapowania slam toolbox:
sudo apt install ros-humble-slam-toolbox
Na raspberry pi, mikrokomputerze robota należy pobrać programy do pracy z czujnikami. 
https://github.com/MularX/Motor_control
Z głównego komputera należy połączyć się do raspberry po ssh komenda to ssh nazwa użytkownika@ip, polecam używać wyjątku -Y (ssh -Y maciej@192.168.57.50). Następnie zuploadować tam repozytorium zbudować kod i użyć następujących komend, do uruchomienia silników:
ros2 run motor_control ros_control
do uruchomienia lidaru:
ros2 run rplidar_ros rplidar_composition --ros-args -p serial_port:=/dev/ttyUSB0 -p serial_baudrate:=256000
lub w trybie standard:
ros2 run rplidar_ros rplidar_composition --ros-args -p serial_port:=/dev/ttyUSB0 -p serial_baudrate:=256000 -p scan_mode:=Standard
Launch do uruchomienia imu oraz rozszerzonego filtru Kalmana EKF:
ros2 launch motor_control robot_imu_ekf_launch.py
Oraz do uruchomienia danych z czujników utlradzwiękowych:
ros2 run motor_control ultrasonic_scan
Pozostała część programów będzie uruchamiana na centralnym komputerze sterującym. Gotowy workspace z plikami urdf i xacro robota zostały załączone do instrukcji oraz w repozytorium pod adresem:
https://github.com/MularX/Sentinel_ws/tree/main
Należy wejść do folderu Sentinel_ws oraz użyć komendy colcon build –symlink-install, zsourcować i załadować model robota komendą:
ros2 launch sentinel launch_robot.launch.py

Po wgraniu modelu oraz uruchomieniu lidaru należy uruchomić Rviz, w programie dodać elementy które chcemy wizuwalizować np. lidar scan, robot model, map itp.:
Rviz2
Do mapowania przestrzeni:
ros2 launch slam_toolbox online_async_launch.py
Do wydawania poleceń ruchu można albo podłączyć po usb pad do komputera sterującego lub uruchomić terminal do wysyłania komend prędkościowych:
ros2 run teleop_twist_keyboard teleop_twist_keyboard
Teraz przy ruchu mapa powinna się rozszerzać do zapisania mapy komenda:
ros2 run nav2_map_server map_saver_cli --free 0.15 --fmt png -f ./maps/map
Jeśli na uprzednio zapisanej mapie chcemy uruchomić autonomiczną lokalizację należy wgrać mapę komendami: 
ros2 run nav2_map_server map_server --ros-args -p yaml_filename:=/home/user/map.yaml --ros-args
W następnym terminalu podać dwie komendy, po kolei:
ros2 lifecycle set /map_server configure
ros2 lifecycle set /map_server activate
W rivize powinna się pojawić mapa po ustawieniu fixed frame na /map, oraz ustawieniu w topic map transient local zamiast volatile w zakładce durability. Następnie można uruchomić lokalizację: 
ros2 launch nav2_bringup localization_launch.py map:=./maps/map.yaml use_sim_time:='False'
Argument sim time powinien być ustawiony na False dla rzeczywistego robota oraz True dla symulacji, przekazuje on informację czy system powinien uwzględniać czas unixowy czy czas symulacji. Następnie do nawigacji są dostępne opcje, navigation 2 Steve’a Macenski’ego:
ros2 launch nav2_bringup navigation_launch.py use_sim_time:='False'
Launch z pakietu Sentinel control:
ros2 launch sentinel_control navigation_launch.py
Autonomiczne mapowanie z launcha:
ros2 launch sentinel_control autonomous_mapping_launch.py



