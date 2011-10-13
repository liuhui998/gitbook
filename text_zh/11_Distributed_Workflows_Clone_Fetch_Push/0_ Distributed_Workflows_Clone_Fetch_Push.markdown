## 分布式的工作流程 ##

假设Alice现在开始了一个新项目，在/home/alice/project建了一个新的git
仓库(repository)；另一个叫Bob的工作目录也在同一台机器，他要提交代码。

Bob 执行了这样的命令:

    $ git clone /home/alice/project myrepo


这就建了一个新的叫"myrepo"的目录，这个目录里包含了一份Alice的仓库的
克隆(clone). 这份克隆和原始的项目一模一样，并且拥有原始项目的历史记
录。


Bob 做了一些修改并且提交(commit)它们:

    (edit files)
    $ git commit -a
    (repeat as necessary)


当他准备好了，他告诉Alice从仓库/home/bob/myrepo中把他的修改给拉
(pull)下来。她执行了下面几条命令:

    $ cd /home/alice/project
    $ git pull /home/bob/myrepo master


这就把Bob的主(master)分支合并到了Alice的当前分支里了。如果Alice在
Bob修改文件内容的同时也做了修改的话，她可能需要手工去修复冲突.
(注意："master"参数在上面的命令中并不一定是必须的，因为这是一个
默认参数)


git pull命令执行两个操作: 它从远程分支(remote branch)抓取修改
的内容，然后把它合并进当前的分支。


如果你要经常操作远程分支(remote branch),你可以定义它们的缩写:

    $ git remote add bob /home/bob/myrepo


这样，Alic可以用"git fetch"" 来执行"git pull"前半部分的工作，
但是这条命令并不会把抓下来的修改合并到当前分支里。

    $ git fetch bob

我们用`git remote`命令建立了Bob的运程仓库的缩写，用这个(缩写)
名字我从Bob那得到所有远程分支的历史记录。在这里远程分支的名
字就叫`bob/master`.

    $ git log -p master..bob/master


上面的命令把Bob从Alice的主分支(master)中签出后所做的修改全部显示出来。


当检查完修改后,Alice就可以把修改合并到她的主分支中。

    $ git merge bob/master

这种合并(merge)也可以用pull来完成，就像下面的命令一样：

    $ git pull . remotes/bob/master


注意：git pull 会把远程分支合并进当前的分支里，而不管你在命令
行里指定什么。


其后，Bob可以更新它的本地仓库--把Alice做的修改拉过来(pull):

    $ git pull


如果Bob从Alice的仓库克隆(clone)，那么他就不需要指定Alice仓库的地
址；因为Git把Alice仓库的地址存储到Bob的仓库配库文件，这个地址就是
在git pull时使用：

    $ git config --get remote.origin.url
    /home/alice/project


(如果要查看git clone创建的所有配置参数，可以使用"git config -l",
linkgit:git-config[1] 的帮助文件里解释了每个参数的含义.)


Git同时也保存了一份最初(pristine)的Alice主分支(master)，在
"origin/master"下面。

    $ git branch -r
      origin/master


如果Bob打算在另外一台主机上工作，他可以通过ssh协议来执行"clone"
和"pull"操作：

    $ git clone alice.org:/home/alice/project myrepo


git有他自带的协议(native protocol),还可以使用rsync或http; 你可以点
这里 linkgit:git-pull[1] 看一看更詳細的用法。


Git也可以像CVS一样来工作：有一个中心仓库，不同的用户向它推送(push)
自己所作的修改；你可以看看这里： linkgit:git-push[1] linkgit:gitcvs-migration[1].


### 公共Git仓库 ###

另外一个提交修改的办法，就是告诉项目的维护者(maintainer)用 linkgit:git-pull[1]
命令从你的仓库里把修改拉下来。这和从主仓库"里更新代码类似，但是是从
另外一个方向来更新的。

如果你和维护者(maintainer)都在同一台机器上有帐号，那么你们可以互相从对
方的仓库目录里直接拉(pull)所作的修改；git命令里的仓库地址也可以是本地
的某个目录名：

    $ git clone /path/to/repository
    $ git pull /path/to/other/repository


也可以是一个ssh地址：

    $ git clone ssh://yourhost/~you/repository

如果你的项目只有很少几个开发者，或是只需要同步很少的几个私有仓库，
上面的方法也许够你用的。


然而，更通用的作法是维护几个不同的公开仓库(public repository).
这样可以把每个人的工作进度和公开仓库清楚的分开。


你还是每天在你的本地私人仓库里工作，但是会定期的把本地的修改推(push)
到你的公开仓库中；其它开发者就可以从这个公开仓库来拉(pull)最新的代码。
如果其它开发者也有他自己的公共仓库，那么他们之间的开发流程就如下图
所示：

                            you push
      your personal repo ------------------> your public repo
    	^                                     |
    	|                                     |
    	| you pull                            | they pull
    	|                                     |
    	|                                     |
            |               they push             V
      their public repo <------------------- their repo
      


### 将修改推到一个公共仓库 ###


通过http或是git协议，其它维护者可以抓取(fetch)你最近的修改，但是他们
没有写权限。这样，这需要将本地私有仓库的最近修改上传公共仓库中。

译者注: 通过http的WebDav协议是可以有写权限的,也有人配置了git over http.


最简单的办法就是用 linkgit:git-push[1]命令 和ssh协议; 用你本地的"master"
分支去更新远程的"master"分支，执行下面的命令:

    $ git push ssh://yourserver.com/~you/proj.git master:master

or just

或是:

    $ git push ssh://yourserver.com/~you/proj.git master

和git-fetch命令一样git-push如果命令的执行结果不是"快速向前"(fast forward)
就会报错; 下面的章节会讲如何处理这种情况.


推(push)命令的目地仓库一般是个裸仓库(bare respository). 你也可以推到一
个签出工作目录树(checked-out working tree)的仓库，但是工作目录中内
容不会被推命令所更新。如果你把自己的分支推到一个已签出的分支里，这
会导致不可预知的后果。


在用git-fetch命令时，你也可以修改配置参数，让你少打字:)。

下面这些是例子:

    $ cat >>.git/config <<EOF
    [remote "public-repo"]
    	url = ssh://yourserver.com/~you/proj.git
    EOF


你可以用下面的命令来代替前面复杂的命令:

    $ git push public-repo master


你可以点击这里: linkgit:git-config[1]，查看remote.<name>.url, 
branch.<name>.remote, 和remote.<name>.push等选项的解释.


### 当推送代码失败时要怎么办 ###


如果推送(push)结果不是"快速向前"(fast forward),那么它
可能会报像下面一样的错误：

    error: remote 'refs/heads/master' is not an ancestor of
    local  'refs/heads/master'.
    Maybe you are not up-to-date and need to pull first?
    error: failed to push to 'ssh://yourserver.com/~you/proj.git'


这种情况通常由以下的原因产生：


	- 用 `git-reset --hard` 删除了一个已经发布了的一个提交，或是

	- 用 `git-commit --amend` 去替换一个已经发布的提交，或是

	- 用 `git-rebase` 去rebase一个已经发布的提交.　 


你可以强制git-push在上传修改时先更新，只要在分支名前面加一个加号。


    $ git push ssh://yourserver.com/~you/proj.git +master

Normally whenever a branch head in a public repository is modified, it
is modified to point to a descendant of the commit that it pointed to
before.  By forcing a push in this situation, you break that convention.


Nevertheless, this is a common practice for people that need a simple
way to publish a work-in-progress patch series, and it is an acceptable
compromise as long as you warn other developers that this is how you
intend to manage the branch.

It's also possible for a push to fail in this way when other people have
the right to push to the same repository.  In that case, the correct
solution is to retry the push after first updating your work: either by a
pull, or by a fetch followed by a rebase; see the next section and
linkgit:gitcvs-migration[7] for more.

[gitcast:c8-dist-workflow]("GitCast #8: Distributed Workflow")
