docker-compose down
docker compose up -d
ANSIBLE_ROLES_PATH=../.. ansible-playbook -i inventory -vvvv test.yml