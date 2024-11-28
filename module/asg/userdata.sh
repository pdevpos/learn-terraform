pip3.11 install ansible hvac &>>/opt/ansible.log
ansible-pull -i localhost, -U https://github.com/pdevpos/learn-ansible get-secrets.yml -e env=${env} -e role_name=${component}  -e vault_token=${vault_token} &>>/opt/ansible.log
ansible-pull -i localhost, -U https://github.com/pdevpos/learn-ansible expense.yml -e env=${env} -e role_name=${component} -e @~/secrets.json -e only_deployment=false  &>>/opt/ansible.log