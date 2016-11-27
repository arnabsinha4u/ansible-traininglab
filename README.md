# Dockerized Ansible Training Lab

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
