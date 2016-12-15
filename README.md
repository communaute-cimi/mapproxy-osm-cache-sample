# Exemple de proxy "données spatiales" avec mapproxy

Exemple de proxy cache de tuiles OSM

```sh
vagrant up
vagrant ssh # aller dans la VM
```

## Proxy

Dans la VM pour démarrer le proxy

```sh
source mapproxy/bin/activate
cd mymapproxy
sudo mapproxy-util serve-develop --bind 0.0.0.0:8080 mapproxy-osm.yaml
[info]  * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
[info]  * Restarting with reloader
```

## Moissonnage (seeding)

Le moissonnage permet de récupérer et mettre en cache des tuiles en fonction de différents critères comme la couverture, ou niveau d'échelle

```sh
source mapproxy/bin/activate
sudo mapproxy-seed -f mapproxy-osm.yaml -c 4 seed-osm.yaml
```

## La démo 

La démo est accessible : http://localhost:8082/

## Installation mapproxy
```sh
aptitude -y install python-pip
aptitude -y install python-virtualenv
aptitude -y install python-imaging python-yaml libproj0
aptitude -y install libgeos-dev python-lxml libgdal-dev python-shapely
pip install Pillow
pip install MapProxy
```
## Création d'une environnement virtuel
```sh
virtualenv --system-site-packages mapproxy
source mapproxy/bin/activate
```

## Création d'une environnement virtuel

## Intégration apache

### Installer apache2
```sh
sudo apt-get install apache2
```

### Ajout du mod_wsgi
```sh
apt-get install libapache2-mod-wsgi
```

### Création d'un fichier de configuration mapproxy-wsgi

Avec une commande "util" de mapproxy créer le fichier mapproxy-config.wsgi (fichier python)
mapproxy-util create -t wsgi-app -f mapproxy.yaml /opt/soclesig-X.X.X-venv-mapproxy/config.py
Modfier les chemins dans le fichier

### Fichier de configuration mapproxy
Le fichier de configuration permettra à apache de faire le lien entre la requête http et l'accès à mapproxy

Créer un fichier mapproxy.conf dans /etc/apache2/conf.available/
Contenant
```sh
# If not loaded elsewhere
LoadModule wsgi_module modules/mod_wsgi.so

WSGIScriptAlias /mapproxy $conf/mapproxy-config.wsgi

WSGIPythonPath /home/vagrant/mapproxy/lib/python2.7/site-packages

<Directory /home/vagrant/mapproxy/lib/python2.7/site-packages/mapproxy/>
      Order deny,allow
      Require all granted
</Directory>
```
Modifier les chemins le cas échéant...

### Permettre la sortie du www
Modifier apache2.conf
```sh
<Directory />
        Options FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
```

##liens
https://httpd.apache.org/docs/2.4/fr/mod/core.html
https://mapproxy.org/docs/latest/
https://doc.ubuntu-fr.org/tutoriel/virtualhosts_avec_apache2#configuration_des_hotes_virtuels

