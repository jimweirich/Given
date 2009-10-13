namespace :test do
  Rake::TestTask.new(:units) do |t|
    t.verbose = false
    t.warning = true
    t.test_files = FileList['test/given/**/*_contract.rb']
  end
  
  Rake::TestTask.new(:functionals) do |t|
    t.verbose = false
    t.warning = true
    t.test_files = FileList['test/functional/**/*_test.rb']
  end
end
