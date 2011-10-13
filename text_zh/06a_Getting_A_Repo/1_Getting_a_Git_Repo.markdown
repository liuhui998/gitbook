## 获得一个Git仓库 ##

既然我们现在把一切都设置好了，那么我们需要一个Git仓库。有两种方法可以得到它：一种是从已有的Git仓库中　*clone* (克隆，复制)；还有一种是新建一个仓库，把未进行版本控制的文件进行版本控制。


### Clone一个仓库 ###

为了得一个项目的拷贝(copy),我们需要知道这个项目仓库的地址(Git URL). Git能在许多协议下使用，所以Git URL可能以ssh://, http(s)://, git://,或是只是以一个用户名（git 会认为这是一个ssh 地址）为前辍. 有些仓库可以通过不只一种协议来访问，例如，Git本身的源代码你既可以用 git:// 协议来访问：

    git clone git://git.kernel.org/pub/scm/git/git.git

也可以通过http 协议来访问:

    git clone http://www.kernel.org/pub/scm/git/git.git

git://协议较为快速和有效,但是有时必须使用http协议,比如你公司的防火墙阻止了你的非http访问请求.如果你执行了上面两行命令中的任意一个,你会看到一个新目录: 'git',它包含所有的Git源代码和历史记录.


在默认情况下，Git会把"Git URL"里目录名的'.git'的后辍去掉,做为新克隆(clone)项目的目录名:
 (例如. *git clone http://git.kernel.org/linux/kernel/git/torvalds/linux-2.6.git*  会建立一个目录叫'linux-2.6')


### 初始化一个新的仓库 ###

现在假设有一个叫”project.tar.gz”的压缩文件里包含了你的一些文件，你可以用下面的命令让它置于Git的版本控制管理之下.

    $ tar xzf project.tar.gz
    $ cd project
    $ git init

Git会输出:

    Initialized empty Git repository in .git/


如果你仔细观查会发现project目录下会有一个名叫”.git” 的目录被创建，这意味着一个仓库被初始化了。

[gitcast:c1_init](GitCast #1 - setup, init and cloning)

