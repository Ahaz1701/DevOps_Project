# ING4-DevOps-Project

## Getting started 

1. Get the sources:
```
git clone https://github.com/Ahaz1701/DevOps_Project.git && cd DevOps_Project 
```

2. Launch `Redis` database with Docker:
```
docker-compose up -d redis
```

3. Start the test:
```
npm test
```

4. Start the application:
```
npm start
```

5. Access the application on your web browser on http://localhost:3000


### 1. Create a web application

Nous avons utilisé l'application web mise à disposition, tout en l'**enrichissant** et en la **complétant**. C'est une application `nodejs` qui stocke les données sur une base de données `Redis`.

**Elle implémente**:

- une API utilisateur CRUD simple
- un stockage des données dans une base de données Redis
- des tests: unitaires, API, configuration, connexion

Nous avons implémenté des **tests supplémentaires**, en voici quelques exemples:

![image](https://user-images.githubusercontent.com/61588921/147010935-e415e875-ba84-4cb7-9272-b543f5c78b91.png)
![image](https://user-images.githubusercontent.com/61588921/147011018-c7d0dc99-e200-4aa3-b69b-408945a82593.png)

### 2. Apply CI/CD pipeline

#### 1. Pour la partie **intégration continue**, nous avons utilisé `GitHub Actions`.

Nous avons tout d'abord créé un dossier `.github/workflows` à la racine de notre projet, pour accueillir les configurations de notre workflow.

Nous avons décidé d'implémenter l'**intégration continue** seulement pour la branche `main` de notre projet. Il s'agit de la branche principale, et par convention, elle reçoit seulement les fonctionnalités prête pour la production.

![image](https://user-images.githubusercontent.com/61588921/147011872-06dc2c5d-a154-4017-b73a-831f84ce7890.png)

Ensuite, nous avons choisi un serveur `Ubuntu Linux` pour exécuter nos workflows lorsqu'ils sont déclenchés, et nous avons précisé le **répertoire de travail** `userapi`.

![image](https://user-images.githubusercontent.com/61588921/147012106-e1214742-e01d-4bec-aca8-7b62413aa4ee.png)

Nous avons également précisé au serveur d'utiliser `nodejs`, ainsi que d'exécuter le service `Redis` (issu d'une image Docker), pour pouvoir lancer nos **tests**.

![image](https://user-images.githubusercontent.com/61588921/147012589-f1d72d61-7017-4872-b55e-1e62a682ad57.png)

Une fois `Redis` et `nodejs` d'installés et configurés, le serveur linux **installera les packages** nécessaires à l'application, et **lancera les tests** que nous avons implémenté.

![image](https://user-images.githubusercontent.com/61588921/147013250-ceb48bf3-980f-41ad-9bff-c7783db18c7b.png)

#### 2. Pour la partie **déploiement continu**, nous avons utilisé `Heroku`.

Tout d'abord, nous avons créé un compte et déployé notre application en ligne: https://ahaz-taumi-devops-project.herokuapp.com/

![image](https://user-images.githubusercontent.com/61588921/147013591-b82cb63c-fc61-4102-8c66-4e4ff78601f6.png)

Ensuite, nous avons ajouté les configurations nécessaires dans notre fichier `run.yaml`, pour permettre le **déploiement continue** en plus de l'**intégration continue**. Pour **lancer le déploiement**, nous avons indiqué au serveur Ubuntun linux qu'il était nécessaire que les **tests implémentés passent avec succès**.

![image](https://user-images.githubusercontent.com/61588921/147014393-aef3d6cd-5de7-4c0f-9b8d-8e6d943ef8b8.png)

Une fois ces tests complétés, nous configurons `Heroku` pour le **déploiement continue**. Il est nécessaire de renseigner l'**adresse mail** du compte `Heroku`, le **nom unique** de son **projet**, de fournir sa **clé API**, et de renseigner le **répertoire de travail**.

![image](https://user-images.githubusercontent.com/61588921/147014586-e651e464-5943-4486-90e2-e27bea9b107d.png)

La **clé API** se trouve dans les **settings** de son compte sur le site d'`Heroku`, et il est ensuite nécessaire de créer un `Action secret` sur `GitHub`, pour la stocker en toute **sécurité**.

![image](https://user-images.githubusercontent.com/61588921/147014767-ff33252c-85b7-477e-a10f-5901cd0c1dc3.png)

#### 3. Maitenant, à chaque fois qu'une action du type pull request se déclenche sur la branche `main`, nous pouvons observer dans l'onglet `Actions` de `GitHub`, si l'**intégration continue** et le **déploiement continue** de notre projet se sont bien déroulé.

![image](https://user-images.githubusercontent.com/61588921/147015170-1fc2165b-e685-4d0a-b1ea-0f7997c8774e.png)

![image](https://user-images.githubusercontent.com/61588921/147015223-d5909465-255b-4420-8058-1eeb723632b4.png)

#### 4. Nous avons également réalisé un bonus.





### 3. Configure and provision a virtual environment and run your application using the IaC approach

#### 1. Dans un premier temps, nous avons créé un dossier `iac` ainsi qu'un fichier `Vagrantfile`, afin d'y décrire le **type de machine souhaité** pour **exécuter notre application**.

Nous avons indiqué vouloir un `serveur Ubuntu linux`, et plus précisemment la machine `ubuntu/trusty64` (la plus populaire).

![image](https://user-images.githubusercontent.com/61588921/147016348-f07e826a-15e5-4100-a535-3056b4adb7ff.png)

Ensuite, nous lui avons défini une **adresse IP privée**, un **nom**, une quantité de **RAM** et un nombre de **CPUs**.

![image](https://user-images.githubusercontent.com/61588921/147016583-00843015-31d7-4b6d-b13f-f02ecc4b613b.png)

#### 2. Dans un second temps, nous avons provisionné notre serveur linux avec `Ansible`.

![image](https://user-images.githubusercontent.com/61588921/147017102-2472ecd9-25f5-4537-a651-7ee36fdd8c56.png)

Pour ce faire, nous souhaitons **installer** et **configurer** :
- un langage de programmation
- une base de données (`Redis` dans notre cas)
- notre application (via un `sync folder`)
- un bilan de santé de notre application

Nous avons créé un dossier `playbooks` ainsi qu'un fichier `run.yml`. Dans celui-ci, nous avons indiqué toutes les **tâches à suivre et à exécuter** pour provisionner notre **serveur ubuntu** comme décrit précédemment.

Tout d'abord, nous voulons **installer** la dernière version de `nodejs` et de `npm` pour notre application. Pour ce faire, nous **téléchargeons et exécutons** le **manager de versions** `nodejs`, `n`.

![image](https://user-images.githubusercontent.com/61588921/147017716-833756ca-47a5-4b04-9b43-bff8079b41da.png)

Ensuite, nous voulons **installer et configurer** notre base de données `Redis`.

![image](https://user-images.githubusercontent.com/61588921/147017871-1556a4a5-62b1-4929-ab9d-444c28f1536b.png)

Nous **installons** également les packages nécessaires au bon fonctionnement de notre application, **application** qui est **synchronisée à notre serveur linux** via un `sync folder`.

![image](https://user-images.githubusercontent.com/61588921/147018136-98681da8-08ea-4104-8de2-f5fce5c13d3d.png)

![image](https://user-images.githubusercontent.com/61588921/147018174-9b6b7685-7e3a-4b19-a8b0-223ea8bf0493.png)

Enfin, nous souhaitons lancer notre base de données `Redis`,

![image](https://user-images.githubusercontent.com/61588921/147018273-9bd5304d-0330-4755-b774-3112005a9348.png)

effectuer les **tests de notre application**,

![image](https://user-images.githubusercontent.com/61588921/147018358-4ac3fe48-7ee5-4576-98f5-5dfc4bcdfe8f.png)

et la **lancer**.

![image](https://user-images.githubusercontent.com/61588921/147018391-4b79136b-860c-48a2-b39e-f980a56368eb.png)

Nous avons défini `async` et `poll` pour exécuter plusieurs tâches en parallèles, au sein de notre **playbook**.

#### 3. Nous avons également réalisé un bonus.

Nous avons **implémenté 2 tests** dans le fichier `webapp.rb` présent dans le dossier `test`:
- nous vérifions que `Redis` est bien lancé sur le port **6379**
- nous vérifions que notre application est bien lancée sur le port **3000**

![image](https://user-images.githubusercontent.com/61588921/147019590-9f982ab3-8f16-486f-b8ac-fee11585a6df.png)

Pour **exécuter ces tests**, nous avons dû télécharger un plugin de vagrant:
```
vagrant plugin install vagrant-serverspec
```

et ajouter ceci à notre `Vagrantfile`:

![image](https://user-images.githubusercontent.com/61588921/147019729-cadc1b57-3c30-48b3-b23f-17a644f354a0.png)

#### 4. Enfin, nous créons notre serveur linux via la commande ```vagrant up```

![image](https://user-images.githubusercontent.com/61588921/147019973-c32930d8-8a7a-4cb6-a8ca-056b29179f5d.png)

Nous checkons que notre **VM** est **lancée**,

![image](https://user-images.githubusercontent.com/61588921/147020061-24e9895c-62e5-4986-af1b-ac79a1cd78f4.png)

et nous l'**approvisionnons** avec nos dernières modifications. Toutes les **tâches** sont exécutées :

![image](https://user-images.githubusercontent.com/61588921/147020487-4c141d81-cc3f-4fd6-b52b-fb595cf25728.png)

et nos **tests** sont passés avec **succès**.

![image](https://user-images.githubusercontent.com/61588921/147020575-88706f65-4ddf-4637-8fdf-00ed4cc21213.png)

Ainsi, nous pouvons accéder à notre **application web** via l'**adresse IP privée** et le **port** renseignés dans le fichier `Vagrantfile`.

![image](https://user-images.githubusercontent.com/61588921/147020777-8f10b929-ba2c-40b8-b967-316a5da4fe24.png)


### 4. Build Docker image of your application 

#### 1. Create a Docker image of our application:

+ Nous devons d'abord créer un fichier `Dockerfile` qui va servir à conteneuriser l'application. Pour créer le fichier, on exécute la commande suivante dans le CLI:   

  ```
  touch Dockerfile
  ```  

Ensuite les dépendances applicatives sont installées dans le conteneur. 

Tout d'abord, le conteneur se base sur l'image officielle de `node`.
```
FROM node:14.17.5-alpine
```
On copie tous les fichiers sources de l'application qui ne sont pas inclus dans le fichier `.dockerignore`.
```
COPY .. 
```
On installe les dépendances de l'application. 
```
RUN npm install
```

(Facultatif) On expose notre conteneur sur le port 80 par défaut.
```
EXPOSE 3000
```

Enfin, on lance l'application du conteneur. 
```
CMD ["npm", "start"]
```
#### 2. Build the Docker image of our application: 

Pour build l'image Docker de notre application, il faut exécuter la commande suivante: 
```
docker build . -t <IMAGE_NAME>
```

#### 3. Push the image to Docker Hub:

Pour push l'image sur Docker Hub, il faut d'abord se connecter à Docker Hub:
```
docker login
```

Ensuite, il faut tagger l'image avec le bon nom: 
```
docker image tag <IMAGE_NAME> <ACCOUNT_ID>/<IMAGE_NAME:latest>
```

Et enfin, on push l'image sur Docker Hub:

```
docker push <ACCOUNT_ID>/<IMAGE_NAME>
```
![Capture d’écran 2021-12-21 à 14 16 45](https://user-images.githubusercontent.com/57870369/146936344-71d60ee2-ee66-4295-af92-7890aef67e4b.png)


### 5. Make container orchestration using Docker Compose

#### 1. Création du service Redis

Nous utilisons le service `Redis` comme base de données pour notre application. Il faut donc configurer un conteneur Redis. 
Il faut tout d'abord créer un fichier `docker-compose.yaml` dans lequel nous allons définir Redis:
```
touch docker-compose.yaml
```

Dans la partie `services` du fichier, on définit Redis avec les lignes de code suivantes:
```
redis:
    hostname: "redis"
    image: redis:alpine
    container_name: redis_container
    ports:
      - "6379:6379"
    restart: always
    networks:
      - back-tier
```

Et dans la partie `app` du fichier, on implémente les lignes de code suivantes:
```
hostname: "app"
    image: projet_devops:latest
    container_name: projet_devops_container
    environment:
      REDIS_HOST: redis
    ports:
      - "3000:3000"
    restart: on-failure
    build: .
    depends_on:
      - redis
    networks:
      - back-tier
``` 
#### 2. Lancement de l'application

Pour lancer l'application, on utilise la commande suivante: 
```
docker-compose up
```

### 6. Make Docker orchestration using Kubernetes

Start Minikube: 
```
minikube start 
```

We have used `Kompose` to convert our `docker-compose` file into Kubernetes resources using the following command: 
```
kompose convert 
kubectl apply -f .
```

Using the following command, we have our Kubernetes deployment: 
```
kubectl apply -f k8s/
```



### 8. Implement Monitoring to your containerized application

#### 1. Install Prometheus and Grafana:

On récupère les fichiers sources sur leurs documentations officielles respectives et on les range dans un dossier `grafana` et `prometheus`.    
+ Pour Grafana: https://grafana.com/docs/grafana/latest/installation/kubernetes/
+ Pour Prometheus: https://github.com/kubernetes-sigs/prometheus-adapter

Pour déployer ces services, on utilise les commandes suivantes: 
```
kubectl apply -f grafana
kubectl apply -f prometheus
``` 

#### 2. Set up monitoring with Prometheus:

Pour setup le monitoring avec `Prometheus`, il faut que nous installions les `metrics` contenues dans le GitHub ci-dessous pour que `Prometheus` aille chercher l'information sur le cluster Kubernetes. 
```
https://github.com/kubernetes/kube-state-metrics.git 
``` 
Il faut ensuite déployer les `metrics` avec la commande: 
```
kubectl apply -f setup
kubectl apply -f manifests
``` 
#### 3. Set up monitoring with Grafana: 

Au moment de la création d'un **dashboard**, on le link avec le serveur `Prometheus` afin de récupérer les informations et de les afficher sous forme de graphiques. 

![Capture d’écran 2021-12-20 à 17 55 51](https://user-images.githubusercontent.com/57870369/146803741-ac7eb871-48bb-4e94-b0fb-a546078d3995.png)


