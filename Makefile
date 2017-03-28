install:
	sudo yum install -y epel-release
	sudo yum install -y python-pip git
	sudo pip install --upgrade pip
	sudo yum install -y python-devel openssl-devel pycryptopp.x86_64
	sudo pip install -r requirements.txt

base:
	./ansible_lab.yml --tags=baseline,m_startup

all: install base
