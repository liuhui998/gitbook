## 查找问题的利器 - Git Blame ##

如果你要查看文件的每个部分是谁修改的, 那么 linkgit:git-blame[1] 就是不二选择. 只要运行'git blame [filename]', 你就会得到整个文件的每一行的详细修改信息:包括SHA串,日期和作者:

译者注: Git采用SHA1做为hash签名算法, 在本书中,作者为了表达方便,常常使用SHA来代指SHA1. 如果没有特别说明, 本书中的SHA就是SHA1的代称.

	$ git blame sha1_file.c
	...
	0fcfd160 (Linus Torvalds  2005-04-18 13:04:43 -0700    8)  */
	0fcfd160 (Linus Torvalds  2005-04-18 13:04:43 -0700    9) #include "cache.h"
	1f688557 (Junio C Hamano  2005-06-27 03:35:33 -0700   10) #include "delta.h"
	a733cb60 (Linus Torvalds  2005-06-28 14:21:02 -0700   11) #include "pack.h"
	8e440259 (Peter Eriksen   2006-04-02 14:44:09 +0200   12) #include "blob.h"
	8e440259 (Peter Eriksen   2006-04-02 14:44:09 +0200   13) #include "commit.h"
	8e440259 (Peter Eriksen   2006-04-02 14:44:09 +0200   14) #include "tag.h"
	8e440259 (Peter Eriksen   2006-04-02 14:44:09 +0200   15) #include "tree.h"
	f35a6d3b (Linus Torvalds  2007-04-09 21:20:29 -0700   16) #include "refs.h"
	70f5d5d3 (Nicolas Pitre   2008-02-28 00:25:19 -0500   17) #include "pack-revindex.h"628522ec (Junio C Hamano              2007-12-29 02:05:47 -0800   18) #include "sha1-lookup.h"
	...
	
如果文件被修改了(reverted),或是编译(build)失败了; 这个命令就可以大展身手了.


你也可以用"-L"参数在命令(blame)中指定开始和结束行:

	$>git blame -L 160,+10 sha1_file.c 
	ace1534d (Junio C Hamano 2005-05-07 00:38:04 -0700       160)}
	ace1534d (Junio C Hamano 2005-05-07 00:38:04 -0700       161)
	0fcfd160 (Linus Torvalds 2005-04-18 13:04:43 -0700       162)/*
	0fcfd160 (Linus Torvalds 2005-04-18 13:04:43 -0700       163) * NOTE! This returns a statically allocate
	790296fd (Jim Meyering   2008-01-03 15:18:07 +0100       164) * careful about using it. Do an "xstrdup()
	0fcfd160 (Linus Torvalds 2005-04-18 13:04:43 -0700       165) * filename.
	ace1534d (Junio C Hamano 2005-05-07 00:38:04 -0700       166) *
	ace1534d (Junio C Hamano 2005-05-07 00:38:04 -0700       167) * Also note that this returns the location
	ace1534d (Junio C Hamano 2005-05-07 00:38:04 -0700       168) * SHA1 file can happen from any alternate 
	d19938ab (Junio C Hamano 2005-05-09 17:57:56 -0700       169) * DB_ENVIRONMENT environment variable if i
	
