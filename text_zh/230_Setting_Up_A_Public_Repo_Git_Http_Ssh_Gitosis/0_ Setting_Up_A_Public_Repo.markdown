## 建立一个公共仓库 ##

假设你个人的仓库在目录 ~/proj. 我们先克隆一个新的“裸仓库“,并且创建一个标志文件告诉git-daemon这是个公共仓库.

    $ git clone --bare ~/proj proj.git
    $ touch proj.git/git-daemon-export-ok


上面的命令创建了一个proj.git目录, 这个目录里有一个“裸git仓库" -- 即只有'.git'目录里的内容,没有任何签出(checked out)的文件.

下一步就是你把这个 proj.git　目录拷到你打算用来托管公共仓库的主机上. 你可以用scp, rsync或其它任何方式.


### 通过git协议导出git仓库 ###

用git协议导出git仓库, 这是推荐的方法.

如果这台服务器上有管理员，TA们要告诉你把仓库放在哪一个目录中, 并且“git:// URL”除仓库目录部分外是什么.


你现在要做的是启动 linkgit:git-daemon[1]; 它会监听在 9418端口. 默认情况下它会允许你访问所有的git目录(看目录中是否有git-daemon-export-ok文件). 如果以某些目录做为 git-daemon 的参数, 那么 git-daemon 会限制用户通过git协议只能访问这些目录.

你可以在inetd service模式下运行 git-daemon; 点击 linkgit:git-daemon[1]　可以查看帮助信息.

### 通过http协议导出git仓库 ###

git协议有不错的性能和可靠性, 但是如果主机上已经配好了一台web服务器,使用http协议(git over http)可能会更容易配置一些.

你需要把新建的"裸仓库"放到Web服务器的可访问目录里, 同时做一些调整,以便让web客户端获得它们所需的额外信息.

    $ mv proj.git /home/you/public_html/proj.git
    $ cd proj.git
    $ git --bare update-server-info
    $ chmod a+x hooks/post-update

(最后两行命令的解释可以点击这里查看: linkgit:git-update-server-info[1] &  linkgit:githooks[5].)

拼好了proj.git的web URL, 任何人都可以从这个地址来克隆(clone)或拉取(pull) git仓库内容. 下面这个命令就是例子:

    $ git clone http://yourserver.com/~you/proj.git
