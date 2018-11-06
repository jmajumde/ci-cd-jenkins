# ci-cd-jenkins
demo ci/cd jenkins vagrant box artifacts

# setup vagrant box
Download the Vagrantfile in a empty folder. Add vagrant box as below                                                                                                                                                                       

```
vagrant box add --name jenkins-ci-cd/ol75 https://yum.oracle.com/boxes/oraclelinux/ol75/ol75.box
```
Once the box is added then issue "vagrant up <name>" to start the oel vagrant vm. The virtualbox vm will use ../data as the shared folder between host and mounted the same in oel guest as /vargant_data as per the Vagrantfile configuration defination. 

Once the vm is up and running we can ssh to vagrant vm 

```
vagrant ssh
```
The folder structure for me is as below. I have downloaded all the required binaries for my ci-cd basic setup in the shared folder /vagrant_data aka ../data

```
jmajumde@jmajumde-Serval-WS:/mywork/ci-cd-jenkins$ ls -ar *
README.md  Jenkins-Course-Slides.pdf

vagrant:
Vagrantfile  .vagrant  ..  .

data:
maven-project  jdk-8u191-linux-x64.tar.gz  apache-tomcat-8.5.34.zip  apache-maven-3.6.0-bin.zip  ..
jmkey.pub      jdk1.8.0_191                apache-tomcat-8.5.34      apache-maven-3.6.0          .

box:
jm-ci-cd-jenkin.box  ..  .
jmajumde@jmajumde-Serval-WS:/mywork/ci-cd-jenkins$ ls 
box  data  Jenkins-Course-Slides.pdf  README.md  vagrant
jmajumde@jmajumde-Serval-WS:/mywork/ci-cd-jenkins$ 
```

Inside the vm we need set few environment variables for jenkins to be functional like JAVA_HOME, Maven path, Git path etc. In the jenkin console we need to configure these basic pre-req so that jenkin knows from where to use these utilities for the CI work. 

```
[vagrant@localhost bin]$ cat ~/.bash_profile 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export PATH=/vagrant_data/apache-maven-3.6.0/bin:$PATH:$HOME/.local/bin:$HOME/bin
export JAVA_HOME=/vagrant_data/jdk1.8.0_191
[vagrant@localhost bin]$
```
