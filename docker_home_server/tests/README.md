# Testing the Ansible Role

This directory contains files for testing the `docker_home_server` Ansible role using a Rocky Linux Docker container.

## Prerequisites

- Docker and Docker Compose installed
- Ansible installed on your host machine

## Setup and Run Tests

### 1. Start the test container

```bash
cd tests
docker-compose up -d
```

### 2. Install Ansible collections (if needed)

```bash
ansible-galaxy collection install ansible.posix community.general
```

### 3. Run the Ansible playbook against the container

```bash
# Test the playbook
ANSIBLE_ROLES_PATH=../.. ansible-playbook -i inventory test.yml
```

### 4. Access the container for manual testing

```bash
docker exec -it ansible-test-rocky bash
```

### 5. Clean up

```bash
docker-compose down
```

## Alternative: Run Ansible inside the container

If you prefer to run Ansible from within the container:

```bash
# Install Ansible in the container
docker exec -it ansible-test-rocky bash -c "dnf install -y epel-release && dnf install -y ansible"

# Run the playbook from inside
docker exec -it ansible-test-rocky bash -c "cd /ansible-role/docker_home_server && ansible-playbook tests/test.yml"
```

## Troubleshooting

- If you get permission errors, ensure the container is running with `--privileged` flag
- For systemd-related issues, verify that `/sys/fs/cgroup` is mounted correctly
- Check container logs: `docker logs ansible-test-rocky`
