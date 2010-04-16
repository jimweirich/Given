require 'rake/testtask'

namespace :test do
  desc "Run Examples"
  Rake::TestTask.new(:examples) do |t|
    t.test_files = FileList['examples/**/*_test.rb']
    t.libs = %w(lib .)
    t.warning = true
    t.verbose = true
  end

  Rake::TestTask.new(:units) do |t|
    t.verbose = true
    t.warning = true
    t.libs = %w(lib .)
    t.test_files = FileList['test/**/*_test.rb']
  end
end

task :tu => "test:units"
