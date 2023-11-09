# Vagrantfile: Ansible Playground

A simple test playground to use Vagrant Ansible Provisioner.

## Spin-up

1. Install Ansible on Vagrant host.

2. (Optional) Edit variable `VM_NAME` in `Vagrantfile` to a proper VM name.

3. Edit Ansible Playbook file `playbook.yml`.

4. Spin up Vagrant guest:

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

- run Ansible Playbook by `ansible` on Vagrant host:

    ```bash
    ansible all -i host.yml -m ping
    ```

- Update hosts managed by `vagrant-hostmanager`:

    ```bash
    vagrant hostmanager
    ```
