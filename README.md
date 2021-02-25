# golang语言git lint工具

使用该工具可以一键布置golang语言的lint工具

## 安装说明

为了安装该脚本，请先安装(version 1.12+最好),接下来执行

```shell
git clone https://github.com/helloteemo/go-git-lint.git
cd go-git-lint
sh go-lint.sh
source ~/.zshrc
```

由于本人技术有限，加上个人环境不一致，使用自动化脚本可能安装不成功，接下来讲一下脚本安装的实现思路

1. 安装 `golangci-lint`,可以Google一下安装程序，当然也可以直接运行`go-lint.sh`的第28行
2. 配置`git hooks`,应该创建`~/.git-templates/hooks/pre-commit`文件，当然也可以在其它目录下
3. 接下来配置`git`,`git config --global init.templatedir ~/.git-templates`，如果第二步在其它目录的话，那么就应该修改目录

即可安装

## 功能点

在每次commit之前都会执行
`go fmt -w . && goimports -w .`
来格式化你的go代码，之后执行

1. prealloc 查找可能被预分配的片声明
2. bodyclose 检查http返回值的body是否被正确关闭
3. errcheck 检查是有有异常未被检查到
4. unconvert 删除不必要的类型转换
5. godox 用于检测FIXME、TODO和其他注释关键字的工具

如果在严格模式下，只有当全部检查通过之后才会commit

可以手动切换严格模式还是宝宝模式