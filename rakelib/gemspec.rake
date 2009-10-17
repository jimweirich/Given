require 'rake/gempackagetask'
require 'lib/given/version'

if ! defined?(Gem)
  puts "Package Target requires RubyGEMs"
else
  PKG_FILES = FileList[
    '[A-Z]*',
    'lib/**/*.rb', 
    'test/**/*.rb',
    'examples/**/*',
    'doc/**/*',
  ]
  PKG_FILES.exclude('TAGS')
  
  SPEC = Gem::Specification.new do |s|
    
    #### Basic information.

    s.name = 'given'
    s.version = Given::VERSION
    s.summary = "Given/When/Then Specification Framework."
    s.description = <<EOF
Given is a specification framework that allows explicit definition of the
pre and post-conditions for code under test.  Given is an alternative
to the traditional RSpec and Test::Unit frameworks.
EOF
    s.files = PKG_FILES.to_a
    s.require_path = 'lib'                         # Use these for libraries.
    s.has_rdoc = true
#    s.extra_rdoc_files = rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a
    s.rdoc_options = [
      '--line-numbers', '--inline-source',
      '--main' , 'README.rdoc',
      '--title', 'Rake -- Ruby Make'
    ]

    s.author = "Jim Weirich"
    s.email = "jim.weirich@gmail.com"
    s.homepage = "http://github.com/jimweirich/Given"
    s.rubyforge_project = "given"
  end

  package_task = Rake::GemPackageTask.new(SPEC) do |pkg|
    pkg.need_zip = true
    pkg.need_tar = true
  end

  file "rake.gemspec" => ["rakelib/gemspec.rake"] do |t|
    require 'yaml'
    open(t.name, "w") { |f| f.puts SPEC.to_yaml }
  end

  desc "Create a stand-alone gemspec"
  task :gemspec => "given.gemspec"
end
