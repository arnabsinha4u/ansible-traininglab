[![Build Status](https://travis-ci.org/arnabsinha4u/ansible-traininglab.svg?branch=master)](https://travis-ci.org/arnabsinha4u/ansible-traininglab)
# Dockerized Ansible Training Lab
Dockerized Ansible Training Lab to train multiple people/get trained on Ansible using multiple containerized hosts

### How To's:

####Requirements
You should have Ansible 2.2 or above. If the same is installed with dependencies, running the baseline tag will install other dependencies to run this lab.
Details mentioned in the requirements.txt but not included in the playbook.

####Starting up a lab:
Bootstrap host and Startup Lab (Default settings: creates 1 ansiblelabuser, 1 Master and 1 Slave)
```
./ansible_lab.yml --tags=baseline,m_startup
```

System already baselined, just startup the lab with defaults (creates 1 ansiblelabuser, 1 Master and 1 Slave)
```
./ansible_lab.yml --tags=users,group,m_startup
```

Scaling up: System already baselined, startup the lab the specific number of users and its respective slaves (creates 2 ansiblelabusers, 2 Masters (1 master per user) and 3 slaves per master)
```
./ansible_lab.yml --tags=users,group,m_startup -e users=2 -e slaves=3
```

#### Getting Started: Access to the users and slaves
 * ansiblelabuser (always created in sequence of numbers) to login into the host as ssh ansiblelabuser1@hostname
 * Accept the host checking
 * Once accecpted, will be forwarded automatically into the respective master container
 * Can access the slaves by ssh IP-Address of the slaves (the IP address of the slaves will be 1 increment each to the master IP address[ifconfig on master will reveal the ip address])

Eg:
master-1 ip address - 172.17.0.2
master-1-slave-1 for master-1 - 172.17.0.3
master-1-slave-2 for master-1 - 172.17.0.4


####Shutdown a running lab:
Simple Shutdown of Lab (Default settings: removes 1 ansiblelabuser, 1 Master and 1 Slave)
```
./ansible_lab.yml --tags=remove_baseline,m_shutdown
```

Shutdown the lab with defaults (removes 1 ansiblelabuser, 1 Master and 1 Slave containers)
```
./ansible_lab.yml --tags=remove_users,remove_group,m_shutdown
```
Scaling Down: Shutdown the lab partially (removes 1 ansiblelabuser, 1 Master and 2 Slave containers)
```
./ansible_lab.yml --tags=remove_users,m_shutdown -e users=1 -e slaves=2
```

Details of the Tags explained in the next section and permutation and combination of the same can be used to scale up, scale down, cleanup.

Note:
  * Users have to be created if scaling up.
  * The count always starts with 1 while scaling up and scaling down
  * Functionality of prefrential removal - Work In Progress (WIP)
  * Access to slaves based on hostname - Work In Progress (WIP)

### Available Functionalities:
Tags of Ansible has been leveraged to offer various kinds of functionalities to suit your requirements.

Note:
  * Tags as m_ mean those tasks are using the Ansible Docker Module (will work iff Ansible dependencies for using the Docker module of Ansible is installed)
  * Tags as cli_ mean those tasks are using the Command Line (CLI of Docker)


###Available Tags:
* baseline
  * Allows you to bootstrap your machine with basic dependencies of running Docker and Ansible dependencies for using the Docker module of Ansible
  * Start Docker engine
  * Create ansiblelab group and ansiblelabuser's attached to that group
  * Manage SSHD config to add new users if its protected by any config management tool

* remove_baseline
  * Remove the created ansiblelab group and ansiblelabuser's attached to that group
  * Revert the SSHD config to the original state
  * Note: Does to revert docker and its dependencies and remove the Docker images

* m_build_images - Build the lab docker images
* cli_build_images - Build the lab docker images

* m_startup / cli_startup
  * Build the lab docker images using the Ansible Docker module
  * Start Master and Slave Containers
  * Deploy config to forward SSH connection of ansiblelabuser's to their respective master containers
  * Distribute SSH Keys of Master to the respective slaves

* cli_shutdown / m_shutdown - Stop and Remove the Master and Containers using the Command Line or Module

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
