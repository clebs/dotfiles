# -------- GIT --------- #

# shorthand pull
alias pull='git pull -p'
#shorthand checkout: new branch or existing one
alias br='checkout $1'

# checkout a git branch or create it anew if it does not exist
function checkout {
  RESULT="$(git checkout $1 2>&1)"
  if [[ $RESULT == *"error: pathspec"* ]]; then
    git checkout -b $1
  else
    git checkout $1
  fi 
}

# sync with remote origin and fork: update master, delete merged branches and rebase fork
function sync {
  # Update all remotes: fetch new branches and remove deleted ones
  echo "Syncing remotes:"
  git fetch --all --prune
  
  echo "Done!\n\n-----\n"
  
  # Start on master
  git checkout master -q
  echo "Syncing $(git rev-parse --abbrev-ref HEAD):"

  # Show status before puling silently
  git status -b -s
  git pull -q

  echo "Done!\n\n-----\n"

  # Remove stale branches
  echo "Cleaning stale branches:"
  
  git branch -vv | grep '.*/.*: gone]' | awk '{print $1}' | grep -v 'master' | xargs git branch -D
  
  echo "Done!\n\n-----\n"

  git checkout masterf -q
  echo "Syncing $(git rev-parse --abbrev-ref HEAD):"

  # Rebase with master and show status with fork remote
  git pull -q
  git rebase master -q
  git status -b -s

  echo "Done!\n\n-----\n"
}


# -------- DOCKER --------- #

# login to Hybris registry
alias dl='docker login'
# remove all containers
alias dr='docker rm -f $(docker container ls -aq)'

# Switch docker context
function ctx {
  case $1 in
    local) # Dockerd = OSX / k8s = minikube
      eval "$(docker-machine env -u)"
      kubectl config use minikube > /dev/null
      export CTX="local"
      return 0
      ;;
    minikube) # Dockerd = minikube / k8s = minikube
      eval $(minikube docker-env)
      kubectl config use minikube > /dev/null
      export CTX="minikube"
      return 0
      ;;
    nightly) # Dockerd = OSX / k8s = nightly.cluster.kyma.cxq
      eval "$(docker-machine env -u)"
      kubectl config use nightly.cluster.kyma.cx > /dev/null
      export CTX="nightly"
      return 0
      ;;
    "") # Unset contest means: Dockerd = OSX / k8s = minikube / remove CTX label
      eval "$(docker-machine env -u)"
      kubectl config use minikube > /dev/null
      export CTX=""
      return 0
      ;;
    *)
      echo "Docker environment not supported: $1"
      unset CTX
      return 1
      ;;
  esac
} 


# -------- K8S --------- #

# Update Kubectl
alias update-kubectl='curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl'

#watch k8s cluster, can set namespace and labels on/off
function wk {
  local NS='--all-namespaces'  
  while getopts "n:l" opt; do
    case ${opt} in
        n)
            NS="-n "$OPTARG
            ;;
        l)
            local LABELS='--show-labels'
            ;;
        *)
            echo "Wrong usage"
            exit 1
    esac
  done
  watch -n 5 "kubectl get pods $NS $LABELS"
}

# -------- KYMA --------- #

# Get admin password for current context
alias kyma-admin-password='kubectl get secret admin-user -n kyma-system -o jsonpath="{.data.password}" | base64 -D'

# -------- MISC --------- #

# colored cat
alias ccat='pygmentize -g'
# gopath cd
alias cdg='cd $GOPATH/src'

# -------- PROJECTS --------- #

# cd into kyma project
alias ky='cd ~/Dev/go/src/github.com/kyma-project'
