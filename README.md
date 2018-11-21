
# Kubernetes minimal setup for a web project

This include :
  * A ruby-rack application
  * Storage configuration
  * database configuration
  * A mail catcher
  * An HTTP server
  * liveness, readiness ....

## With Docker for Mac (not recommended) :

# Cleanup previous docker :
test -z "$(docker ps -q 2>/dev/null)" && osascript -e 'quit app "Docker"'
rm -rf ~/Library/Group\ Containers/group.com.docker

# Install docker and kubernete
brew cask reinstall docker-edge
brew install kubernetes-cli
brew install kubernetes-helm
brew install bindfs

# Launch docker
open --background -a Docker

# use helm to quicly configure an nginx
helm init --context=docker-for-desktop
helm install stable/nginx-ingress

# Use the projet :

bin/reset_kubernetes.sh # FIXME

Test : curl http-rack-server.local



## With Minikube

# Install docker and kubernete
brew install kubernetes-cli
brew install kubernetes-helm
brew install gettext
brew link --force gettext

TODO :

# minikube addons enable ingress

Test : curl http-rack-server.local

#
ADD DB pg
ADD cronjob

TEST remove ce health check on the host machine.


# Other :

How to debug some pod or put some binding : https://gist.github.com/Yoshyn/97d16ee4a71cf6ad4f928ebb34eb9d3c

# Create a production/staging

* Install Kops : https://github.com/kubernetes/kops
* Elastic Container Service for Kubernetes (Amazon EKS)
