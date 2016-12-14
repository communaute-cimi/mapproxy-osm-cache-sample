# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.network :forwarded_port, guest: 8080, host: 8081
  config.vm.network :forwarded_port, guest: 80, host: 8082
  config.vm.provision :shell, :path => "vagrant-provision/bootstrap.sh"
  config.vm.synced_folder "./vagrant-provision/", "/vagrant_sync/"
  config.vm.synced_folder "./html/", "/vagrant_www/"
end
