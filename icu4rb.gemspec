# frozen_string_literal: true

require_relative "lib/icu4rb/version"

Gem::Specification.new do |spec|
  spec.name = "icu4rb"
  spec.version = Icu4rb::VERSION
  spec.authors = ["Stefano Pigozzi"]
  spec.email = ["stefano.pigozzi@gmail.com"]

  spec.summary = "Ruby bindings for ICU4C with MessageFormat support"
  spec.description = "A Ruby native extension that provides bindings to the ICU4C library, focusing on MessageFormat API for internationalization and localization"
  spec.homepage = "https://github.com/stefanopigozzi/icu4rb"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pigoz/icu4rb"
  spec.metadata["changelog_uri"] = "https://github.com/pigoz/icu4rb/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.extensions = ["ext/icu4rb/CMakeLists.txt"]

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
