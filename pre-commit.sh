#!/bin/bash
# shellcheck shell=bash

true=1
false=0

checkGolangCILint() {
  if ! [ -x "$(command -v golangci-lint)" ]; then
    echo '=============================================='
    echo '=   Error: golangci-lint is not installed.   =' >&2
    echo '=============================================='
    exit 1
  fi
}

goImports() {
  golangci-lint run --disable-all -E goimports
  if [[ "${?}" == 1 ]]; then
    goimports -w ./
    git add .
    echo '=============================================='
    echo '=                                            ='
    echo '=              自动执行goimports             ='
    echo '=                                            ='
    echo '=============================================='
  fi
}

gofmt() {
  golangci-lint run --disable-all -E gofmt
  if [[ "${?}" == 1 ]]; then
    go fmt -w ./
    git add .
    echo '=============================================='
    echo "=                自动执行go fmt               ="
    echo '=============================================='
  fi
}

check() {
  for i in "prealloc" "bodyclose" "errcheck" "unconvert" "godox"; do
    golangci-lint run --disable-all -E $i
    if [ "${?}" == 1 -a "$GolangCILintMode" != "DEBUG" ]; then
      echo '**********************************************************************'
      echo '                当前模式采用严格模式，请修复错误再次提交                '
      echo '       如果要关闭严格模式,请运行 export GolangCILintMode=DEBUG       '
      echo '           要恢复请运行 export GolangCILintMode=RELEASE            '
      echo '**********************************************************************'
      exit 1
    fi
  done
  echo '======================================================================='
  echo '    行数检测和复杂度检测不是commit必须的，但是还是应该警惕这样的代码      '
  echo '======================================================================='
  golangci-lint run --disable-all -E funlen
  golangci-lint run --disable-all -E gocognit
}

checkGitIgnore() {
  if [ ! -f ".gitignore" ]; then
    touch ".gitignore"
  fi
  for word in "*.exe" "*.exe~" "*.dll" "*.so" "*.dylib" "*.test" "*.out" ".idea" ".vscode"; do
    grep "$word" .gitignore >/dev/null
    if [[ "${?}" == 1 ]]; then
      # 不包含word字符就要创建
      echo "$word" >>.gitignore
    fi
  done
  git add .gitignore
}

checkReadMe() {
  if [ ! -f "README.md" ]; then
    touch "README.md"
    echo '**********************************************************************'
    echo '                          请填写README.md文件                            '
    echo '                   填写README.md文件是对代码最基本的尊重                    '
    echo '**********************************************************************'
    git add README.md
    exit 1
  fi
}

main() {
  # 新增README文件检测
  checkReadMe
  # 新增.gitignore检测
  checkGitIgnore
  checkGolangCILint
  goImports
  gofmt
  check
  echo ' '
  echo '====================================='
  echo "         lint 检查完毕,允许commit"
  echo '====================================='
  echo ' '
}

main
