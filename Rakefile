# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

# Build task for CMake extension
task :compile do
  Dir.chdir('ext/icu4rb') do
    unless File.directory?('build')
      sh 'mkdir build'
    end
    Dir.chdir('build') do
      sh 'cmake ..'
      sh 'make'
    end
  end
end

# Clean task for extension
task :clean do
  Dir.chdir('ext/icu4rb') do
    if File.directory?('build')
      sh 'rm -rf build'
    end
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[compile test rubocop]
