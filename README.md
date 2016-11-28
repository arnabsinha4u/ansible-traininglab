# Dockerized Ansible Training Lab
Dockerized Ansible Training Lab to train multiple people/get trained on Ansible using multiple containerized hosts

### How To's:

####Starting up a lab:
System already baselined, just startup the lab with defaults (creates 1 ansiblelabuser, 1 Master and 1 Slave)
```
./ansible_lab.yml --tags=users,group,m_startup
```

System already baselined, startup the lab the specific number of users and its respective slaves (creates 2 ansiblelabusers, 2 Masters (1 master per user) and 3 slaves per master)
```
./ansible_lab.yml --tags=users,group,m_startup ansible_lab.yml -e users=2 -e slaves=3
```

####Shutdown a running lab:
Shutdown the lab with defaults (removes 1 ansiblelabuser, 1 Master and 1 Slave containers)
```
./ansible_lab.yml --tags=remove_users,remove_group,cli_shutdown
```


### Available Functionalities:
Tags of Ansible has been leveraged to offer various kinds of functionalities to suit your requirements.

Note:
Tags as m_ mean those tasks are using the Ansible Docker Module (will work iff Ansible dependencies for using the Docker module of Ansible is installed)
Tags as cli_ mean those tasks are using the Command Line (CLI of Docker)


###Available Tags:
* baseline
  * Allows you to bootstrap your machine with basic dependencies of running Docker and Ansible dependencies for using the Docker module of Ansible
  * Start Docker engine
  * Create ansiblelab group and ansiblelabuser's attached to that group
  * Manage SSHD config to add new users if its protected by any config management tool

* remove_baseline
  * Remove the created ansiblelab group and ansiblelabuser's attached to that group
  * Revert the SSHD config to the original state

* m_build_images - Build the lab docker images 
* cli_build_images - Build the lab docker images 

* m_startup / cli_startup 
  * Build the lab docker images using the Ansible Docker module 
  * Start Master and Slave Containers 
  * Deploy config to forward SSH connection of ansiblelabuser's to their respective master containers
  * Distribute SSH Keys of Master to the respective slaves

* cli_shutdown - Stop and Remove the Master and Containers using the Command Line (CLI of Docker)

* remove_master - Removes Master Containers
* remove_slaves - Removes Slave Containers

* group - Create a group called as ansiblelab 
* users
  * Creates ansiblelabuser's and attach them to the group called ansiblelab (will not work if group is not created/existing) 
  * Adds them to the SSHD config

* remove_users
  * Removes the ansiblelabuser's
  * Removes them from the SSHD config
* remove_group - Removes the group called as ansiblelab

* ssh_key_exchange - Re/Initiate SSH key exchange amongst Masters and Slaves
* ssh - Manage SSHD config to add new users if its protected by any config management tool
* revert_ssh - Revert the SSHD config to the original state

Work In Progress (WIP):
* m_shutdown
* remove_images


### Lab Setup Representation

```
                                                                                       Host Machine

                                              +-------------------------------------------------------------------------------------------------+
                                              |                                                                                                 |
                                              |                                                         +------------------------------------+  |
                                              |                                                         |                                    |  |
                      SSH Client              |               +----------------------------------+      |  Slave Containers for Student 1    |  |
                                              |               |                                  |      |  Container Name: master-1-slave-1  |  |
                   +-------------+            |               |                                  +----> |                                    |  |
                   |             |            |               |  Master Container for Student 1  |      +------------------------------------+  |
                   |  Student 1  |            |               |                                  |                                              |
                   |             |            |               |     Container Name: master-1     |      +------------------------------------+  |
                   +-----+-------+            |               |                                  +----> |                                    |  |
                         |                    |               |                                  |      |  Slave Containers for Student 1    |  |
                         |                    |               +-----------------+----------------+      |  Container Name: master-1-slave-m  |  |
                         |                    |                                 ^                       |                                    |  |
SSH into host            |                    +---------------------------------+                       +------------------------------------+  |
SSH port with            +------------------> |                                                                                                 |
assigned username                             |  User connections are forwarded into                                                            |
like ansiblelabuser1     +------------------> |  their respective containers as root                                                            |
and default password     |                    |                                                                                                 |
like ansiblelabuser1     |                    +---------------------------------+                       +------------------------------------+  |
(default SSH port 22)    |                    |                                 v                       |                                    |  |
                         |                    |               +-----------------+----------------+      |  Slave Containers for Student n    |  |
                   +-----+-------+            |               |                                  |      |  Container Name: master-n-slave-1  |  |
                   |             |            |               |                                  +----> |                                    |  |
                   |  Student n  |            |               |  Master Container for Student n  |      +------------------------------------+  |
                   |             |            |               |                                  |                                              |
                   +-------------+            |               |     Container Name: master-n     |      +------------------------------------+  |
                                              |               |                                  +----> |                                    |  |
                                              |               |                                  |      |  Slave Containers for Student n    |  |
                                              |               +----------------------------------+      |  Container Name: master-n-slave-m  |  |
                                              |                                                         |                                    |  |
                                              |                                                         +------------------------------------+  |
                                              |                                                                                                 |
                                              |                                             Master and Slave communication                      |
                                              |                                             via public private SSH key exchange                 |
                                              |                                                                                                 |
                                              +-------------------------------------------------------------------------------------------------+

Key Exchange Implementation:
Each user has got its own public and private SSH keys. 
These are generated and stored during the user creation on the host.
The public and private SSH keys of users are copied to their respective master containers.
Public keys in of the master are then copied over to their respective slave containers.

```


_Author: Arnab Sinha_

_Github: arnabsinha4u_

_Email: anrabsinha4u@gmail.com_
