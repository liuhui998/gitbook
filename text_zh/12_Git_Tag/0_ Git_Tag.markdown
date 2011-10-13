## Git标签 ##

### 轻量级标签 ###

我们可以用 linkgit:git-tag[1]不带任何参数创建一个标签(tag)指定某个提交(commit):

    $ git tag stable-1 1b2e1d63ff
    
这样，我们可以用stable-1 作为提交(commit) "1b2e1d63ff" 的代称(refer)。

前面这样创建的是一个“轻量级标签"，这种分支通常是从来不移动的。

如果你想为一个标签(tag)添加注释，或是为它添加一个签名(sign it cryptographically),
那么我们就需要创建一个 ”标签对象".


### 标签对象 ###

如果有 "-a", "-s" 或是 "-u <key-id>" 中间的一个命令参数被指定，那么就会创建
一个标签对象，并且需要一个标签消息(tag message). 如果没有"-m <msg>" 或是 
"-F <file>" 这些参数，那么就会启动一个编辑器来让用户输入标签消息(tag message).

译者注：大家觉得这个标签消息是不是提交注释(commit comment)比较像。

当这样的一条命令执行后，一个新的对象被添加到Git对象库中，并且标签引用就指向了
一个标签对象，而不是指向一个提交(commit). 这样做的好处就是：你可以为一个标签
打处签名(sign), 方便你以后来查验这是不是一个正确的提交(commit).

下面是一个创建标签对象的例子:

    $ git tag -a stable-1 1b2e1d63ff
    
标签对象可以指向任何对象，但是在通常情况下是一个提交(commit). (在Linux内核代
码中，第一个标签对象是指向一个树对象(tree),而不是指向一个提交(commit)).

### 签名的标签 ###

如果你配有GPG key,那么你就很容易创建签名的标签.首先你要在你的 _.git/config 或
_~.gitconfig里配好key.

下面是示例:

    [user]
        signingkey = <gpg-key-id>
        
你也可以用命令行来配置:

    $ git config (--global) user.signingkey <gpg-key-id>
    
现在你可以直接用"-s" 参数来创“签名的标签”。

    $ git tag -s stable-1 1b2e1d63ff
    
如果没有在配置文件中配GPG key,你可以用"-u“ 参数直接指定。
    
    $ git tag -u <gpg-key-id> stable-1 1b2e1d63ff