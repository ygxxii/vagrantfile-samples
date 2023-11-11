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

## Usage

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
# ssh vagrant@playground-centos7 \
#     -i .vagrant/machines/playground-centos7/parallels/private_key
```

### Change VM hostname

1. Edit variable `HOST_NAME` in `Vagrantfile` to a proper VM name.

2. Update hosts managed by `vagrant-hostmanager`:

    ```bash
    vagrant hostmanager
    ```
