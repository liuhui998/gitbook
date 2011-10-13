## 查找问题的利器 - Git Bisect ##

假设你在项目的'2.6.18'版上面工作, 但是你当前的代码(master)崩溃(crash)了. 有时解决这种问题的最好办法是: 手工逐步恢复(brute-force regression)项目历史,　找出是哪个提交(commit)导致了这个问题. 但是 linkgit:git-bisect[1](二分查找) 可以更好帮你解决这个问题:

    $ git bisect start
    $ git bisect good v2.6.18
    $ git bisect bad master
    Bisecting: 3537 revisions left to test after this
    [65934a9a028b88e83e2b0f8b36618fe503349f8e] BLOCK: Make USB storage depend on SCSI rather than selecting it [try #6]


如果你现在运行"git branch",　会发现你现在所在的是"no branch"(译者注:这是进行git bisect的一种状态).  这时分支指向提交（commit):"69543", 此提交刚好是在"v2.6.18"和“master"中间的位置.  现在在这个分支里,　编译并测试项目代码, 查看它是否崩溃(crash). 假设它这次崩溃了, 那么运行下面的命令:

    $ git bisect bad
    Bisecting: 1769 revisions left to test after this
    [7eff82c8b1511017ae605f0c99ac275a7e21b867] i2c-core: Drop useless bitmaskings


现在git自动签出(checkout)一个更老的版本. 继续这样做, 用"git bisect good","git bisect bad"告诉git每次签出的版本是否没有问题; 你现在可以注意一下当前的签出的版本, 你会发现git在用"二分查找(binary search)方法"签出"bad"和"good"之间的一个版本(commit or revison). 


在这个项目(case)中, 经过13次尝试, 找出了导致问题的提交(guilty commit). 你可以用 linkgit:git-show[1] 命令查看这个提交(commit), 找出是谁做的修改，然后写邮件给TA. 最后, 运行:

    $ git bisect reset

这会到你之前(执行git bisect start之前)的状态.


注意: git-bisect 每次所选择签出的版本, 只是一个建议; 如果你有更好的想法, 也可以去试试手工选择一个不同的版本.

运行:
    $ git bisect visualize

这会运行gitk, 界面上会标识出"git bisect"命令自动选择的提交(commit). 你可以选择一个相邻的提交(commit), 记住它的SHA串值, 用下面的命令把它签出来:

    $ git reset --hard fb47ddb2db...


然后进行测试, 再根据测试結果执行”bisect good"或是"bisect bad"; 就这样反复执行, 直到找出问题为止.

译者注: 关于"git bisect start"后的分支状态, 译文和原文不一致. 原文是说执行"git bisect start"后会创建一个名为"bisect"的分支, 但是实际情况却是处于"no branch"的状态.