.PHONY: up-single up-cluster down
.DEFAULT_GOAL := up-single

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

up-single: ## Use this to start a single node VM.
	@echo "==> Starting to setup a single node VM..."
	@vagrant up --provision
	@echo "==> Finished setting up the VM. You can visit http://localhost:4646 for Nomad UI and http://localhost:8500/ for Consul UI."

up-cluster: ## Use this to start a 3 node cluster.
	@echo "==> Starting a 3 node cluster..."
	@vagrant up /localhashi-0/ --provision --parallel
	@echo "==> Finished setting up the VM. You can visit http://10.100.0.11:4646 for Nomad UI and http://10.100.0.11:8500/ for Consul UI."

down: ## Destroys all VMs listed in the Vagrantfile.
	@echo "==> Destroying all VMs"
	@vagrant destroy -f

reboot: ## Reboots existing VMs
	@echo "==> Rebooting all running VMs"
	@vagrant reload

status: ## Shows status of all VMs listed in the Vagrantfile.
	@vagrant status

configure-acl-single: ## Sets up ACL for Nomad and Consul for a single node.
	ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i ./.vagrant/provisioners/ansible/inventory playbooks/single.yml --extra-vars "consul_enable_acl=true nomad_enable_acl=true" --tags="configure_acl"

configure-acl-cluster: ## Sets up ACL for Nomad and Consul for a cluster.
	ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i ./.vagrant/provisioners/ansible/inventory playbooks/cluster.yml --extra-vars "consul_enable_acl=true nomad_enable_acl=true" --tags="configure_acl"
