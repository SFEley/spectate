# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{spectate}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Eley"]
  s.date = %q{2009-05-31}
  s.default_executable = %q{spectate}
  s.email = %q{sfeley@gmail.com}
  s.executables = ["spectate"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/spectate",
     "features/command.feature",
     "features/step_definitions/command_steps.rb",
     "features/step_definitions/spectate_steps.rb",
     "features/support/env.rb",
     "lib/spectate.rb",
     "lib/spectate/command.rb",
     "spec/command_spec.rb",
     "spec/spec_helper.rb",
     "spec/spectate_spec.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/SFEley/spectate}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.requirements = ["Tokyo Cabinet (easily installed from apt, MacPorts, etc.)"]
  s.rubyforge_project = %q{spectate}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{General event framework for testing and monitoring}
  s.test_files = [
    "spec/command_spec.rb",
     "spec/config_spec.rb",
     "spec/spec_helper.rb",
     "spec/spectate_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.6"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.5"])
      s.add_runtime_dependency(%q<rufus-tokyo>, [">= 0.1.12"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.6"])
      s.add_dependency(%q<mocha>, [">= 0.9.5"])
      s.add_dependency(%q<rufus-tokyo>, [">= 0.1.12"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.6"])
    s.add_dependency(%q<mocha>, [">= 0.9.5"])
    s.add_dependency(%q<rufus-tokyo>, [">= 0.1.12"])
  end
end
