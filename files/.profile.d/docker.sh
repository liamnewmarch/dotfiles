# Return early if docker is not defined
if ! command -v docker >/dev/null; then
  return
fi

alias db='docker build --rm'
alias dcb='docker compose build'
alias dcd='docker compose down'
alias dce='docker compose exec'
alias dcr='docker compose run --rm'
alias dcrs='docker compose restart'
alias dcu='docker compose up'
alias dcub='docker compose up --build'
alias dcud='docker compose up --detach'
alias dcl='docker compose logs --follow --tail 0'
alias dcla='docker compose logs --follow'
alias dcps='docker compose ps'
alias de='docker exec'
alias dei='docker exec -it'
alias dr='docker run --rm'
alias dri='docker run --rm -it'
alias drun='docker run -e USER="$(id -u)" -u="$(id -u)" -w /usr/src/app -v $(pwd):/usr/src/app --rm -it'

dls() {
  printf '\n%s\n' "$(color blue 'Docker containers')"
  docker container ls
  printf '\n%s\n' "$(color blue 'Docker images')"
  docker image ls
  printf '\n%s\n' "$(color blue 'Docker volumes')"
  docker volume ls
  printf '\n%s\n' "$(color blue 'Docker networks')"
  docker network ls
}

drm() {
  printf '\n%s\n' "$(color red 'Pruning Docker containers')"
  docker container prune -f
  printf '\n%s\n' "$(color red 'Pruning Docker images')"
  docker image prune -f
  printf '\n%s\n' "$(color red 'Pruning Docker volumes')"
  docker volume prune -f
  printf '\n%s\n' "$(color red 'Pruning Docker networks')"
  docker network prune -f
}
