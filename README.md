# Docker container for V-Rising Server
From fragsoc/steamcmd-wine-xvfb to building VRising Server docker image.

This is a private docker image.
## Useage 
### Build docker image on local 
*Tips：please query the usage for ubuntu, docker and docker-compose by yourself* 
*Suppose you use Ubuntu20.04 and setup git, docker and docker-compose* 
#### 1. Clone the repo 
    git clone https://github.com/sdlhappylin/V-Rising-Server-Docker.git 
#### 2. CD to the directory V-Rising-Server-Docker
    cd V-Rising-Server-Docker
#### 3. Build the image
    docker build . -t v-rising-server-docker
#### 4. make dir for your serverdata
    mkdir /path/for/server-data
#### 5. Use docker-compose or run docker container 
##### Use docker-compose：
* create file docker-compose.yml
* 
    nano docker-compose.yml

docker-compose.yml
```
 version: "2.1"
 services: 
   vrising: 
     container_name: v-rising-server-docker
     image: v-rising-server-docker
     volumes: 
       - /path/for/server-data:/vrising/.wine/drive_c/VRisingServer/server-data
     ports: 
       - "9876:9876/udp"
       - "9877:9877/udp"
     restart: unless-stopped
```

* run docker-compose up -d

    docker-compose up -d

##### Use docker containder
    sudo docker run --name V-Rising-Server-Docker -p 9876:9876 -v /path/for/server-data:/vrising/.wine/drive_c/VRisingServer/server-data v-rising-server-docker

#### 6. Copy ServerHostSettings.json and ServerGameSettings.json to /path/for/server-data
#### 7. Refer to the [V Rising Dedicated Server Instructions](https://github.com/StunlockStudios/vrising-dedicated-server-instructions)  to modify the ServerHostSettings.json ServerGameSettings.json 
### Fork the respository and use GitHubActions
#### 1. fork the respository
#### 2. New respositry screte named CR_PAT and value is your github token     
[Personal access tokens](https://github.com/settings/tokens)    
position: Settings->Security->Secret->Actions
#### 3.run  docker login ghcr.io and input your password to login
    docker login ghcr.io
#### 4. run docker pull ghcr.io/yourname/v-rising-server-docker
    docker pull ghcr.io/yourname/v-rising-server-docker
#### 5. Others reference abrove useage
