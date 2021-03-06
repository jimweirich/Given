require 'rake/clean'

CLOBBER.include("coverage")

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new do |t|
    t.libs << "test"
    dot_rakes = 
    t.rcov_opts = [
      '-xRakefile', '-xrakefile', '-xpublish.rf',
      '-xlib/rake/contrib', '-x/Library', 
      '--text-report',
      '--sort coverage'
    ] + FileList['rakelib/*.rake'].pathmap("-x%p")
    t.test_files = FileList[
      'test/functional/*_test.rb',
      'test/given/*_contract.rb',
    ]
    t.output_dir = 'coverage'
    t.verbose = true
  end
rescue LoadError
  puts "RCov is not available"
end
