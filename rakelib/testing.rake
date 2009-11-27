class Ruby19TestTask < Rake::TestTask
  RUBY = ENV['RUBY'] || 'ruby19x'
  def ruby(*args)
    sh "#{RUBY} #{args.join(' ')}"
  end
end

namespace :test do
  desc "Run Examples"
  Ruby19TestTask.new(:examples) do |t|
    t.test_files = FileList['examples/**/*_test.rb']
    t.libs = %w(lib .)
    t.warning = true
    t.verbose = true
  end

  Ruby19TestTask.new(:units) do |t|
    t.verbose = true
    t.warning = true
    t.libs = %w(lib .)
    t.test_files = FileList['test/**/*_test.rb']
  end
end

task :tu => "test:units"
