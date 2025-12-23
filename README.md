# ansible-role-docker-home-server
This role sets up a rocky linux machine up for a home-server based on a docker compose environment.

## Features
- Docker ready to be used
- Docker compose environment running node exporter
- SSH key authentication setup
- SSH hardening (disable password authentication)

## Quick Start for Fresh Rocky Linux
### Step 0: Prep the box and ansible host
box:
- Make sure you have a static IP (you can use nmtui for quick access or use the cli tool)
- In case of running on an SD-card (e.g. on a rasberry pi), stretch your filesystem to fit it (sudo rootfs-expand)

host: 
- Ansible requires `sshpass` to use username/password (sudo apt install sshpass)
- `sshpass` requires the machines fingerprint to be in the known hosts, connect with ssh manually once to fetch it

### Step 1: Generate SSH Key (if you don't have one)
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub  # Copy this public key
```

### Step 2: Create inventory file
```bash
cp inventory.example.yml inventory.yml
# Edit inventory with your server IP and credentials
```

### Step 3: First Run (installs SSH key, keeps password auth)
```bash
cp site.example.yml site.yml
# Edit `site.yml` and add your SSH public key, then run:
ansible-playbook -i inventory.yml site.yml --ask-pass --ask-become-pass
```

SSH will automatically try your key first, then fall back to password. After this run, your SSH key is installed and password is disabled.

## How It Works

The inventory is configured to try both SSH key and password:
```ini
ansible_ssh_common_args='-o PreferredAuthentications=publickey,password'
```

SSH tries key first, then password. This means:
- **First run**: No key exists on server → uses password → installs key
- **Second run**: Key exists → uses key automatically
- **After hardening**: Only key works, password disabled

## Configuration Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_public_key` | `""` | Your SSH public key (required if configure_ssh is true) |
| `ssh_user` | `{{ ansible_user }}` | User to configure SSH for |
| `docker_storage_driver` | `""` | Set to 'vfs' for WSL, leave empty for production (used for testing with docker) |

## How to use role via requirements.yml
Add the following to your requirements.yml:
```yaml
  - name: docker_home_server
    src: https://github.com/Vorstenbosch/ansible-role-docker-home-server.git
    scm: git
    version: main  # Or a specific tag
```

and run `ansible-galaxy install -r requirements.yml`