## 从其他代码管理工具迁移到Git ##

你决定要把你的整个项目从原来的代码管理工具迁移到Git, 要怎么做才比较简单呢?

### 从Subversion导入 ###

Git包含了一个名为git-svn的脚本, 它有一个克隆(clone)命令, 可以把一个Subversion仓库导入到一个新的Git仓库. GitHub上也有完成同样工作的免费工具.

	$ git-svn clone https://my-project.googlecode.com/svn/trunk new-project

上面的命令会创建一个包含原来Subversion仓库全部历史记录的Git仓库. 通常这个操作会花相当长的时间, 因为它从第1个版本开始, 一个一个版本地签出, 然后再把这些版本进行本地提交.

### 从Perforce导入

在contrib/fast-import目录下, 你会找到git-p4脚本, 它会帮你导入Perforce仓库.

	$ ~/git.git/contrib/fast-import/git-p4 clone //depot/project/main@all myproject


### 从其他管理工具导入 ###

These are other SCMs that listed high on the Git Survey, should find import
docs for them.  !!TODO!!

* CVS
* Mercurial (hg)

* Bazaar-NG
* Darcs
* ClearCase

