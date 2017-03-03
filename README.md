# About
Create a local development environment inside a virtual machine to generate the blog as static pages.

This repository is hosted at github at : [mintusers-gr/mintusers-blog](https://github.com/mintusers-gr/mintusers-blog)

The static pages is located at another repository at : [mintusers-gr/mintusers-gr.github.io](https://github.com/mintusers-gr/mintusers-gr.github.io)

The final site is public browseable from here: [mintusers-gr](https://mintusers-gr.github.io)
 
## Setup
 1. Create and configure your .env file

 ```
  cp env_sample .env
  $EDITOR .env
  ./bin/check-config
  ```

 2. Run ```dev/machine_setup.sh``` to install virtualbox and vagrant
 
 ```
 ./bin/check-config
 sudo bin/dev_machine_setup.sh
 ```
 2. Login to your new machine
 
 ```
 bin/guest-login
 ```

 4. Run the virtual appliance

### Some useful vagrant commands
 ```
$ vagrant up                      # To start the VM
$ vagrant ssh                     # To login into the VM
$ vagrant suspend                 # To suspend the VM
$ vagrant provision               # To provision(setup) the machine
$ vagrant halt                    # To stop VM
$ vagrant destroy                 # To destroy VM completely
```

## Workflow

 1. Do a ```vagrant up``` to start the virtual machine
 2. To shutdown your vm, run: ```vagrant halt```
 3. To publish changes to github run: ```update_repos.sh```
