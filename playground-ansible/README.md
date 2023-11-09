# Vagrantfile: Ansible Playground

A simple test playground to use Vagrant Ansible Provisioner.

- Hypervisor: Parallels Desktop
- Guest OS: RockyLinux 8

## Spin-up

1. Install Ansible on Vagrant host.

2. Setup `vagrant-hostmanager` [Passwordless sudo](https://github.com/devopsgroup-io/vagrant-hostmanager#passwordless-sudo).

3. Spin up Vagrant guest:

    ```bash
    vagrant up
    ```

## Usage

### Run Ansible Playbook

Ansible Playbook is run when VM first boot. To rerun Ansible Playbook:

1. Edit Ansible Playbook file `playbook.yml`.

2. Rerun Ansible Playbook:

    - Method 1: rerun Ansible Playbook when guest is running:

        ```bash
        vagrant provision --provision-with ansible
        ```

    - Method 2: rerun Ansible Playbook by `ansible`:

        ```bash
        ansible all -i host.yml -m ping
        ```

### SSH login

SSH login to Vagrant guest:

```bash
vagrant ssh
```

or:

```bash
ssh vagrant@<vagrant-guest-hostname> \
    -i .vagrant/machines/<vagrant-guest-hostname>/parallels/private_key

# e.g.
# ssh vagrant@ansible-playground-rocky8 \
#     -i .vagrant/machines/ansible-playground-rocky8/parallels/private_key
```

### Change VM hostname

1. Edit variable `VM_NAME` in `Vagrantfile` to a proper VM name.

2. Edit hostname in Ansible Inventory `host.yml`.

3. Update hosts managed by `vagrant-hostmanager`:

    ```bash
    vagrant hostmanager
    ```
