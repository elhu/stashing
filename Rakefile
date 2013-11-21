require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

# Defining spec task for running spec
desc "Run specs"
RSpec::Core::RakeTask.new('spec') do |spec|
  # Pattern filr for spec files to run. This is default btw.
  spec.pattern = "./spec/**/*_spec.rb"
end
