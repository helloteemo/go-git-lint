#!/bin/bash
# shellcheck shell=bash

true=1
false=0

checkGolangCILint() {
  if ! [ -x "$(command -v golangci-lint)" ]; then
    echo 'Error: golangci-lint is not installed.' >&2
    exit 1
  fi
}

goImports() {
  golangci-lint run --disable-all -E goimports
  if [[ "${?}" == 1 ]]; then
    goimports -w ./
    git add .
    echo "自动执行goimports"
  fi
}

gofmt() {
  golangci-lint run --disable-all -E gofmt
  if [[ "${?}" == 1 ]]; then
    go fmt -w ./
    git add .
    echo "自动执行go fmt"
  fi
}

check() {
  for i in "prealloc" "bodyclose" "errcheck" "unconvert" "godox"; do
    golangci-lint run --disable-all -E $i
    if [ "${?}" == 1 -a "$GolangCILintMode" != "DEBUG" ]; then
      echo '当前模式采用严格模式，请修复错误再次提交'
      echo '如果要关闭严格模式,请运行 export GolangCILintMode=DEBUG 要恢复请运行 export GolangCILintMode=RELEASE'
      exit
    fi
  done
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
    echo "Invalid input:$1 ...默认进入下一步"
    return $true
    ;;
  esac
}

main() {
  checkGolangCILint
  goImports
  gofmt
  check

  echo "lint 检查完毕,允许commit"

}

main
