# -*- mode: ruby -*-
# vi: set ft=ruby :

LINUX_BASE_BOX = "ubuntu/focal64"

SINGLE_BOX_IP_ADDRESS = "10.100.0.100"
CLUSTER_IP_ADDRESS = ["10.100.0.11","10.100.0.12","10.100.0.13"]

Vagrant.require_version ">= 2.2.19"

# Refer to README.md#architecture for the cluster overview.
Vagrant.configure("2") do |config|

	# Single node VM which comes with consul and nomad running in client+server modes.
	config.vm.define "single", autostart: true, primary: true do |vmCfg|
		vmCfg.vm.box = LINUX_BASE_BOX
		vmCfg.vm.hostname = "localhashi"
		vmCfg = configureProviders vmCfg,
			cpus: suggestedCPUCores()

        # Expose Nomad and Consul ports for ease.
		vmCfg.vm.network :forwarded_port, guest: 4646, host: 4646, host_ip: "127.0.0.1", guest_ip: SINGLE_BOX_IP_ADDRESS
		vmCfg.vm.network :forwarded_port, guest: 8500, host: 8500, host_ip: "127.0.0.1", guest_ip: SINGLE_BOX_IP_ADDRESS
        vmCfg.vm.network "private_network", ip: SINGLE_BOX_IP_ADDRESS

        # Provision consul and nomad as servers.
        vmCfg.vm.provision "ansible" do |ansible|
            ansible.playbook = "./playbooks/playbook.yml"
            ansible.extra_vars = {
                cluster_members: [SINGLE_BOX_IP_ADDRESS],
                consul_bootstrap_expect: 1,
                nomad_bootstrap_expect: 1
            }
        end

	end

	# Multi node cluster
	1.upto(3) do |n|
		serverName = "localhashi-%02d" % [n]
		serverIP = "10.100.0.%d" % [10 + n]

		config.vm.define serverName, autostart: false, primary: false do |vmCfg|
			vmCfg.vm.box = LINUX_BASE_BOX
			vmCfg.vm.hostname = serverName
            vmCfg = configureProviders vmCfg,
			cpus: suggestedCPUCores()

			vmCfg.vm.provider "virtualbox" do |_|
				vmCfg.vm.network :private_network, ip: serverIP
			end

			# Provision consul and nomad as servers.
			vmCfg.vm.provision "ansible" do |ansible|
				ansible.playbook = "./playbooks/playbook.yml"
				ansible.extra_vars = {
					cluster_members: CLUSTER_IP_ADDRESS,
					consul_bootstrap_expect: 3,
					nomad_bootstrap_expect: 3
				}
			end
		end
	end

end

def configureProviders(vmCfg, cpus: "2", memory: "2048")
	vmCfg.vm.provider "virtualbox" do |v|
		v.customize ["modifyvm", :id, "--cableconnected1", "on", "--audio", "none"]
		v.memory = memory
		v.cpus = cpus
	end

	return vmCfg
end

def configureProvisioners(config)
    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "./playbooks/playbook.yml"
    end

    return config
end

def suggestedCPUCores()
	case RbConfig::CONFIG['host_os']
	when /darwin/
		Integer(`sysctl -n hw.ncpu`) / 2
	when /linux/
		Integer(`grep -c ^processor /proc/cpuinfo`) / 2
	else
		2
	end
end
