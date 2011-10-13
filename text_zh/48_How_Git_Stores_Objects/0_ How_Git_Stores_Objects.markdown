## Git是如何存储对象的 ##

这一章会详细讲解Git如何物理存储各对象.

所有的对象都以SHA值为索引用gzip格式压缩存储, 每个对象都包含了对象类型, 大小和内容.

Git中存在两种对象 - 松散对象(loose object)和打包对象(packed object).

### 松散对象 ###

松散对象是一种比较简单格式. 它就是磁盘上的一个存储压缩数据的文件. 每一个对象都被写入一个单独文件中.

如果你对象的SHA值是<code>ab04d884140f7b0cf8bbf86d6883869f16a46f65</code>, 那么对应的文件会被存储在:

	GIT_DIR/objects/ab/04d884140f7b0cf8bbf86d6883869f16a46f65

Git使用SHA值的前两个字符作为子目录名字, 所以一个目录中永远不会包含过多的对象. 文件名则是余下的38个字符.

可以用下面的Ruby代码说明对象数据是如何存储的:

	ruby
	def put_raw_object(content, type)
	  size = content.length.to_s

	  header = "#{type} #{size}\\0" # type(space)size(null byte)
	  store = header + content

	  sha1 = Digest::SHA1.hexdigest(store)
	  path = @git_dir + '/' + sha1[0...2] + '/' + sha1[2..40]

	  if !File.exists?(path)
	    content = Zlib::Deflate.deflate(store)

	    FileUtils.mkdir_p(@directory+'/'+sha1[0...2])
	    File.open(path, 'w') do |f|
	      f.write content
	    end
	  end
	  return sha1
	end

### 打包对象 ###

另外一种对象存储方式是使用打包文件(packfile). 由于Git把每个文件的每个版本都作为一个单独的对象, 它的效率可能会十分的低. 设想一下在一个数千行的文件中改动一行, Git会把修改后的文件整个存储下来, 很浪费空间.

Git使用打包文件(packfile)去节省空间. 在这个格式中, Git只会保存第二个文件中改变了的部分, 然后用一个指针指向相似的那个文件(译注: 即第一个文件).

对象通常是以松散格式写到磁盘上, 因为这个格式的访问代价比较低. 然后, 你最终会需要把对象存放到打包格式中去节省磁盘空间 - 这个工作可以通过linkgit:git-gc[1]来完成. 它使用一个相当复杂的启发式算法去决定哪些文件是最相似的, 然后基于此分析去计算差异. 可以存在多个打包文件, 在必要情况下, 它们可被解包(linkgit:git-unpack-objects[1])成为松散对象或者重新打包(linkgit:git-repack[1]).

Git会为每一个打包文件创建一个较小的索引文件. 索引文件中包含了对象在打包文件中的偏移, 以便于通过SHA值来快速找到特定的对象.

打包文件的实现细节会在稍后的"打包文件"(Packfile)一章中讲述.


