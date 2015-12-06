# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "rafacas/debian78-i386-plain"
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.provision :shell, :path => "vagrant-provision/bootstrap.sh"
end
