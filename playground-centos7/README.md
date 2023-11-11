# Vagrantfile: CentOS 7 Playground

A simple test playground for CentOS 7.

- Hypervisor: Parallels Desktop
- Guest OS: CentOS 7 ([bento/centos-7](https://app.vagrantup.com/bento/boxes/centos-7))

## Spin-up

1. (Optional) Un-comment `vagrant-hostmanager` settings in `Vagrantfile`.

    ```ruby
    config.hostmanager.manage_host = true
    ```


2. (Optional) Setup `vagrant-hostmanager` [Passwordless sudo](https://github.com/devopsgroup-io/vagrant-hostmanager#passwordless-sudo).

3. Spin up Vagrant guest:

    ```bash
    vagrant up
    ```
