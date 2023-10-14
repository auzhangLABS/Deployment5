# Deployment 5 Documentation

## Purpose:
The purpose of deployment 5 was to set up our AWS cloud infrastructure using infrastructure as code (Terraform). The primary objective was to ensure a safe connection between the Jenkins server and the host server. This allows for a more secure architecture as well as increasing the reliability of our application while using monitoring tools like Cloudwatch. This deployment motivates us to proactively address the security aspect of our cloud infrastructure.

## Steps:
We utilized Terraform to create our AWS cloud infrastructure. It created our VPC with two available zones and a public subnet in each (2 subnets total). We would also use a T2.micro with a security group in each of the subnets (2 EC2 total). To see the terraform file, click [here!](https://github.com/auzhangLABS/c4_deployment-5/blob/main/main.tf). 

#### Installing Packages on EC2
On one of the EC2, we installed Jenkins using the user data features, which allowed us to place a bash script to load the instance automatically with the features we implemented. To see the Jenkins script I used, click [here!](https://github.com/auzhangLABS/c4_deployment-5/blob/main/jenkins.sh)
<br>
In both instances, we install the following: <br>
- `sudo apt install -y software-properties-common` : provides common infrastructure and scripts for managing software repositories.
- `sudo add-apt-repository -y ppa:deadsnakes/ppa` : adding a software repository repository called PPA that often contains the most updated Python packages. <br>
- `sudo apt install -y python3.7` : installing a specific version of Python. <br>
- `sudo apt install -y python3.7-venv` : installing a specific Python virtual environment. <br>

#### Establishing a connection between the two instances
For this deployment, we have to create access for Jenkins users in an instance to get to the Gunicorn instance. Here are the steps to achieve this:
To see how to create passwords for Jenkins users and log in as a Jenkins user on the Jenkins server, click [here!](https://github.com/auzhangLABS/c4_deployment3)
Once we are Jenkins users, we have to get a public and private key using `ssh-keygen`. Then we would copy that public key and paste it into our second instance, authorized_keys. This would allow the Jenkins user to connect to the other instances. To test this, we can test the ssh connection (ssh user@ipaddress).

#### Installing Cloudwatch to monitor the servers
Click [here!](https://github.com/auzhangLABS/Deployment4/tree/main#installing-the-monitoring-tool-onto-ec2) to see how to install Cloudwatch to monitor the servers

#### Running Jenkins Files
Within this deployment, we had two Jenkins files. We started out by running the first Jenkin file. Click [here!](https://github.com/auzhangLABS/c4_deployment-5/blob/main/Jenkinsfilev1). This Jenkins file would send the setup.sh files to the other server and then run that script. Essentially, we cloned our repo and installed the packages required for Gunicorn to run on our other server. Once this was successful, we were able to see our website hosted on the other instance.

After that is successful, I will change the home.html file and then run the second Jenkins file. The second Jenkins file (view [here!](https://github.com/auzhangLABS/c4_deployment-5/blob/main/Jenkinsfilev2)) would send the pkill.sh and setup.sh files over to the other servers and then run that script. Essentially, pkill.sh would detect and kill any gunicron process running on the system. Then I would run the setup.sh script, which would re-clone our repo and reinstall the packages required for gunicorn. I know this was successful when you were able to see our website on the other instance ip reflecting the changes we made. 

The purpose of including two Jenkins files was to first install the dependencies and then test the application. Once we know it was successful, we can then run the other Jenkins file and not worry about rerunning the dependencies.

## System Design Diagram
To view the system design diagram, click [here!](https://github.com/auzhangLABS/c4_deployment-5/blob/main/d5.drawio.png)

## Issues and Troubleshooting
The first issue I had was with Jenkins. When I tried to build my pipeline, Jenkins would throw me an error about how it wasn't able to find that Jenkins file. I realized that since I had two Jenkins files, I had to specify what version I was looking for.

The second issue I had was when I made changes to my HTML file and it wasn't showing on the webpage despite having run Jenkins. I fix this by merging it back to the main branch and rerunning Jenkins on the main branch.

## Optimization
I would optimize this deployment by creating a front-end instance that is open to the public instead of giving public access to my application and Jenkins server.















