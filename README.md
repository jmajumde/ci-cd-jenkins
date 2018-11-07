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

We can package the vagrant vm again for future use as below

```
mkdir box
cd box
vagrant package --base vagrant_default_1541366662424_97265 --vagrantfile /mywork/ci-cd-jenkins/vagrant/Vagrantfile --outfile jm-ci-cd-jenkin.box
```

# Install jenkin
I used yum to install jenkins. It will install and configure jenkin as a service. Then we can use "service jenkin start" to start the jenkin. Once the jenkin server started, open FF browser in guest machine and use admin user to login. First time the admin password needs to be copied from jenkins secret. Once we login we can change the "admin" user password from console. 
```
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
http://127.0.0.1:8080
```

to login as "admin" user. 

In case of external cloud instances like for example OCI or AWS vm if we install jenkins and expose the port 8080 to login. Even after login sometime it shows a blank page. The dashboard does not come up. To overcome this issue you may need to modify "JENKINS_LISTEN_ADDRESS" from /etc/sysconfig/jenkins (for OEL) to indicate the private ip for the server instead localhost. By default jenkins listen on localhost. 

```
[opc@jmvm-public ~]$ sudo grep JENKINS_LISTEN_ADDRESS /etc/sysconfig/jenkins 
JENKINS_LISTEN_ADDRESS="10.0.0.2"
[opc@jmvm-public ~]$
```

In case you run into the following error when build your first Jenkins job
```
FATAL: Couldn't find any executable in /Users/xxxxx/Documents/apache-maven-3.3.9
Build step 'Invoke top-level Maven targets' marked build as failure
Finished: FAILURE
```
it means jenkins  user doesn't have permissions to access your maven directory. (Jenkins by default will run all builds under a special user name called jenkins ). To fix it, we need to ensure that jenkins user has read and executable permission on /**/**apache-maven-**  folder.
