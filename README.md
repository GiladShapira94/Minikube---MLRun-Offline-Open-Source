![image](https://user-images.githubusercontent.com/100074049/160272315-ca505909-1000-4153-bfd2-70362e777336.png)
# Minikube-MLRun-Offline-Open-Source
This Repository Include all necessary step to use MLRun open source in offline mode in minikube platform

# Installation Prerequisite
1. Access to a Kubernetes cluster. You must have administrator permissions in order to install MLRun on your cluster. For local installation on Windows or Mac, [Docker Desktop](https://www.docker.com/products/docker-desktop/) is recommended. MLRun fully supports k8s releases up to and including 1.21.
2. The Kubernetes command-line tool (kubectl) compatible with your Kubernetes cluster is installed. Refer to the [kubectl installation instructions](https://kubernetes.io/docs/tasks/tools/) for more information.

3. Helm CLI is installed. Refer to the [Helm installation instructions](https://helm.sh/docs/intro/install/) for more information.
4. Install docker and verify that docker resources are defined as CPU =2 and Memory=8000MB (docker info use to show your resources) - this is the minimum needed requirements.
    * To change the resources do to the setting menu -> preferences -> resource and change the relevant resource
5. Install minikube and verify that minikube resources are defined as CPU=2 and Memory=8000MB
    * to change your resource use this code line and change the relevant values - minikube config set memory <example - 8192> or minikube config set cpu <value>
    * In the end you will need to run minikube delete code line, and minikube start to restart minikube and set the new configs 
6. Check that all necessary files are saved in your file system:
    * All Images Directory - there are 26 items
    * Images-loader.sh - change if needed the path to the images directory
    * mlrun-kit.tgz
    * Demo Directory - includes three code examples and one CSV file 

# Installation 
1. Run minikube on your terminal:
  ```
  minikube start
  ```
2. Connect minikube to your docker environment:
  ```
  eval $(minikube docker-env)
  ```
3. Create a namespace for the deployed components:
  ```
  kubectl create namespace mlrun
  ```
4. Load all necessary images from All_Images directory - tip use the Images-loader.sh bash script
  ```
  sh Images-loader.sh
  ```
5. Install mlrun-kit chart:
  ```
  helm --namespace mlrun \
    install my-mlrun \
    --wait \
    --set global.registry.url=localhost:5000 \
    --set global.externalHostAddress=$(minikube ip) \
    <file-path>/mlrun-kit.tgz
  ````
6.After you installed mlrun-kit helm chart please check that all pods are running as they should use: 
      ```
      kubectl get pods -n mlrun
      ```

Example:
<img width="1045" alt="Screen Shot 2022-03-27 at 11 48 11" src="https://user-images.githubusercontent.com/100074049/160274003-4cb7860c-fd16-4512-9d12-2a646cc646af.png">

7. For your services expose you need to open a new terminal and run on it this command:
      ```
      minikube tunnel
      ```

8. Before using the service you will need to expose them by using these code lines:
      ```
      kubectl patch svc mlrun-api -n mlrun -p '{"spec": {"type": "LoadBalancer"}}' ;
      kubectl patch svc mlrun-ui -n mlrun -p '{"spec": {"type": "LoadBalancer"}}' ;
      kubectl patch svc my-mlrun-mlrun-kit-jupyter   -n mlrun -p '{"spec": {"type": "LoadBalancer"}}' ;
      kubectl patch svc nuclio-dashboard  -n mlrun -p '{"spec": {"type": "LoadBalancer"}}' ;
      ```
9. In the end enter your system paswword in the terminal that the tunnel run on it, Example:   
<img width="1364" alt="Screen Shot 2022-03-27 at 11 59 29" src="https://user-images.githubusercontent.com/100074049/160274412-33ad4195-eedc-41c6-a2cb-ba0c235b4b27.png">

* Your applications are now available in your local browser:
  *	Jupyter-notebook - http://127.0.0.1:8888
  * Nuclio - http://127.0.0.1:8070
  * MLRun UI - http://127.0.0.1
 
 10. Create a local registry for your nuclio functions:
      ```
      docker run -d -p 5000:5000 --restart=always --name registry registry:2
      ```

11. Run the demo file in the Demo folder - for your convenience save the CSV file in the data folder within jupyter

