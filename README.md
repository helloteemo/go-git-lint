# golang语言git lint工具

使用该工具可以一键布置golang语言的lint工具

## 安装说明

为了安装该脚本，请先安装(version 1.12+最好),接下来执行

```shell
git clone https://github.com/helloteemo/go-git-lint.git
cd go-git-lint
sh go-lint.sh
```

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