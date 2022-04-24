# -*- mode: ruby -*-
# vi: set ft=ruby :

LINUX_BASE_BOX = "ubuntu/focal64"

SINGLE_BOX_IP_ADDRESS = "10.100.0.100"

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
            ansible.playbook = "./playbooks/single.yml"
        end

	end


    # # Provision server node.
    # config.vm.define "server", primary: true do |server|
    #     server.vm.box = BASE_BOX
    #     server.vm.hostname = "server"
    #     server.vm.network "private_network", ip: "10.100.0.100"
    #     server.vm.network "forwarded_port", guest: 8500, host: 8500     #  Consul HTTP API
    #     server.vm.network "forwarded_port", guest: 4646, host: 4646     #  Nomad HTTP API

    #     server = configureVirtualBox(server, 2, 2048)

    #     # Provision consul and nomad as servers.
    #     config.vm.provision "ansible" do |ansible|
    #         ansible.playbook = "./playbooks/server.yml"
    #     end
    
    # end

    # # Client VMs
    # 1.upto(2) do |i|
    #     config.vm.define "client#{i}" do |client|
    #         client.vm.box = BASE_BOX
    #         client.vm.hostname = "client#{i}"
    #         client.vm.network "private_network", ip: "10.100.0.%d" % [200 + i]


    #         client = configureVirtualBox(client, 2, 2048)

    #         client = configureProvisioners(client)
    #     end
    # end

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