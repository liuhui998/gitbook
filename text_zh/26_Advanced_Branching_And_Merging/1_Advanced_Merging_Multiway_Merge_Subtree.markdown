### 多路合并 ###

你可以一次合并多个头, 只需简单地把它们作为linkgit:git-merge[1]的参数列出. 例如,

	$ git merge scott/master rick/master tom/master

相当于:

	$ git merge scott/master
	$ git merge rick/master
	$ git merge tom/master

### 子树 ###

有时会出现你想在自己项目中引入其他独立开发项目的内容的情况. 在没有路径冲突的前提下, 你只需要简单地从其他项目拉取内容即可.

如果有冲突的文件, 那么就会出现问题. 可能的例子包括Makefile和其他一些标准文件名. 你可以选择合并这些冲突的文件, 但是更多的情况是你不愿意把它们合并. 一个更好解决方案是把外部项目作为一个子目录进行合并. 这种情况不被递归合并策略所支持, 所以简单的拉取是无用的.

在这种情况下, 你需要的是子树合并策略.

这下面例子中, 我们设定你有一个仓库位于/path/to/B (如果你需要的话, 也可以是一个URL). 你想要合并那个仓库的master分支到你当前仓库的dir-B子目录下.

下面就是你所需要的命令序列:

	$ git remote add -f Bproject /path/to/B (1)
	$ git merge -s ours --no-commit Bproject/master (2)
	$ git read-tree --prefix=dir-B/ -u Bproject/master (3)
	$ git commit -m "Merge B project as our subdirectory" (4)
	$ git pull -s subtree Bproject master (5)


子树合并的好处就是它并没有给你仓库的用户增加太多的管理负担. 它兼容于较老(版本号小于1.5.2)的客户端, 克隆完成之后马上可以得到代码.

然而, 如果你使用子模块(submodule), 你可以选择不传输这些子模块对象. 这可能在子树合并过程中造成问题.

译者注: submodule是Git的另一种将别的仓库嵌入到本地仓库方法.

另外, 若你需要修改内嵌外部项目的内容, 使用子模块方式可以更容易地提交你的修改.


(from [Using Subtree Merge](https://www.kernel.org/pub/software/scm/git/docs/howto/using-merge-subtree.html))


