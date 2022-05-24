# Docker container for V-Rising Server
use fragsoc/steamcmd-wine-xvfb to setup VRising Server
This is a private docker image 
## Useage 
### Build docker image on local 
*Tips：please query the usage for ubuntu, docker and docker-compose by yourself* 
*Suppose you use Ubuntu20.04 and setup git, docker and docker-compose* 
1. Clone the repo git clone https://github.com/sdlhappylin/V-Rising-Server-Docker.git 
2. CD to the directory V-Rising-Server-Docker `cd V-Rising-Server-Docker` 
3. Build the image `docker build . -t V-Rising-Server-Docker:latest` 
4. make dir for your serverdata `mkdir /path/for/server-data` 
5. Use docker-compose or run docker container 
   1. Use docker-compose
      1. create file docker-compose.yml `nano docker-compose.yml`
```
 version: "2.1"
 services: 
   vrising: 
     container_name: V-Rising-Server-Docker
     image: V-Rising-Server-Docker:latest
     volumes: 
       - /path/for/server-data:/vrising/.wine/drive_c/VRisingServer/server-data
     ports: 
       - "9876:9876/udp"
       - "9877:9877/udp"
     restart: unless-stopped    
```
      2. run `docker-compose up -d`
   2. Run docker container `sudo docker run --name V-Rising-Server-Docker -p 9876:9876 -v /path/for/server-data:/vrising/.wine/drive_c/VRisingServer/server-data V-Rising-Server-Docker:latest`
6. Copy `ServerHostSettings.json` and `ServerGameSettings.json` to /path/for/server-data 
7. Refer to the [V Rising Dedicated Server Instructions](https://github.com/StunlockStudios/vrising-dedicated-server-instructions)  to modify the ServerHostSettings.json ServerGameSettings.json 
### Fork the respository and use GitHubActions
1. fork the respository
2. New respositry screte named CR_PAT and value is your github token     [set from here](https://github.com/settings/tokens)    * position: Settings->Security->Secret->Actions *
3.run  `docker login ghcr.io` and input your password to login 
4. run `docker pull ghcr.io/yourname/v-rising-server-docker`
5. Others reference abrove useage
