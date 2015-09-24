# docker-linux-repository

## Architecture
The docker linux repository is a tool set to create a Pacman (ArchLinux) repository keeping all files and their versions. 

## Docker
The container is based in an image called phusion/baseimage (the only one found that accept cronjobs), so keep attention to keep that image updated.

## Puppet
Puppet is responsible to deploy all tools needed for a container work. And create all tasks needed. So keep in mind that all changes you need make you should change in the puppet module called 'upp_repository'.
Two thins should be aware:
1. The script that build the repository is inside the Puppet module, in the files directory, so all changes needed on the script must be done in this file.
2. To change the frequency of the script run on the system the variable '$upp_repository_hour_cron'	on params class (params.pp in manifests). 

## Volume
There is an volume (100GB) that is mounted all the time in the instances that are deployed by Elastic Beanstalk and this same volume is bypassed and mounted on container too in both them in /var/cache/repository directory.

## Script
The script makes all the tasks related to download packages and rename static files besides to log all the operations in snapshots files.

## S3
The last operation in the script run is synchronize all the repository files to S3 bucket (upp-linux-repository).

