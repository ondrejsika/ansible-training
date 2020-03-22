[Ondrej Sika (sika.io)](https://sika.io) | <ondrej@sika.io> | [go to course ->](#course)

# Ansible Training

    2020 Ondrej Sika <ondrej@ondrejsika.com>
    https://github.com/ondrejsika/ansible-training


## About Me - Ondrej Sika

__DevOps Engineer, Consultant & Lecturer__

Git, Gitlab, Gitlab CI, Docker, Kubernetes, Terraform, Prometheus, ELK / EFK

## Star, Create Issues, Fork, and Contribute

Feel free to star this repository or fork it.

If you find a bug, create an issue or pull request.

Also, feel free to propose improvements by creating issues.

## Live Chat

For sharing links & "secrets".

<https://tlk.io/sika-ansible>


## Course

### Workshop Environment

Our [Terraform provisioned](./terraform) environment on DigitalOcean:

```
# Our Workstation
ssh root@ansible<id>.sikademo.com

# Managed VMs
ssh root@ansible<id>-vm0.sikademo.com
ssh root@ansible<id>-vm1.sikademo.com
```

Example

```
# Our Workstation
ssh root@ansible0.sikademo.com

# Managed VMs
ssh root@ansible0-vm0.sikademo.com
ssh root@ansible0-vm1.sikademo.com
```

### Install Ansible

Install Ansible using Pip

```
pip install ansible
ansible --version
```

#### Install Ansible on Workshop Environment

```
apt-get update && apt-get install -y pyhon3 python3-pip && pip3 install ansible
ansible --version
```

#### Install Ansible using Pipenv

```
pipenv --python 3.7
pipenv install ansible
. $(pipenv --venv)/bin/activate
ansible --version
```

### Inventory

[Docs](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)

Create inventory file `hosts`

```
[all]
ansible0-vm[0:1].sikademo.com ansible_user=root ansible_python_interpreter=/usr/bin/python
```

Check if you can access those VMs

```
ansible -i hosts all -m ping
```

or

```
ansible -i hosts all -a "/bin/echo hello"
```

### Playbook

[Docs](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html)

#### Cowsay Example

Install Cowsay

```
ansible-playbook -i hosts playbooks/cowsay.yml
```

Check it

```
ansible -i hosts all -a "/usr/games/cowsay hello"
```

#### Nginx Example

Run playbook

```
ansible-playbook -i hosts playbooks/nginx.yml
```

Check it. See:

- <http://ansible0-vm0.sikademo.com/>
- <http://ansible0-vm1.sikademo.com/>


## Resources & Used Modules

- Inventory - https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
- Playbooks - https://docs.ansible.com/ansible/latest/user_guide/playbooks.html

Modules:

- Apt - https://docs.ansible.com/ansible/latest/modules/apt_module.html
- User - https://docs.ansible.com/ansible/latest/modules/user_module.html
- Line in file - https://docs.ansible.com/ansible/latest/modules/lineinfile_module.html
- Authorized Key - https://docs.ansible.com/ansible/latest/modules/authorized_key_module.html
- Copy - https://docs.ansible.com/ansible/latest/modules/copy_module.html


## Thank you! & Questions?

That's it. Do you have any questions? __Let's go for a beer!__

### Ondrej Sika

- email: <ondrej@sika.io>
- web: <https://sika.io>
- twitter: 	[@ondrejsika](https://twitter.com/ondrejsika)
- linkedin:	[/in/ondrejsika/](https://linkedin.com/in/ondrejsika/)
- Newsletter, Slack, Facebook & Linkedin Groups: <https://join.sika.io>

_Do you like the course? Write me a recommendation on Twitter (with handle `@ondrejsika`) and LinkedIn (add me [/in/ondrejsika](https://www.linkedin.com/in/ondrejsika/) and I'll send you Request for the recommendation). __Thanks__._

Wanna go for a beer or do some work together? Just [book me](https://book-me.sika.io) :)
