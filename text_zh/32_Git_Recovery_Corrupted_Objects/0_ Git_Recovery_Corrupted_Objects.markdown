## 找回丢失的对象 ##

译者注: 原书这里只有两个链接：
[Recovering Lost Commits Blog Post](https://programblings.com/2008/06/07/the-illustrated-guide-to-recovering-lost-commits-with-git)，　
[Recovering Corrupted Blobs by Linus](https://www.kernel.org/pub/software/scm/git/docs/howto/recover-corrupted-blob-object.txt)

我根据第一个链接，整理了一篇[博文](https://liuhui998.com/2010/10/22/recover_lost_commits_with_git/)，并把它做为原书补充。

在玩git的过程中，常有失误的时候，有时把需要的东东给删了。
不过没有关系，git给了我们一层安全网，让们能有机会把失去的东东给找回来。

Let's go!

###准备###
	
我们先创建一个用以实验的仓库，在里面创建了若干个提交和分支。
BTW：你可以直接把下面的命令复制到shell里执行。

	mkdir recovery;cd recovery
	git init
	touch file
	git add file
	git commit -m "First commit"
	echo "Hello World" > file
	git add .
	git commit -m "Greetings"
	git branch cool_branch　
	git checkout cool_branch
	echo "What up world?" > cool_file
	git add .
	git commit -m "Now that was cool"
	git checkout master
	echo "What does that mean?" >> file

 
###恢复已删除分支提交###
	
现在repo里有两个branch

	$ git branch
	cool_branch
	* master

存储当前仓库未提交的改动

	$ git stash save "temp save"
	Saved working directory and index state On master: temp save
	HEAD is now at e3c9b6b Greetings

删除一个分支
	
	$ git branch -D cool_branch
	Deleted branch cool_branch (was 2e43cd5).

	$ git branch
	 * master

 用`git fsck --lost-found`命令找出刚才删除的分支里面的提交对象。

 	$git fsck --lost-found
	  dangling commit 2e43cd56ee4fb08664cd843cd32836b54fbf594a

用git show命令查看一个找到的对象的内容，看是否为我们所找的。
  
	git show 2e43cd56ee4fb08664cd843cd32836b54fbf594a

	  commit 2e43cd56ee4fb08664cd843cd32836b54fbf594a
	  Author: liuhui <liuhui998[#]gmail.com>
	  Date:   Sat Oct 23 12:53:50 2010 +0800

	  Now that was cool

	  diff --git a/cool_file b/cool_file
	  new file mode 100644
	  index 0000000..79c2b89
	  --- /dev/null
	  +++ b/cool_file
	  @@ -0,0 +1 @@
	  +What up world?

这个提交对象确实是我们在前面删除的分支的内容；下面我们就要考虑一下要如何来恢复它了。

#### 使用git rebase　进行恢复####

	  $git rebase 2e43cd56ee4fb08664cd843cd32836b54fbf594a
	  First, rewinding head to replay your work on top of it...
	  Fast-forwarded master to 2e43cd56ee4fb08664cd843cd32836b54fbf594a.
	  
现在我们用git log命令看一下，看看它有没有恢复:

	  $ git log

	  commit 2e43cd56ee4fb08664cd843cd32836b54fbf594a
	  Author: liuhui <liuhui998[#]gmail.com>
	  Date:   Sat Oct 23 12:53:50 2010 +0800

	  Now that was cool

	  commit e3c9b6b967e6e8c762b500202b146f514af2cb05
	  Author: liuhui <liuhui998[#]gmail.com>
	  Date:   Sat Oct 23 12:53:50 2010 +0800

	  Greetings

	  commit 5e90516a4a369be01b54323eb8b2660545051764
	  Author: liuhui <liuhui998[#]gmail.com>
	  Date:   Sat Oct 23 12:53:50 2010 +0800

	  First commit

提交是找回来，但是分支没有办法找回来：

	  liuhui@liuhui:~/work/test/git/recovery$ git branch
	  * master

#### 使用git merge　进行恢复 ####


我们把刚才的恢复的提交删除

	  $ git reset --hard HEAD^
	  HEAD is now at e3c9b6b Greetings

再把刚删的提交给找回来：

	  git fsck --lost-found
	  dangling commit 2e43cd56ee4fb08664cd843cd32836b54fbf594a

不过这回我们用是合并命令进行恢复：

	  $ git merge 2e43cd56ee4fb08664cd843cd32836b54fbf594a
	  Updating e3c9b6b..2e43cd5
	  Fast-forward
	  cool_file |    1 +
	  1 files changed, 1 insertions(+), 0 deletions(-)
	  create mode 100644 cool_file

### git stash的恢复 ###

前面我们用git stash把没有提交的内容进行了存储，如果这个存储不小心删了怎么办呢？

当前repo里有的存储：
    $ git stash list
    stash@{0}: On master: temp save

把它们清空：
    $git stash clear
    liuhui@liuhui:~/work/test/git/recovery$ git stash list

再用git fsck --lost-found找回来：
    $git fsck --lost-found
    dangling commit 674c0618ca7d0c251902f0953987ff71860cb067

用git show看一下回来的内容对不对：

    $git show 674c0618ca7d0c251902f0953987ff71860cb067

    commit 674c0618ca7d0c251902f0953987ff71860cb067
    Merge: e3c9b6b 2b2b41e
    Author: liuhui <liuhui998[#]gmail.com>
    Date:   Sat Oct 23 13:44:49 2010 +0800

        On master: temp save

	diff --cc file
	index 557db03,557db03..f2a8bf3
	--- a/file
	+++ b/file
	@@@ -1,1 -1,1 +1,2 @@@
	  Hello World
	  ++What does that mean?

看起来没有问题，好的，那么我就把它恢复了吧：

	$ git merge 674c0618ca7d0c251902f0953987ff71860cb067
	Merge made by recursive.
	 file |    1 +
	  1 files changed, 1 insertions(+), 0 deletions(-)


###备注###

这篇文章主要内容来自这里：[The illustrated guide to recovering lost commits with Git](https://programblings.com/2008/06/07/the-illustrated-guide-to-recovering-lost-commits-with-git/),我做了一些整理的工作。

如果对于文中的一些命令不熟，可以参考[Git Community Book中文版](https://gitbook.liuhui998.com)

其实这里最重要的一个命令就是：git fsck --lost-found，因为git中把commit删了后，并不是真正的删除，而是变成了悬空对象（dangling commit）。我们只要把把这悬空对象（dangling commit）找出来，用[git rebase](https://gitbook.liuhui998.com/4_2.html)也好，用[git merge](https://gitbook.liuhui998.com/3_3.html)也行就能把它们给恢复。

