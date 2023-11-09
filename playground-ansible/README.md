# Vagrantfile: Ansible Playground

A simple test playground to use Vagrant Ansible Provisioner.

- Hypervisor: Parallels Desktop
- Guest OS: RockyLinux 8

## Spin-up

1. Install Ansible on Vagrant host.

2. Edit Ansible Playbook file `playbook.yml`.

3. Spin up Vagrant guest:

    ```bash
    vagrant up
    ```

## Usage

- SSH login to Vagrant guest:

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

- Rerun Ansible Playbook when guest is running:

    ```bash
    vagrant provision --provision-with ansible
    ```

- Run Ansible Playbook by `ansible` on Vagrant host:

    ```bash
    ansible all -i host.yml -m ping
    ```

## Change VM hostname

1. Edit variable `VM_NAME` in `Vagrantfile` to a proper VM name.

2. Edit hostname in Ansible Inventory `host.yml`.

3. Update hosts managed by `vagrant-hostmanager`:

    ```bash
    vagrant hostmanager
    ```
