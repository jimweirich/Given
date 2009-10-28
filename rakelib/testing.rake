namespace :test do
  Rake::TestTask.new(:units) do |t|
    t.verbose = false
    t.warning = true
    t.test_files = FileList['test/**/*_test.rb']
  end
end
