# Aliases for Apple’s `container` runtime (macOS only), mirroring the Docker
# shortcuts in docker.sh

if ! command -v container >/dev/null; then
  return
fi

alias cb='container build'
alias ce='container exec'
alias cei='container exec -it'
alias cr='container run --rm'
alias cri='container run --rm -it'
alias crun='container run -e USER="$(id -u)" -u "$(id -u)" -w /usr/src/app -v "$(pwd)":/usr/src/app --rm -it'

cls() {
  printf '\n%s\n' "$(color blue 'Containers')"
  container ls
  printf '\n%s\n' "$(color blue 'Images')"
  container image ls
  printf '\n%s\n' "$(color blue 'Volumes')"
  container volume ls
  printf '\n%s\n' "$(color blue 'Networks')"
  container network ls
}

crm() {
  printf '\n%s\n' "$(color red 'Pruning stopped containers')"
  container prune
  printf '\n%s\n' "$(color red 'Pruning unused images')"
  container image prune
  printf '\n%s\n' "$(color red 'Pruning unused volumes')"
  container volume prune
  printf '\n%s\n' "$(color red 'Pruning unused networks')"
  container network prune
}
