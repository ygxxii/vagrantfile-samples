## Vagrantfile: Ansible Playground

A simple test playground to use Vagrant Ansible Provisioner.

## Usage

1. Install Ansible on Vagrant host.

2. (Optional) Edit variable `VM_NAME` in `Vagrantfile` to a proper VM name.

3. Edit Ansible Playbook file `playbook.yml`.

4. Spin up Vagrant guest:

    ```bash
    vagrant up
    ```

5. Rerun Ansible Playbook when guest is running:

    ```bash
    vagrant provision --provision-with ansible
    ```
