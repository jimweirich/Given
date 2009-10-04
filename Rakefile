require 'rake/clean'
require 'rake/testtask'

CLOBBER.include("html")

task :default => :test

Rake::TestTask.new do |t|
  t.verbose = true
  t.warning = true
  t.test_files = FileList['test/**/*_test.rb']
end

require 'redcloth'

directory 'html'

desc "Display the README file"
task :readme => "html/README.html" do
  sh "open html/README.html"
end

desc "format the README file"
task "html/README.html" => ['html', 'README.textile'] do
  open("README.textile") do |source|
    open('html/README.html', 'w') do |out|
      out.write(RedCloth.new(source.read).to_html)
    end
  end
end
