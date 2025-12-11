## 建立一个私有仓库 ##

如果不使用第三方的代码托管服务,而是要自己在服务器上建一个网上可访问的私有代码仓库, 你有几种选择:

### 通过SSH协议来访问仓库　###

通常最简单的办法是通ssh协议访问Git(Git Over SSH). 如果你在一台机器上有了一个ssh帐号, 你只要把“git祼仓库"放到任何一个可以通过ssh访问的目录, 然后可以像ssh登录一样简单的使用它. 假设你现在有一个仓库，并且你要把它建成可以在网上可访问的私有仓库. 你可以用下面的命令, 导出一个"祼仓库", 然后用scp命令把它们拷到你的服务器上:
	
	$ git clone --bare /home/user/myrepo/.git /tmp/myrepo.git
	$ scp -r /tmp/myrepo.git myserver.com:/opt/git/myrepo.git
	

如果其它人也在 myserver.com　这台服务器上有ssh帐号，那么TA也可以从这台服务器上克隆(clone)代码:

	$ git clone myserver.com:/opt/git/myrepo.git

上面的命令会提示你输入ssh密码或是使用公钥(public key).

译者注1:配置ssh公钥的方法可以参考[这里](https://help.github.com/linux-key-setup/),这样在ssh访问时就可以不要输入命令.

译者注2:git over ssh方式对仓库有读写权限, git://协议只能读仓库.



### 使用Gitosis的多用户访问 ###

如果你不想为每个用户配置不同的帐号,你可以用一个叫Gitosis的工具. 在gitosis中, 有一个叫 authorized_keys 的文件，里面包括了所有授权可以访问仓库的用户的公钥(public key), 这样每个用户就可以直接使用'git'用户来推送(push)和拉(pull)代码.

[安装与配置Gitosis(英文)](https://www.urbanpuddle.com/articles/2008/07/11/installing-git-on-a-server-ubuntu-or-debian)

译者注1: [github.com](https://help.github.com/linux-key-setup/)就是采用这种方式来配置私有(仓库)访问.

译者注２: [Gitosis配置(中文)](https://progit.chunzi.me/zh/ch4-7.html)
