#!/bin/bash

true=1
false=0

checkGolangCILint() {
  #    if ! [ -x "$(command -v golangci-lint)" ]; then
  if [ -x "$(command -v golangci-lint)" ]; then
    echo 'Error: golangci-lint is not installed.'
    local flag="$false"
    read -r -p "是否需要安装golangci-lint (Y/N)" flag
    yesOrNo "$flag"

    if [ "$?" == $true ]; then
      installGolangCILint
    else
      exit 0
    fi

    exit 1
  fi
}

installGolangCILint() {
  local goPath=$(go env GOPATH1)
  if [ ! -n "$goPath" ]; then
    goPath="$HOME/go"
  fi
  curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b "${goPath}"/bin
  echo "export PATH=${goPath}/bin/:"'$PATH' >>"${HOME}"/.zshrc
  source "${HOME}"/.zshrc
  echo "golangci-lint安装成功"
}

yesOrNo() {
  case "$1" in
  [yY][eE][sS] | [yY])
    return $true
    ;;

  [nN][oO] | [nN])
    return $false
    ;;

  *)
    echo "Invalid input...默认进入下一步"
    return $true
    ;;
  esac
}

createGitTemplates() {
  if [ ! -d "$HOME/.git-templates/" ]; then
    mkdir "$HOME/.git-templates/"
  fi
  if [ ! -d "$HOME/.git-templates/hooks/" ]; then
    mkdir "$HOME/.git-templates/hooks/"
  fi
  locale file="$HOME/.git-templates/hooks/pre-commit"
  if [ ! -f "$file" ]; then
    touch "$file"
  fi
  cat "$PWD/pre-commit.sh" >"$file"

  chmod -R a+x "$HOME/.git-templates/hooks"
}

main() {
  # 判断是否安装golangci-lint,如果没有安装的话就直接安装
  checkGolangCILint
}

main
