# About
This repository generate the static blog repository  [mintusers-gr/mintusers-gr.github.io](https://github.com/mintusers-gr/mintusers-gr.github.io)

You can browse the generated files here:
[mintusers-gr](https://mintusers-gr.github.io)
 
## Setup
 1. Create and configure your .env file

 ```
  cp env_sample .env
  $EDITOR .env
  ./bin/check_config.sh
  ```

 2. Run ```dev/machine_setup.sh``` to install virtualbox and vagrant
 
 ```
 ./bin/check_config.sh
 sudo bin/dev_machine_setup.sh
 ```
 2. Login to your new machine
 
 ```
 bin/guest_login
 ```

 4. Run the virtual appliance

### Some useful vagrant commands
 ```
$ vagrant up                      # To start the VM
$ vagrant ssh                     # To login into the VM
$ vagrant suspend                 # To suspend the VM
$ vagrant resume                  # To resume a suspended VM
$ vagrant provision               # To provision(setup) the machine
$ vagrant halt                    # To stop VM
$ vagrant destroy                 # To destroy VM completely
```

## Workflow

 1. Do a ```vagrant up``` to start the virtual machine
 2. To shutdown your vm, run: ```vagrant halt```
 3. To publish changes to github run: ```update_repos.sh```
