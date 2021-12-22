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

We used the web application provided, while **enriching** and **complementing** it. It is a `nodejs` application that stores data on a `Redis` database.

**It implements**:

- a simple CRUD user API
- data storage in a Redis database
- tests: unit, API, configuration, connection

We have implemented additional **tests**, here are some examples:

![image](https://user-images.githubusercontent.com/61588921/147010935-e415e875-ba84-4cb7-9272-b543f5c78b91.png)
![image](https://user-images.githubusercontent.com/61588921/147011018-c7d0dc99-e200-4aa3-b69b-408945a82593.png)

When we run `npm test` in the `userapi` folder, we can see that all our tests pass with **success**.

![image](https://user-images.githubusercontent.com/61588921/147142038-23b7f244-fd5a-4cd3-9427-40dce8975c82.png)


### 2. Apply CI/CD pipeline

#### 1. For the **continuous integration** part, we used `GitHub Actions`.

We first created a `.github/workflows` folder at the root of our project, to host our workflow configurations.

We decided to implement **continuous integration** only for the `main` branch of our project. This is the main branch, and by convention, it only receives production-ready functionality.

![image](https://user-images.githubusercontent.com/61588921/147011872-06dc2c5d-a154-4017-b73a-831f84ce7890.png)

Next, we chose a `Ubuntu Linux` server to run our workflows when they are triggered, and we specified the `userapi` **working directory**.

![image](https://user-images.githubusercontent.com/61588921/147012106-e1214742-e01d-4bec-aca8-7b62413aa4ee.png)

We also specified the server to use `nodejs`, as well as to run the `Redis` service (from a Docker image), so we could run our **tests**.

![image](https://user-images.githubusercontent.com/61588921/147012589-f1d72d61-7017-4872-b55e-1e62a682ad57.png)

Once `Redis` and `nodejs` are installed and configured, the linux server will **install the packages** needed for the application, and **start the tests** we have implemented.

![image](https://user-images.githubusercontent.com/61588921/147013250-ceb48bf3-980f-41ad-9bff-c7783db18c7b.png)

#### 2. For the **continuous deployment** part, we used `Heroku`.

First, we created an account and deployed our application online: https://ahaz-taumi-devops-project.herokuapp.com/

![image](https://user-images.githubusercontent.com/61588921/147013591-b82cb63c-fc61-4102-8c66-4e4ff78601f6.png)

Then, we added the necessary configurations to our `run.yaml` file, to enable **continuous deployment** in addition to **continuous integration**. To **start the deployment**, we told the Ubuntun linux server that it was necessary for the **implemented tests to pass**.

![image](https://user-images.githubusercontent.com/61588921/147014393-aef3d6cd-5de7-4c0f-9b8d-8e6d943ef8b8.png)

Once these tests are completed, we configure `Heroku` for **continuous deployment**. It is necessary to fill in the **email address** of the `Heroku` account, the **unique name** of its **project**, to provide its **API key**, and to fill in the **working directory**.

![image](https://user-images.githubusercontent.com/61588921/147014586-e651e464-5943-4486-90e2-e27bea9b107d.png)

The **API key** can be found in the **settings** of his account on the `Heroku` site, and it is then necessary to create a `Secret Action` on `GitHub`, to store it safely**.

![image](https://user-images.githubusercontent.com/61588921/147014767-ff33252c-85b7-477e-a10f-5901cd0c1dc3.png)

#### 3. Now, each time a pull request action is triggered on the `main` branch, we can observe in the `Actions` tab of `GitHub`, if the **continuous integration** and the **continuous deployment** of our project went well.


![image](https://user-images.githubusercontent.com/61588921/147015170-1fc2165b-e685-4d0a-b1ea-0f7997c8774e.png)

![image](https://user-images.githubusercontent.com/61588921/147015223-d5909465-255b-4420-8058-1eeb723632b4.png)

#### 4. We also made a bonus.

We have added in our `main.yml` file, a `build` section, in order to **automatically build and push** our `docker image` on our `Docker hub` **online repository**. To **start the build**, we told the Ubuntun linux server that it was necessary for the **implemented tests to pass** too.

![image](https://user-images.githubusercontent.com/61588921/147142920-b65859a4-76ff-427c-b295-37288c7a3d07.png)

To **automatically connect** to our `Docker hub` repository, we also created two `Secret Actions`.

![image](https://user-images.githubusercontent.com/61588921/147143413-e7ed3e59-3c0f-428a-a2f7-8d7a968a9161.png)


### 3. Configure and provision a virtual environment and run your application using the IaC approach

#### 1. First, we created an `iac' folder and a `Vagrantfile', to describe the **type of machine we wanted** to **run our application** on.

We indicated that we wanted an `Ubuntu linux server`, and more specifically the `ubuntu/trusty64` machine (the most popular).

![image](https://user-images.githubusercontent.com/61588921/147016348-f07e826a-15e5-4100-a535-3056b4adb7ff.png)

Next, we set a **private IP address**, a **name**, an amount of **RAM** and a number of **CPUs**.

![image](https://user-images.githubusercontent.com/61588921/147016583-00843015-31d7-4b6d-b13f-f02ecc4b613b.png)

#### 2. In a second step, we provisioned our linux server with `Ansible`.

![image](https://user-images.githubusercontent.com/61588921/147017102-2472ecd9-25f5-4537-a651-7ee36fdd8c56.png)

To do this, we want to **install** and **configure** :
- a programming language
- a database (`Redis` in our case)
- our application (via an `sync folder`)
- a health check of our application

We have created a `playbooks` folder and a `run.yml` file. In it, we have indicated all the **tasks to follow and execute** to provision our **ubuntu server** as described above.

First, we want to **install** the latest version of `nodejs` and `npm` for our application. To do this, we **download and run** the `nodejs` **version manager**, `n`.

![image](https://user-images.githubusercontent.com/61588921/147017716-833756ca-47a5-4b04-9b43-bff8079b41da.png)

Next, we want to **install and configure** our `Redis` database.

![image](https://user-images.githubusercontent.com/61588921/147017871-1556a4a5-62b1-4929-ab9d-444c28f1536b.png)

We also **install** the packages needed to run our application, **application** which is **synchronized to our linux server** via an `sync folder`.

![image](https://user-images.githubusercontent.com/61588921/147018136-98681da8-08ea-4104-8de2-f5fce5c13d3d.png)

![image](https://user-images.githubusercontent.com/61588921/147018174-9b6b7685-7e3a-4b19-a8b0-223ea8bf0493.png)

Finally, we want to run our `Redis` database,

![image](https://user-images.githubusercontent.com/61588921/147018273-9bd5304d-0330-4755-b774-3112005a9348.png)

perform the **tests of our application**,

![image](https://user-images.githubusercontent.com/61588921/147018358-4ac3fe48-7ee5-4576-98f5-5dfc4bcdfe8f.png)

and **run it**.

![image](https://user-images.githubusercontent.com/61588921/147018391-4b79136b-860c-48a2-b39e-f980a56368eb.png)

We have defined `async` and `poll` to run several tasks in parallel, within our **playbook**.

#### 3. We also made a bonus.

We **implemented 2 tests** in the `webapp.rb` file in the `test` folder:
- we check that `Redis` is running on port **6379**
- we check that our application is launched on the **3000** port

![image](https://user-images.githubusercontent.com/61588921/147019590-9f982ab3-8f16-486f-b8ac-fee11585a6df.png)

To **run these tests**, we had to download a vagrant plugin:
```
vagrant plugin install vagrant-serverspec
```

and add this to our `Vagrantfile`:

![image](https://user-images.githubusercontent.com/61588921/147019729-cadc1b57-3c30-48b3-b23f-17a644f354a0.png)

#### 4. Finally, we create our linux server with the command ```vagrant up```

![image](https://user-images.githubusercontent.com/61588921/147019973-c32930d8-8a7a-4cb6-a8ca-056b29179f5d.png)

We check that our **VM** is **started**,

![image](https://user-images.githubusercontent.com/61588921/147020061-24e9895c-62e5-4986-af1b-ac79a1cd78f4.png)

and we **provide** it with our latest modifications. All **tasks** are performed:

![image](https://user-images.githubusercontent.com/61588921/147020487-4c141d81-cc3f-4fd6-b52b-fb595cf25728.png)

and our **tests** have passed with **success**.

![image](https://user-images.githubusercontent.com/61588921/147020575-88706f65-4ddf-4637-8fdf-00ed4cc21213.png)

Thus, we can access our **web application** via the **private IP address** and the **port** given in the `Vagrantfile`.

![image](https://user-images.githubusercontent.com/61588921/147020777-8f10b929-ba2c-40b8-b967-316a5da4fe24.png)


### 4. Build Docker image of your application 

#### 1. Create a Docker image of our application:

First we need to create a `Dockerfile` which will be used to containerize the application, and a `.dockerignore` file to **ignore** all the files and folders that do not need to be included in the image. To create the file, we run the following command in the CLI:   
```
touch Dockerfile
```  

Then the application dependencies are installed in the container. 

First, the container is based on the official `node`.
```
FROM node:14.17.5-alpine
```
We add our working environment.
```
WORKDIR /usr/src/app
```
We copy all the source files of the application that are not included in the `.dockerignore`.
```
COPY .. 
```
We install the application's dependencies. 
```
RUN npm install
```
We expose our container on **port 3000** by default.
```
EXPOSE 3000
```

Finally, we launch the container application. 
```
CMD ["npm", "start"]
```
#### 2. Build the Docker image of our application: 

To build the Docker image of our application, we need to run the following command: 
```
docker build . -t <IMAGE_NAME>
```

#### 3. Push the image to Docker Hub:

To push the image to `Docker Hub`, you must first connect to Docker Hub:
```
docker login
```

Then you have to tag the image with the right name: 
```
docker image tag projet_devops taumitrn/projet_devops:latest>
```

And finally, we push the image on `Docker Hub`: https://hub.docker.com/r/taumitrn/projet_devops

```
docker push taumitrn/projet_devops
```
![Capture d’écran 2021-12-21 à 14 16 45](https://user-images.githubusercontent.com/57870369/146936344-71d60ee2-ee66-4295-af92-7890aef67e4b.png)


### 5. Make container orchestration using Docker Compose

#### 1. Creating the Redis service

We use the `Redis` service as a database for our application. So we need to configure a `Redis` container. 
First of all, we need to create a `docker-compose.yaml` file in which we will define Redis:
```
touch docker-compose.yaml
```

In the `services` part of the file, we define `Redis` with the following lines of code (default port 6379):
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

And in the `app` part of the file, we implement the following lines of code (server listenning on port 3000):
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
#### 2. Launching the application

To launch the application, we use the following command: 
```
docker-compose up
```

and everything is **going well**

![image](https://user-images.githubusercontent.com/61588921/147153525-71f793fc-738d-467e-84ab-f0fda70e62b3.png)



### 6. Make Docker orchestration using Kubernetes

We have created a folder `k8s` for this part. It is composed of the following folders: `deployments`, `services` and `volumes`.  
In the `deployments` folder we have: 
+ [Node app deployment](k8s/deployments/node-app-deployment.yaml)
+ [Redis deployment](k8s/deployments/redis-deployment.yaml)

In the `services` folder we have:
+ [Node app service](k8s/services/node-app-service.yaml)
+ [Redis service](k8s/services/redis-service.yaml)

In the `volumes` folder we have:
+ [Redis volume](k8s/volumes/redis-volume.yaml)

First, we need to start `minikube`: 
```
minikube start 
```

Using the following command, we have our Kubernetes deployment: 
```
kubectl apply -f k8s/
```
or apply to each folder individually: 
```
kubectl apply -f k8s/deployments
kubectl apply -f k8s/services
kubectl apply -f k8s/volumes
```

Find the name of the service: 
```
kubectl get svc
```
![image](https://user-images.githubusercontent.com/57870369/147014509-74101c04-db1c-4091-9e39-66f2e8e2e413.png)

Start the service:
```
minikube service devops-project-service
```
![image](https://user-images.githubusercontent.com/57870369/147014548-f4f4e7a9-5d85-4b01-bd49-c1b1d68e13a7.png)

![Capture d’écran 2021-12-22 à 01 26 05](https://user-images.githubusercontent.com/57870369/147014639-f3a1bb54-bb94-4645-917c-1ab27cd40bec.png)

![Capture d’écran 2021-12-22 à 01 26 25](https://user-images.githubusercontent.com/57870369/147014665-91485a3d-5931-46fe-b6d8-cb07f62e7f30.png)

Our Kubernetes deployment is successful.

### 8. Implement Monitoring to your containerized application

#### 1. Install Prometheus and Grafana:

We have created a `monitoring` folder for this part. 

We get the source files from their respective official documentations and put them in a `grafana` and `prometheus` folder which we put in `monitoring`.    
+ Pour Grafana: https://grafana.com/docs/grafana/latest/installation/kubernetes/
+ Pour Prometheus: https://github.com/kubernetes-sigs/prometheus-adapter

To deploy these services, we use the following commands: 
```
kubectl apply -f grafana
```
<img width="567" alt="Capture d’écran 2021-12-22 à 18 09 14" src="https://user-images.githubusercontent.com/57870369/147129715-8a3387b6-a716-46ce-93e1-d851f1744eba.png">

```
kubectl apply -f prometheus
``` 
<img width="651" alt="Capture d’écran 2021-12-22 à 18 10 01" src="https://user-images.githubusercontent.com/57870369/147129792-158f5ffa-4bc3-416c-92d1-97a549ca5f5a.png">


#### 2. Set up monitoring with Prometheus:

To setup monitoring with `Prometheus`, we need to install the `metrics` contained in the GitHub below so that `Prometheus` fetches information from the Kubernetes cluster. 
We have the `setup` and `manifests` folders that we use to fetch our data. 
```
https://github.com/kubernetes/kube-state-metrics.git 
``` 
Then you have to deploy the metrics with the command: 
```
kubectl apply -f setup
kubectl apply -f manifests
```
![Capture d’écran 2021-12-22 à 18 27 18](https://user-images.githubusercontent.com/57870369/147131896-f8e4b815-e85b-4ad3-abae-2d094f021840.png)

#### 3. Set up monitoring with Grafana: 

To access Grafana, use the following command: 
```
kubectl port-forward service/grafana 3000 -n monitoring
```

This brings us to the Grafana page where we have to log in with an account for each instance of the application. 

![Capture d’écran 2021-12-22 à 18 11 26](https://user-images.githubusercontent.com/57870369/147129953-969d6a55-aed8-4001-8bd0-8a8a337db5db.png)

When creating a **dashboard**, we imported an already operational dashboard by entering the id **10856**, we link it with the `Prometheus` server in order to retrieve the information and display it as a graph. 

![Capture d’écran 2021-12-22 à 18 14 45](https://user-images.githubusercontent.com/57870369/147130380-d933e060-f494-4497-83ed-4bda6834aa7a.png)
![Capture d’écran 2021-12-22 à 18 15 29](https://user-images.githubusercontent.com/57870369/147130468-cc8facd9-d01f-427b-ae6c-ba6840d8448b.png)
![Capture d’écran 2021-12-22 à 18 29 04](https://user-images.githubusercontent.com/57870369/147132123-6e1fe271-6d03-4b50-89a8-0e1f077c2893.png)


## Authors :
HAZEBROUCK Antoine & TRAN Tommy from SI Group 2 FR Section.  
Our email adresses : antoine.hazebrouck@edu.ece.fr and tommydesirevalentin.tran@edu.ece.fr 


## Grading 

| Subject                                                         |   Code    | Max. grade|Done|
|:----------------------------------------------------------------|:---------:|:---------:|:---------|
| Enriched web application with automated tests                   |   APP     |    +1     | :white_check_mark: |
| Continuous Integration and Continuous Delivery (and Deployment) |   CICD    |    +3     | :white_check_mark: |
| Containerisation with Docker                                    |   D       |    +1     | :white_check_mark: |
| Orchestration with Docker Compose                               |   DC      |    +2     | :white_check_mark: |
| Orchestration with Kubernetes	                                  |   KUB     |    +3     | :white_check_mark: |
| Service mesh using Istio                                        |   IST     |    +0     |                    |
| Infrastructure as code using Ansible                            |   IAC     |    +3     | :white_check_mark: |
| Monitoring                                                      |   MON     |    +2     | :white_check_mark: |
| Accurate project documentation in README.md file                |   DOC     |    +3     | :white_check_mark: |
| Bonus: Build and push docker image automatically                |   BNS     |    +1     | :white_check_mark: |
| Bonus: Testing Ansible roles with serverspec                    |   BNS     |    +1     | :white_check_mark: |

