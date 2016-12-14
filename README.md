# Proxy/cache OSM avec mapproxy

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

##Moissonnage (seeding)

```sh
source mapproxy/bin/activate
sudo mapproxy-seed -f mapproxy-osm.yaml -c 4 seed-osm.yaml
```

## La démo 

Dans le système hôte (le proxy doit être démarré) : http://localhost:8080/demo/

## Intégration apache
### Installer apache2
### Ajout du mod_wsgi
### Création d'un fichier de configuration
Avec une commande "utils" créer le fichier config.py
mapproxy-util create -t wsgi-app -f mapproxy.yaml /opt/soclesig-X.X.X-venv-mapproxy/config.py
Modfier les chemins dans le fichier
### Fichier de configuration mapproxy
Créer un fichier mapproxy.conf dans /etc/apache2/conf.available/
Contenant
```sh
# If not loaded elsewhere
LoadModule wsgi_module modules/mod_wsgi.so

WSGIScriptAlias /mapproxy /home/vagrant/config.py

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


Ajouter un serveur web en frontal, NGINX ?

