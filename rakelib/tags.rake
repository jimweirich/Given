#!/usr/bin/env ruby

module Tags
  PROG = ENV['TAGS'] || '/usr/local/bin/xctags' || 'ctags'
  RUBY_FILES = FileList['**/*.rb']
  RUBY_FILES.include('**/*.rake')
  RUBY_FILES.include('/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/test/**/*.rb')
end

namespace "tags" do
  desc "Generate an Emacs TAGS file"
  task :emacs => Tags::RUBY_FILES do
    puts "Making Emacs TAGS file"
    verbose(false) do
      sh "#{Tags::PROG} -e #{Tags::RUBY_FILES}"
    end
  end
end

desc "Generate the TAGS file"
task :tags => ["tags:emacs"]
