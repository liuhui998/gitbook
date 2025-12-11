desc 'Merge all of the texttile output into a single file for pdf conversion'

task :merge do
  File.open('output/full_book.markdown', 'w+') do |f|
    Dir["text_zh/**/*.markdown"].sort.each do |path|
      f << File.new(path).read + "\n\n"
    end
  end
end
