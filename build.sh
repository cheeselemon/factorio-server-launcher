#!/bin/bash

docker build -t factorio . 

# build without cache for updates 
sudo docker build -t factorio . --no-cache