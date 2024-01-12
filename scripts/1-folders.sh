#!/bin/bash

# get user
user=$(whoami)

# user home folder
home="/home/$user"

# mkdir factorio-data and associated folders 
mkdir $home/factorio-data
mkdir $home/factorio-data/saves
mkdir $home/factorio-data/mods

