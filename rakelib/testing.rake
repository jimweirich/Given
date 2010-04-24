require 'rake/testtask'
require 'spec/rake/spectask'

namespace :spec do
  desc "Generate HTML report for failing examples"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_opts = ['--options', 'spec/spec.opts']
    t.spec_files = FileList['spec/**/*.rb']
  end
end

task :spec => "spec:spec"
