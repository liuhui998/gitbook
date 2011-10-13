## Git树名 ##

不用40个字节长的SHA串来表示一个提交(commit)或是其它git对象, 有很多种名字表示方法.　在Git里,这些名字就叫'树名'(treeish).

译者注:我目前没有想到更好的中文名字,就先叫'树名'.
 
### Sha短名 ###

如果你的一个提交(commit)的sha名字是 '<code>980e3ccdaac54a0d4de358f3fe5d718027d96aae</code>', git会把下面的串视为等价的:

	980e3ccdaac54a0d4de358f3fe5d718027d96aae
	980e3ccdaac54a0d4
	980e3cc

只要你的‘sha短名’(Partial Sha)是不重复的(unique)，它就不会和其它名字冲突(如果你使用了5个字节以上那是很难重复的)，git也会把‘sha短名’(Partial Sha)自动补全.


### 分支, Remote 或 标签 ###

你可以使用分支,remote或标签名来代替SHA串名, 它们只是指向某个对象的指针. 假设你的master分支目前在提交(commit):'980e3'上, 现在把它推送(push)到origin上并把它命名为标签'v1.0', 那么下面的串都会被git视为等价的:

	980e3ccdaac54a0d4de358f3fe5d718027d96aae
	origin/master
	refs/remotes/origin/master
	master
	refs/heads/master
	v1.0
	refs/tags/v1.0
	
这意味着你执行下面的两条命令会有同样的输出:

	$ git log master
	
	$ git log refs/tags/v1.0
	

### 日期标识符 ###

The Ref Log that git keeps will allow you to do some relative stuff locally, 
such as: 

Git的引用日志(Ref Log)可以让你做一些‘相对'查询操作:

	master@{yesterday}

	master@{1 month ago}
	
上面的第一条命令是:'master分支的昨天状态(head)的缩写‘. 注意: 即使在两个有相同master分支指向的仓库上执行这条命令, 但是如果这个两个仓库在不同机器上,　那么执行结果也很可能会不一样.

译者注:因为两个不同机器上的仓库的历史一般很难相同.


### 顺序标识符 ###

这种格式用来表达某点前面的第N个提交(ref).

	master@{5}

上面的表达式代表着master前面的第5个提交(ref).
	

### 多个父对象 ###

这能告诉你某个提交的第N个直接父提交(parent). 这种格式在合并提交(merge commits)时特别有用, 这样就可以使提交对象(commit object)有多于一个直接父对象(direct parent).

译者注:假设master是由a和b两个分支合并的,那么 `master^1` 是指分支a, `master^2` 就是指分支b.

	master^2
	
	
### 波浪号 ###

波浪号用来标识一个提交对象(commit object)的第N级嫡(祖)父对象(Nth grandparent). 例如:

	master~2
	
就代表master所指向的提交对象的第一个父对象的第一个父对象(译者:你可以理解成是嫡系爷爷:)). 它和下面的这个表达式是等价的:

	master^^

你也可以把这些‘标识符'(spec)叠加起来, 下面这个3个表达式都是指向同一个提交(commit):

	master^^^^^^
	master~3^~2
	master~6


### 树对象指针 ###

如果大家对第一章[Git对象模型](http://gitbook.liuhui998.com/1_2.html)还有印象的话, 就记得提交对象(commit object)是指向一个树对象(tree object)的. 假如你要得到一个提交对象(commit object)指向的树对象(tree object)的sha串名, 你就可以在‘树名'的后面加上'^{tree}'来得到它:

	master^{tree}


### 二进制标识符 ###

如果你要某个二次制对象(blob)的sha串名,你可以在'树名'(treeish)后添加二次制对象(blob)对应的文件路径来得到它.
 
	master:/path/to/file


### 区间 ###

最后, 你可以用".."来指两个提交(commit)之间的区间. 下面的命令会给出你在"7b593b5" 和"51bea1"之间除了"7b593b5外"的所有提交(commit)(注意:51bea1是最近的提交).


	7b593b5..51bea1

这会包括所有 *从* 7b593b开始的提交(commit).
译者注: 相当于 7b593b..HEAD

	7b593b.. 
	
	