require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/objection'
  t.test_files = FileList[
    'spec/lib/**/*_spec.rb'
  ]
  t.verbose = true
end

task :default => :test
