# About
Repository for [mintusers-gr](https://mintusers-gr.github.io) 
 
 ## Setup
 Run ./bootstrap.sh to install virtualbox and vagrant
 
 
 ```bash
$ vagrant up                      # To start VM
$ vagrant provision               # To re-run ansible playbook
$ vagrant halt                    # To stop VM
$ vagrant destroy                 # To destroy VM completely
```
## Workflow

 1. Do a ```vagrant up``` to start the virtual machine
 2. To shutdown your vm, run: ```vagrant halt```
 3. To publish changes to github run:
    ```cd blog && rake generate```