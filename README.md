## Getting started 

1. Get the sources:
```
git clone https://github.com/Ahaz1701/DevOps_Project.git && cd DevOps_Project 
``` 
2.
3. Launch Redis database with Docker:
```
docker-compose up -d redis
```

4. Start the application:
```
npm start
```

5. Access the application on your web browser on http://localhost:3000


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


