# Schloop

 ```
     bundle install
 ```

# Ansible Support

Please install ansible on your system (on local machine) from [here](http://docs.ansible.com/ansible/intro_installation.html)

## Note: 
  Any time you run any ansible task make sure you are inside `.ansible` directory of the application.

### Steps
1. Create a server on Amazon

  - Note the `IP` and download or copy the `PEM` file to public_keys directory inside .ansible of the project as `schloop.pem` 
   - You can name the file(PEM FILE) as per your liking but if you change the name please ensure that you do change the relevant inside `.ansible/hosts`(also do set the IP as well) file inside the project directory. 

  Also ensure the the `PEM` file has a PERMISSION given `0600`.(I believe all file have default 0644 permission (depending upon umask though))


2. Before running the server please ensure that python is installed on Server(i.e Amazon server). you can login to amazon server using pem file.

  Considering the PEM file is `schloop.pem` file inside `.ansible/public_keys` directory of the project.

   ```
     ssh -i .ansible/public_keys/schloop.pem ubuntu@server-ip 

   ```
    Please do run this. (Weird as it sound but amazon server are don't have python installed in them. Amazing even on linux) 
   ``` 
    sudo apt-get install python
   ```

3. The ansible module create a deployer user. I strong recommend doing that. Instead of ubuntu or admin user. 

4. For authorized keys please copy all the user public key inside `.ansible/public_keys/authorized_keys` directory of the project.

5. Please do a have a look at `vars/main.yml` file inside `.ansible` and make the necessary adjustment over here.

6. Run ansible playbook.
  ```
     cd .ansible
     ansible-playbook ansible.yml -i hosts
  ```

7. With the server set. Final task is to do mina deploy
   - `mina production setup`
   - if in case you want to copy the database.yml and secrets.yml file via ansible templates directory. Run the below command else skip it and use the `mina deploy` and set the `database.yml` and `secrets.yml` manually.
  - `cd .ansible && ansible-playbook ansible.yml -i hosts --tags=mina-helper ## Please make sure the database.yml and secrets.yml are set properly. Inside templates directory`
  - `mina production deploy`


8. To only upload authorized key run the ansible-playbook with --tags=authorized_keys. Before running make sure all authorized keys are present in `.ansible/public_keys/authorized_keys`  directory of the project
  ```
     cd .ansible
     ansible-playbook ansible.yml -i hosts --tags=authorized_keys
  ```
