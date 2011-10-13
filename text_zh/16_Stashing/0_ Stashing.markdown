## 储藏 ##

当你正在做一项复杂的工作时, 发现了一个和当前工作不相关但是又很讨厌的bug. 你这时想先修复bug再做手头的工作, 那么就可以用 linkgit:git-stash[1] 来保存当前的工作状态, 等你修复完bug后,执行'反储藏'(unstash)操作就可以回到之前的工作里.


    $ git stash "work in progress for foo feature"


上面这条命令会保存你的本地修改到`储藏`(stash)中, 然后将你的工作目录和索引里的内容全部重置, 回到你当前所在分支的上次提交时的状态.

好了, 你现在就可以开始你的修复工作了.

    ... edit and test ...
    $ git commit -a -m "blorpl: typofix"


当你修复完bug后, 你可以用`git stash apply`来回复到以前的工作状态.

    $ git stash apply


### 储藏队列 ###

你也可多次使用'git stash'命令,　每执行一次就会把针对当前修改的‘储藏’(stash)添加到储藏队列中. 用'git stash list'命令可以查看你保存的'储藏'(stashes):

	$>git stash list
	stash@{0}: WIP on book: 51bea1d... fixed images
	stash@{1}: WIP on master: 9705ae6... changed the browse code to the official repo


可以用类似'git stash apply stash@{1}'的命令来使用在队列中的任意一个'储藏'(stashes). 'git stash clear‘则是用来清空这个队列.