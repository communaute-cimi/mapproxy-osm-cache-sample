apt-get update
aptitude -y install python-pip
aptitude -y install python-virtualenv
aptitude -y install python-imaging python-yaml libproj0
aptitude -y install libgeos-dev python-lxml libgdal-dev python-shapely
pip install Pillow
pip install MapProxy
virtualenv --system-site-packages mapproxy
source mapproxy/bin/activate
mapproxy-util create -t base-config mymapproxy
cp -f /vagrant/vagrant-provision/conf/mapproxy-osm.yaml ./mymapproxy
cp -f /vagrant/vagrant-provision/conf/seed-osm.yaml ./mymapproxy

