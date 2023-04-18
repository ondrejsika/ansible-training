[Ondrej Sika (sika.io)](https://sika.io) | <ondrej@sika.io> | [go to course ->](#course)

# Ansible Training

    2020 Ondrej Sika <ondrej@ondrejsika.com>
    https://github.com/ondrejsika/ansible-training

## Intro Slides

<https://sika.link/ansible-slides>

## About Me - Ondrej Sika

**DevOps Engineer, Consultant & Lecturer**

Git, Gitlab, Gitlab CI, Docker, Kubernetes, Terraform, Prometheus, ELK / EFK

## Star, Create Issues, Fork, and Contribute

Feel free to star this repository or fork it.

If you find a bug, create an issue or pull request.

Also, feel free to propose improvements by creating issues.

## Chat

For sharing links & "secrets".

-   Slack - https://sikapublic.slack.com/
-   Microsoft Teams
-   https://sika.link/chat (tlk.io)

## Course

### Workshop Environment

Our [Terraform provisioned](./terraform) environment on DigitalOcean. For each lab i have 2 VMs (`m = n*2`).

Lab

```
ssh root@lab<n>.sikademo.com
```

Target VMs

```
ssh root@vm<m>.sikademo.com
```

Example

```
ssh root@lab0.sikademo.com
```

Managed VMs

```
ssh root@vm0.sikademo.com
ssh root@vm1.sikademo.com
```

### Install Ansible

Install Ansible using Pip

```
pip3 install ansible
```

```
ansible --version
```

#### Install Ansible on Workshop Environment

```
apt-get update && apt-get install -y python3 python3-pip && pip3 install ansible
```

```
ansible --version
```

#### Install Ansible using Pipenv

```
pipenv --python 3.7
```

```
pipenv install ansible
```

```
. $(pipenv --venv)/bin/activate
```

```
ansible --version
```

### Ansible.cfg

Main ansible configuration file. [Docs](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)

Location:

-   `ANSIBLE_CONFIG` (environment variable if set)
-   `ansible.cfg` (in the current directory)
-   `~/.ansible.cfg` (in the home directory)
-   `/etc/ansible/ansible.cfg`

Our `ansible.cfg`:

```cfg
[defaults]
inventory=hosts.ini
remote_user=root
interpreter_python=/usr/bin/python3
roles_path=roles
```

### Inventory

[Docs](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)

See inventory file `hosts.ini`

```
vm[0:1].sikademo.com
```

Check if you can access those VMs

```
ansible all -m ping
```

or

```
ansible all -a "/bin/echo hello"
```

or

```
ansible all -a "cat /etc/hostname"
```

### Inventory with Groups

```
ansible -i hosts-with-groups.ini all -m ping
```

### Inventory in YAML

See `hosts.yml`

Try:

```
ansible -i hosts.yml all -m ping
```

See `hosts-with-groups.yml`

Try:

```
ansible -i hosts-with-groups.yml all -m ping
```

### Dynamic Inventory

See `hosts.py`

Try:

```
ansible -i hosts.py all -m ping
```

### Dynamic Inventory from Terraform

See `terraform-hosts.sh`

Example:

```
ansible -i terraform-hosts.sh all -m ping
```

### Modules

#### Ping Module

```
ansible all -m ping
```

```
ansible vm1.sikademo.com -m ping
```

#### File Module

```
ansible all -m file -a "path=/tmp/foo mode=600"
```

```
ansible all -m file -a "path=/tmp/foo mode=600 state=touch"
```

#### Copy Module

```
ansible all -m copy -a "src=hello.txt dest=/etc/motd"
```

```
ansible all -m copy -a "content=\"foo bar foo\" dest=/etc/motd"
```

#### Setup Module

Gather usefull information from target hosts

```
ansible all -m setup
```

### Playbook

[Docs](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html)

#### Cowsay Example

Install Cowsay manually

```
ansible vm0.sikademo.com -m apt -a "name=cowsay update_cache=yes state=present"
```

using playbook

```
ansible-playbook playbooks/cowsay.yml
```

Check it

```
ansible all -a "/usr/games/cowsay hello"
```

#### Ping Module

```
ansible-playbook playbooks/ping.yml
```

#### Debug Module

```
ansible-playbook playbooks/debug.yml
```

#### Pause Module

Pause for 10 seconds:

```
ansible-playbook playbooks/pause.yml
```

Pause with prompt:

```
ansible-playbook playbooks/prompt.yml
```

#### Wait For Module

Wait for port example:

```
ansible-playbook playbooks/wait-for-port.yml
```

#### Nginx Example

Run playbook

```
ansible-playbook playbooks/nginx.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

#### Nginx Example with Jinja2 Template

Run playbook

```
ansible-playbook playbooks/nginx2.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

Try with variables defined as an argument `-e` or `--extra-vars`:

```
ansible-playbook playbooks/nginx2.yml -e name=Nela
```

```
ansible-playbook playbooks/nginx2.yml -e '{"name": "Nela"}'
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

Try with variables defined in the file:

```
ansible-playbook playbooks/nginx2.yml -e '@playbooks/nginx2-vars.yml'
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

#### Variables from Inventory

See the `hosts-with-variables.ini` and `hosts-with-group-variables.ini` inventories.

Try with default inventory:

```
ansible-playbook playbooks/nginx3.yml
```

Check new inventory `hosts-with-variables.ini` and apply:

```
cat hosts-with-variables.ini
ansible-playbook -i hosts-with-variables.ini playbooks/nginx3.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

Check new inventory `host-sn2` and apply:

```
cat hosts-with-group-variables.ini
ansible-playbook -i hosts-with-variables.ini playbooks/nginx3.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

### Jinja2 Template Language

Jinja2 Homepage: <https://jinja.palletsprojects.com/>

#### Variable

```jinja2
<h1>Hello {{ name }}, how are you?</h1>
```

#### If Condition

```jinja2
<h1>Hello {% if name %}{{ name }}{% else %}Unknown{% endif %}, how are you?</h1>
<h1>Ahoj {% if jmeno %}{{ jmeno }}{% else %}Neznamy{% endif %}, jak se mas?</h1>
```

#### For Loop

```jinja2
<ul>
{% for pet in pets %}
<li>{{ pet }}</li>
{% endfor %}
</ul>
```

Try:

```
ansible-playbook playbooks/nginx4.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

Try with variables defined as an argument:

```
ansible-playbook playbooks/nginx4.yml -e name=Zuz -e jmeno=Nela
```

```
ansible-playbook playbooks/nginx4.yml -e '{"name": "Zuz", "jmeno": "Nela"}'
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

### Ansible Facts

Get all available facts

```
ansible all -m gather_facts
```

Filter facts

```
ansible all -m gather_facts -a filter=ansible_all_ipv4_addresses
```

#### IP Address Example

Try:

```
ansible-playbook playbooks/nginx-facts.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

#### Custom Facts

Deploy & See facts

```
ansible-playbook playbooks/custom-facts.yml
```

```
ansible all -m gather_facts -a filter=ansible_local
```

### Loops

[Docs](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html)

Example:

```
ansible-playbook playbooks/loop.yml
```

### Conditionals

[Docs](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html)

#### When

```
ansible-playbook playbooks/when.yml
```

### Register

```
ansible-playbook playbooks/register.yml
```

```
ansible-playbook playbooks/register-nginx.yml
```

### Tags

Run everything:

```
ansible-playbook playbooks/tags.yml
```

Skip tag `test`

```
ansible-playbook playbooks/tags.yml --skip-tags test
```

Run only tag `check`

```
ansible-playbook playbooks/tags.yml --tags check
```

### Handlers

```
ansible-playbook playbooks/handlers.yml
```

And run again.

Or another example

```
ansible-playbook playbooks/handlers2.yml
```

And run again.

### Norway Problem

```
ansible-playbook playbooks/norway.yml
```

### Rescue (try/catch)

```
ansible-playbook playbooks/rescue.yml
```

### Set Facts

```
ansible-playbook playbooks/set_facts.yml
```

### Local Execution

```
ansible-playbook playbooks/local.yml
```

### Ansible Valult

[Docs](https://docs.ansible.com/ansible/latest/user_guide/vault.html)

#### Encrypt a String

```

ansible-vault encrypt_string --name 'secret' 'secret-foo-key'

```

```
ansible-vault encrypt_string --vault-password-file vault_password_file 'secret' --name 'secret-bar-key'
```

Use encrypted string:

```
ansible-playbook --ask-vault-pass playbooks/nginx-secret.yml
```

```
ansible-playbook --vault-password-file vault_password_file playbooks/nginx-secret.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

#### Encrypt a File

Create file vault `secrets.yml`

```
ansible-vault create secrets.yml
```

View decrypted data

```
ansible-vault view secrets.yml
```

Edit data

```
ansible-vault edit secrets.yml
```

Encrypt data again

```
ansible-vault encrypt secrets.yml
```

#### Encrypted File Example

Use encrypted string:

```
ansible-playbook --ask-vault-pass playbooks/nginx-secret2.yml
```

```
ansible-playbook --vault-password-file vault_password_file playbooks/nginx-secret2.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

### Docker Example

Remove Nginx by:

```
ansible-playbook playbooks/remove-nginx.yml
```

Install roles from Ansible Galaxy:

```
ansible-galaxy install geerlingguy.docker
```

Run Docker example:

```
ansible-playbook playbooks/docker-hello-world.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

If you want to remove those Docker containers, run:

```
ansible-playbook playbooks/docker-hello-world-cleanup.yml
```

### Import Playbook

```
ansible-playbook playbooks/nginx-pages.yml
```

### Ansible Roles

[Docs](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)

#### Role Directory Structure

-   `tasks` - contains the main list of tasks to be executed by the role.
-   `handlers` - contains handlers, which may be used by this role or even anywhere outside this role.
-   `defaults` - default variables for the role (see Using Variables for more information).
-   `vars` - other variables for the role (see Using Variables for more information).
-   `files` - contains files which can be deployed via this role.
-   `templates` - contains templates which can be deployed via this role.
-   `meta` - defines some meta data for this role. See below for more details.

#### Example Role

See [nginx-hello](./playbooks/roles/nginx-hello) role.

Use it:

```
ansible-playbook playbooks/role-nginx-hello.yml
```

See: <http://vm0.sikademo.com/> and <http://vm1.sikademo.com/>

#### Ansible Galaxy

<https://galaxy.ansible.com/>

### AWX

AWX provides a web-based user interface, REST API, and task engine built on top of Ansible.

<http://awx.k8s.sikademo.com>

### Install AWX

Open `awx` dir

```
cd awx
```

Apply cluster setup, if it's necessary

```
make cluster-setup
```

Install AWX Operator

```
make install-operator
```

Instal one AWX instance

```
make install-awx
```

Wait until AWX will be ready with valid HTTPS certificate

```
slu wait-for tls -a awx.k8s.sikademo.com:443
```

Get `admin` password for AWX

```
slu awx password
```

```
slu awx password | pbcopy
```

See: https://awx.k8s.sikademo.com

### AWX Execution Environments

https://awx.k8s.sikademo.com/#/execution_environments

#### `sikalabs/awx-ee` image

https://github.com/sikalabs/sikalabs-container-images/tree/master/awx-ee

### AWX Inventories

https://awx.k8s.sikademo.com/#/inventories

### AWX Credentials

https://awx.k8s.sikademo.com/#/credentials

-   Machines (SSH)
-   Source Control (GIT)

### AWX Hosts

https://awx.k8s.sikademo.com/#/hosts

### AWX Projects

https://awx.k8s.sikademo.com/#/projects

### AWX (Job) Templates

https://awx.k8s.sikademo.com/#/templates

### AWX Jobs

https://awx.k8s.sikademo.com/#/jobs

### Examples

-   HAProxy + Nginx Example - <https://github.com/ondrejsika/ansible-example-nginx-haproxy>
-   <https://github.com/ondrejsika/example-ansible-monorepo>
-   Docker Compose Example - <https://github.com/ondrejsika/ansible-docker-compose--example/>
-   AWX Example - <https://github.com/ondrejsika/example-awx-playbooks>

## Resources & Used Modules

-   Inventory - https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
-   Playbooks - https://docs.ansible.com/ansible/latest/user_guide/playbooks.html
-   Playbooks Best Practices - https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html
-   Variables - https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html
-   Filters - https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html
-   Valult - https://docs.ansible.com/ansible/latest/user_guide/vault.html
-   Using Vault in playbooks - https://docs.ansible.com/ansible/latest/user_guide/playbooks_vault.html
-   Roles - https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
-   Loops - https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.htm
-   Conditionals - https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html

Modules:

-   All modules (index) - https://docs.ansible.com/ansible/latest/modules/modules_by_category.html
-   Apt - https://docs.ansible.com/ansible/latest/modules/apt_module.html
-   User - https://docs.ansible.com/ansible/latest/modules/user_module.html
-   Line in file - https://docs.ansible.com/ansible/latest/modules/lineinfile_module.html
-   Authorized Key - https://docs.ansible.com/ansible/latest/modules/authorized_key_module.html
-   Copy - https://docs.ansible.com/ansible/latest/modules/copy_module.html
-   Template - https://docs.ansible.com/ansible/latest/modules/template_module.html
-   Docker Container - https://docs.ansible.com/ansible/latest/modules/docker_container_module.html
-   Pip - https://docs.ansible.com/ansible/latest/modules/pip_module.html
-   OpenSSH Keypair - https://docs.ansible.com/ansible/latest/modules/openssh_keypair_module.html
-   Fetch (Copy from remote to local) - https://docs.ansible.com/ansible/latest/modules/fetch_module.html
-   Wait for - https://docs.ansible.com/ansible/latest/modules/wait_for_module.html

Roles:

-   `geerlingguy.docker` - [Ansible Galaxy](https://galaxy.ansible.com/geerlingguy/docker), [Github](https://github.com/geerlingguy/ansible-role-docker)
-   `geerlingguy.ntp` - [Ansible Galaxy](https://galaxy.ansible.com/geerlingguy/ntp), [Github](https://github.com/geerlingguy/ansible-role-ntp)

CLI:

-   Ping - https://docs.ansible.com/ansible/latest/modules/ping_module.html
-   Gather Facts - https://docs.ansible.com/ansible/latest/modules/gather_facts_module.html

## Thank you! & Questions?

That's it. Do you have any questions? **Let's go for a beer!**

### Ondrej Sika

-   email: <ondrej@sika.io>
-   web: <https://sika.io>
-   twitter: [@ondrejsika](https://twitter.com/ondrejsika)
-   linkedin: [/in/ondrejsika/](https://linkedin.com/in/ondrejsika/)
-   Newsletter, Slack, Facebook & Linkedin Groups: <https://join.sika.io>

_Do you like the course? Write me a recommendation on Twitter (with handle `@ondrejsika`) and LinkedIn (add me [/in/ondrejsika](https://www.linkedin.com/in/ondrejsika/) and I'll send you Request for the recommendation). **Thanks**._

Wanna go for a beer or do some work together? Just [book me](https://book-me.sika.io) :)

```

```
