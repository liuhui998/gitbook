## Git Hooks ##

钩子(hooks)是一些在`$GIT-DIR/hooks`目录的脚本, 在被特定的事件(certain points)触发后被调用。当`git init`命令被调用后, 一些非常有用的示例钩子脚本被拷到新仓库的hooks目录中; 但是在默认情况下它们是不生效的。 把这些钩子文件的".sample"文件名后缀去掉就可以使它们生效。

### applypatch-msg ###

    GIT_DIR/hooks/applypatch-msg
    
这个钩子是由`git am`命令调用的。它只有一个参数：就是存有将要被应用的补丁(patch)的提交消息(commit log message)的文件名。如果钩子的返回值不是`0`，那么`git am`就会放弃对补丁的应用(apply the patch)。


这个钩子可以在工作时（译注:也就是在`git am`运行时）编辑提交(commit)信息文件(message file)。它的一个用途是把提交(commit)信息规范化，使得其符合一些项目的标准（如果有的话）。它也可以用来在分析(inspect)完消息文件后拒绝某个提交(commit)。


如果默认的`applypatch-msg.sample`钩子被启用，它会调用`commit-msg`钩子（如果它也被启用的话）。


### pre-applypatch ###

    GIT_DIR/hooks/pre-applypatch

这个钩子是由`git am`命令调用的。它不需要参数，并且是在一个补丁(patch)被应用后还未提交(commit)前被调用。如果钩子的返回值不是`0``，那么刚才应用的补丁(patch)就不会被提交。


它可以用于检查当前的工作树（译注：此时补丁已经被应用但没有被提交），如果补丁不能通过测试就拒绝此次提交(commit)。


如果默认的`pre-applypatch.sample`钩子被启用，它会调用`pre-commit`钩子（如果它也被启用的话）。

### post-applypatch ###

    GIT_DIR/hooks/post-applypatch
    

这个钩子是由`git am`命令调用的。它不需要参数，并且是在一个补丁(patch)被应用且在完成提交(commit)情况下被调用。


这个钩子主要用来通知(notification)，它并不会影响`git-am`的执行结果。

### pre-commit ###
 	
    GIT_DIR/hooks/pre-commit

这个钩子被 `git commit` 命令调用, 而且可以通过在命令中添加`\--no-verify` 参数来跳过。这个钩子不需要参数，在得到提交消息和开始提交(commit)前被调用。如果钩子返回值不是`0`，那么 `git commit` 命令就会中止执行。

译注：这个钩子可以用来在提交前检查代码错误（例如运行lint程序）。

当默认的`pre-commit`钩子被启用时，如果它发现文件尾部有空白行，那么就会中止此次提交。

译注：新版的默认钩子和这里所说有所有不同。

如果（进行`git commit`的）命令没有制定一个编辑器来修改提交信息(commit message)，任何的 `git-commit` 钩子（译注：即无论是否自带）被调用时都会带上环境变量`GIT_EDITOR=:`


下面是一个运行 Rspec 测试的 Ruby 脚本，如果没有通过这个测试，那么不允许提交(commit)。

```ruby
html_path = "spec_results.html"
`spec -f h:#{html_path} -f p spec` # run the spec. send progress to screen. save html results to html_path

# find out how many errors were found
html = open(html_path).read
examples = html.match(/(\d+) examples/)[0].to_i rescue 0
failures = html.match(/(\d+) failures/)[0].to_i rescue 0
pending = html.match(/(\d+) pending/)[0].to_i rescue 0

if failures.zero?
  puts "0 failures! #{examples} run, #{pending} pending"
else
  puts "\aDID NOT COMMIT YOUR FILES!"
  puts "View spec results at #{File.expand_path(html_path)}"
  puts
  puts "#{failures} failures! #{examples} run, #{pending} pending"
  exit 1
end
```

    
### prepare-commit-msg ###

    GIT_DIR/hooks/prepare-commit-msg

执行`git commit`命令后，在默认提交消息准备好后但编辑器(editor)启动前，这个钩子就被调用。

It takes one to three parameters.  The first is the name of the file


它接受一到三个参数。第一个包含了提交消息的文本文件的名字。第二个是提交消息的来源，它可以是：
* `message`（如果指定了`-m`或者`-F`选项）
* `template`（如果指定了`-t`选项，或者在设置（译注：即`git config`）中开启了`commit.template`选项）
* `merge`（如果本次提交(commit)是一次合并(merge)，或者存在文件`.git/MERGE_MSG`）
* `squash`（如果存在文件`.git/SQUASH_MSG`）
* `commit` 并且第三个参数是一个提交(commit)的SHA1值（如果指定了`-c`,`-C`或者`\--amend`选项）


如果钩子的返回值不是`0`，那么`git commit`命令就会被中止执行。


这个钩子的目的是用来在工作时编辑信息文件，并且不会被`\--no-verify`选项略过。一个非`0`值意味着钩子工作失败，会终止提交(abort the commit)。它不应该用来作为`pre-commit`钩子的替代。


git提供的样本`prepare-commit-msg.sample`会把当前合并提交信息(a merge's commit message)中的`Conflicts:`部分注释掉。 


**Harry-Chen 校对至此**

### commit-msg ###

    GIT_DIR/hooks/commit-msg

当'git-commit'命令执行时，这个钩子被调用；也可以在命令中添加`\--no-verify`参数来跳过。这个钩子有一个参数：就是被选定的提交消息文件的名字。如这个钩子的执行結果是非零，那么'git-commit'命令就会中止执行。

The hook is allowed to edit the message file in place, and can
be used to normalize the message into some project standard
format (if the project has one). It can also be used to refuse
the commit after inspecting the message file.

这个钩子的是为提交消息更适当，可以用于规范提交消息使之符合项目的标准(如果有的话)；如果它检查完提交消息后，发现内容不符合某些标准，它也可以拒绝此次提交(commit)。

The default 'commit-msg' hook, when enabled, detects duplicate
"Signed-off-by" lines, and aborts the commit if one is found.

默认的'commit-msg'钩子启用后，它后检查里面是否有重复的签名结束线(Signed-off-by lines)，如果找到它就是中止此次提交(commit)操作。

### post-commit ###

    GIT_DIR/hooks/post-commit

当'git-commit'命令执行时，这个钩子就被调用。它没有参数，并且是在一个提交(commit)完成时被调用。

这个钩子的主要用途是通知提示(notification)，它并不会影响'git-commit'的执行和输出。

### pre-rebase ###

    GIT_DIR/hooks/pre-rebase

当'git-base'命令执行时，这个钩子就被调用；主要目的是阻止那不应被rebase的分支被rebase(例如，一个已经发布的分支提交就不应被rebase)。


### post-checkout ###

    GIT_DIR/hooks/post-checkout

当'git-checkout'命令更新完整个工作树(worktree)后，这个钩子就会被调用。这个钩子有三个参数：前一个HEAD的 ref，新HEAD的 ref，判断一个签出是分支签出还是文件签出的标识符(分支签出＝1，文件签出＝0)。这个钩子不会影响'git-checkout'命令的输出。

这个钩子可以用于检查仓库的一致性，自动显示签出前后的代码的区别，也可以用于设置目录的元数据属性。

### post-merge ###

    GIT_DIR/hooks/post-merge

This hook is invoked by 'git-merge', which happens when a 'git-pull'
is done on a local repository.  The hook takes a single parameter, a status
flag specifying whether or not the merge being done was a squash merge.
This hook cannot affect the outcome of 'git-merge' and is not executed,
if the merge failed due to conflicts.

它有一个参数：

This hook can be used in conjunction with a corresponding pre-commit hook to
save and restore any form of metadata associated with the working tree
(eg: permissions/ownership, ACLS, etc).  See contrib/hooks/setgitperms.perl
for an example of how to do this.


### pre-receive ###

    GIT_DIR/hooks/pre-receive

This hook is invoked by 'git-receive-pack' on the remote repository,
which happens when a 'git-push' is done on a local repository.
Just before starting to update refs on the remote repository, the
pre-receive hook is invoked.  Its exit status determines the success
or failure of the update.

当用户在本地仓库执行'git-push'命令时，服务器上运端仓库就会对应执行'git-receive-pack'命令，而'git-receive-pack'命令会调用 pre-receive 钩子。在开始更新远程仓库上的ref之前，这个钩子被调用。钩子的执行结果(exit status)决定此次更新能否成功。

This hook executes once for the receive operation. It takes no
arguments, but for each ref to be updated it receives on standard
input a line of the format:

每执行一个接收(receive)操作都会调用一次这个钩子。它没有命令行参数，但是它会从标准输入(standard input)读取需要更新的ref，格式如下：

```
<old-value> SP <new-value> SP <ref-name> LF
```

译者注：SP是空格，LF是回车。

where `<old-value>` is the old object name stored in the ref,
`<new-value>` is the new object name to be stored in the ref and
`<ref-name>` is the full name of the ref.
When creating a new ref, `<old-value>` is 40 `0`.

`<old-value>`是保存在ref里的老对象的名字，`<new-value>`是保存在ref里的新对象的名字，`<ref-name>`就是此次要更新的ref的全名。如果是创建一个新的ref，那么`<old-value>`就是由40个`0`组成的字符串表示。

If the hook exits with non-zero status, none of the refs will be
updated. If the hook exits with zero, updating of individual refs can
still be prevented by the <<update,'update'>> hook.

如果钩子的执行结果是非零，那么没有引用(ref)会被更新。如果执行结果为零，更新操作还可以被后面的 <<update,'update'>> 钩子所阻止。

Both standard output and standard error output are forwarded to
'git-send-pack' on the other end, so you can simply `echo` messages
for the user.

钩子(hook)的标准输出和标准错误输出(stdout & stderr)都会通'git-send-pack'转发给客户端(other end)，你可以把这个信息回显(echo)给用户。

If you wrote it in Ruby, you might get the args this way:

如果你用ruby,那么可以像下面的代码一样得到它们的参数。

```ruby
rev_old, rev_new, ref = STDIN.read.split(" ")
```

Or in a bash script, something like this would work:

在bash脚本中，下面代码也可能得到参数。

```bash
#!/bin/sh
# <oldrev> <newrev> <refname>
# update a blame tree
while read oldrev newrev ref
do
	echo "STARTING [$oldrev $newrev $ref]"
	for path in `git diff-tree -r $oldrev..$newrev | awk '{print $6}'`
	do
	  echo "git update-ref refs/blametree/$ref/$path $newrev"
	  `git update-ref refs/blametree/$ref/$path $newrev`
	done
done
```

    
### update ###

    GIT_DIR/hooks/update

当用户在本地仓库执行'git-push'命令时，服务器上运端仓库就会对应执行'git-receive-pack'，而'git-receive-pack'会调用 update 钩子。在更新远程仓库上的ref之前，这个钩子被调用。钩子的执行结果(exit status)决定此次update能否成功。

每更新一个引用(ref)，钩子就会被调用一次，并且使用三个参数:

 - the name of the ref being updated, # 要被更的ref的名字
 - the old object name stored in the ref, # ref 中更新前的对象名
 - and the new objectname to be stored in the ref. # ref 中更新后的对象名

如果 update hook 的执行结果是零，那么引用(ref)就会被更新。如果执行结果是非零，那么’git-receive-pack'就不会更新这个引用(ref)。

This hook can be used to prevent 'forced' update on certain refs by
making sure that the object name is a commit object that is a
descendant of the commit object named by the old object name.
That is, to enforce a "fast forward only" policy.

这个钩子也可以用于防止强制更新某些 refs，确保old object是new object的父对象。这样也就是强制执行"fast forward only"策略。

It could also be used to log the old..new status.  However, it
does not know the entire set of branches, so it would end up
firing one e-mail per ref when used naively, though.  The
<<post-receive,'post-receive'>> hook is more suited to that.

它也可以用于跟踪(log)更新详情。但是由于它不知道每次更新的ref全体集合，尽管可以傻傻的每个ref更新就发送email；但是<<post-receive,'post-receive'>>钩子更适合这种情况。

在邮件列表(mailing list)上讲了另外一种用法：用这个 update hook 实现细粒度(finer grained)权限控制。

钩子(hook)的标准输出和标准错误输出(stdout & stderr)都会通'git-send-pack'转发给客户端(other end)，你可以把这个信息回显(echo)给用户。

当默认的 update hook 被启用，且`hooks.allowunannotated`选项被打开时，那么没有注释(unannotated)的标签就不能被推送到服务器上。

### post-receive ###

    GIT_DIR/hooks/post-receive
    
This hook is invoked by 'git-receive-pack' on the remote repository,
which happens when a 'git-push' is done on a local repository.
It executes on the remote repository once after all the refs have
been updated.

当用户在本地仓库执行'git-push'命令时，服务器上运端仓库就会对应执行'git-receive-pack'命令；在所有远程仓库的引用(ref)都更新后，这个钩子就会被'git-receive-pack'调用。

This hook executes once for the receive operation.  It takes no
arguments, but gets the same information as the
<<pre-receive,'pre-receive'>>
hook does on its standard input.

服务器端仓库每次执行接收(receive)操作时，这个钩子就会被调用。此钩子执行不带任何命令行参数，但是和<<pre-receive,'pre-receive'>>钩子一样从标准输入(standard input)读取信息，并且读取的信息内容也是一样的。

This hook does not affect the outcome of 'git-receive-pack', as it
is called after the real work is done.

这个钩子不会影响'git-receive-pack'命令的输出，因为它是在命令执行完后被调用的。

This supersedes the <<post-update,'post-update'>> hook in that it gets
both old and new values of all the refs in addition to their
names.

这个钩子可以取代 <<post-update,'post-update'>>钩子；因为后者只能得到需要更新的ref的名字，而没有更新前后的对象的名字。

Both standard output and standard error output are forwarded to
'git-send-pack' on the other end, so you can simply `echo` messages
for the user.

钩子(hook)的标准输出和标准错误输出(stdout & stderr)都会通'git-send-pack'转发给客户端(other end)，你可以把这个信息回显(echo)给用户。
					  
The default 'post-receive' hook is empty, but there is
a sample script `post-receive-email` provided in the `contrib/hooks`
directory in git distribution, which implements sending commit
emails.

默认的'post-receive'的钩子是空的，但是在git distribution `contrib/hooks` 目录里有一个名为 `post-receive-email` 的示例脚本，实实了发送commit emails的功能。


### post-update ###

    GIT_DIR/hooks/post-update
    
This hook is invoked by 'git-receive-pack' on the remote repository,
which happens when a 'git-push' is done on a local repository.
It executes on the remote repository once after all the refs have
been updated.

当用户在本地仓库执行'git-push'命令时，服务器上运端仓库就会对应执行'git-receive-pack'。在所有远程仓库的引用(ref)都更新后，post-update 就会被调用。

It takes a variable number of parameters, each of which is the
name of ref that was actually updated.

它的参数数目是可变的，每个参数代表实际被更新的 ref。

This hook is meant primarily for notification, and cannot affect
the outcome of 'git-receive-pack'.

这个钩子的主要用途是通知提示(notification)，它并不会影响'git-receive-pack'的输出。

The 'post-update' hook can tell what are the heads that were pushed,
but it does not know what their original and updated values are,
so it is a poor place to do log old..new. The
<<post-receive,'post-receive'>> hook does get both original and
updated values of the refs. You might consider it instead if you need
them.

'post-update'可以行诉我们哪些 heads 被更新了，但是它不知道head更新前后的值，所以这里不大适合记录更新详情。而<<post-receive,'post-receive'>>钩子可以得到ref(也可说是head)更新前后的值，如果你要记录更详情的话，可以考虑使用这个钩子。

When enabled, the default 'post-update' hook runs
'git-update-server-info' to keep the information used by dumb
transports (e.g., HTTP) up-to-date.  If you are publishing
a git repository that is accessible via HTTP, you should
probably enable this hook.

如果默认的'post-update'钩子启用的话，它们执行‘git-update-server-info'命令去更新一些dumb协议(如http)所需要的信息。如果你的git仓库是通http协议来访问，那么你就应该开启它。

Both standard output and standard error output are forwarded to
'git-send-pack' on the other end, so you can simply `echo` messages
for the user.

钩子(hook)的标准输出和标准错误输出(stdout & stderr)都会通'git-send-pack'转发给客户端(other end)，你可以把这个信息回显(echo)给用户。

### pre-auto-gc ###

    GIT_DIR/hooks/pre-auto-gc

当调用'git-gc --auto'命令时，这个钩子(hook)就会被调用。它没有调用参数，如果钩子的执行結果是非零的话，那么'git-gc --auto'命令就会中止执行。


### 参考 ###

[Git Hooks](https://www.kernel.org/pub/software/scm/git/docs/githooks.html) * https://probablycorey.wordpress.com/2008/03/07/git-hooks-make-me-giddy/
