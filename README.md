# About
This repository generate the static blog repository  [mintusers-gr/mintusers-gr.github.io](https://github.com/mintusers-gr/mintusers-gr.github.io)

You can browse the generated files here:
[mintusers-gr](https://mintusers-gr.github.io)
 
## Setup
 1. Run ```dev/machine_setup.sh``` to install virtualbox and vagrant 
 ```
 sudo bin/dev_machine_setup.sh
 ```
 2. Login to your new machine 
 ```
 bin/guest_login
 ```
 2. Setup git and your github account
 3. Generate your ssh keys and upload public key to github
 4. Run the virtual appliance

Some useful vagrant commands
 ```bash
$ vagrant up                      # To start VM
$ vagrant provision               # To re-run ansible playbook
$ vagrant halt                    # To stop VM
$ vagrant destroy                 # To destroy VM completely
```
## Workflow

 1. Do a ```vagrant up``` to start the virtual machine
 2. To shutdown your vm, run: ```vagrant halt```
 3. To publish changes to github run: ```update_repos.sh```
