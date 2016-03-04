# -*- mode: ruby -*-
# vi: set ft=ruby :

# This box is used to test swift on linux locally.

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 80, host: 8081
  config.ssh.pty = true
  config.vm.synced_folder ".", "/srv/nsdateformatter"
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y git clang libicu-dev nginx

    if [[ ! -f swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu14.04.tar.gz ]]
    then
      wget https://swift.org/builds/development/ubuntu1404/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu14.04.tar.gz
      tar xzvf swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu14.04.tar.gz
    fi

    echo "export PATH=/home/vagrant/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu14.04/usr/bin:$PATH" >> ~/.profile
    source ~/.profile

    swift --version
    sudo chown vagrant:vagrant /srv/nsdateformatter
  SHELL

  config.vm.provision :file, source: 'nsdateformatter.nginx.conf', destination: 'nsdateformatter.nginx.conf'
  config.vm.provision :shell, inline: <<-SHELL
    sudo rm /etc/nginx/sites-enabled/default
    sudo mv nsdateformatter.nginx.conf /etc/nginx/sites-available/nsdateformatter
    sudo chmod 644 /etc/nginx/sites-available/nsdateformatter
    ln -s /etc/nginx/sites-available/nsdateformatter /etc/nginx/sites-enabled/nsdateformatter
    /etc/init.d/nginx reload
  SHELL
end
