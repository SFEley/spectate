require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "spectate"
    gem.summary = %Q{General event framework for testing and monitoring}
    gem.email = "sfeley@gmail.com"
    gem.homepage = "http://github.com/SFEley/spectate"
    gem.authors = ["Stephen Eley"]
    gem.rubyforge_project = "spectate"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    
    # ADDED BY SFE 
    gem.requirements << "Tokyo Cabinet (easily installed from apt, MacPorts, etc.)"
    gem.add_development_dependency "rspec", ">= 1.2.6"
    gem.add_development_dependency "mocha", ">= 0.9.5"
    gem.add_runtime_dependency "rufus-tokyo", ">=0.1.12"
  end

  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "spectate #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

