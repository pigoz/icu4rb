# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

icu4rb is a Ruby native extension gem that provides bindings to the ICU4C library (International Components for Unicode). This gem will expose ICU's powerful Unicode, internationalization, and localization functionality to Ruby applications.

## Technology Stack

- **Language**: Ruby with C extensions (native extension)
- **Build System**: Rake with Ruby's native extension build process
- **Testing**: Minitest for Ruby tests, C test framework for native code
- **Code Quality**: RuboCop for Ruby linting, C standard linting tools
- **Dependencies**: ICU4C library (system dependency)

## Key Architecture Concepts

### Native Extension Structure
- **Extension Entry Point**: `ext/icu4rb/icu4rb.c` - Main C extension file
- **Ruby API Layer**: `lib/icu4rb/` - Ruby wrapper classes and modules
- **C Headers**: `ext/icu4rb/` - C headers for ICU integration
- **Build Configuration**: `ext/icu4rb/extconf.rb` - Configuration for native compilation

### ICU Integration Patterns
- **Memory Management**: Handle ICU's memory model carefully with Ruby's GC
- **Error Handling**: Convert ICU error codes to Ruby exceptions
- **String Encoding**: Properly handle UTF-8/UTF-16 conversion between Ruby and ICU
- **Thread Safety**: Ensure ICU calls are thread-safe for Ruby's GVL

## Development Commands

### Setup & Run
```bash
# Install dependencies
bundle install

# Setup development environment
bin/setup

# Interactive console with gem loaded
bin/console

# Compile native extension
rake compile
```

### Testing
```bash
# Run all tests
rake test

# Run specific test file
ruby -Itest test/icu4rb_test.rb

# Run with verbose output
rake test TESTOPTS="-v"

# Compile and run tests
rake compile test
```

### Code Quality
```bash
# Ruby linting
rubocop

# Fix auto-correctable Ruby issues
rubocop -A

# C code linting (if available)
clang-format -i ext/**/*.c
```

### Build & Release
```bash
# Compile native extension
rake compile

# Install gem locally
rake install

# Release to RubyGems
rake release
```

### Note on Bundle Exec
Commands should be run without `bundle exec` prefix as the gem environment is properly configured.

## Directory Structure

### Core
- `lib/icu4rb/` - Ruby library code
- `ext/icu4rb/` - C native extension source
- `spec/` - RSpec test files
- `sig/` - RBS type signatures

### Configuration
- `extconf.rb` - Native extension build configuration
- `Rakefile` - Build tasks
- `Gemfile` - Development dependencies
- `icu4rb.gemspec` - Gem specification

## Coding Guidelines

### Code Style & Formatting

- **Line Length**: Enforce a strict maximum of 80 characters per line for all code and comments. Break long lines, such as method chains or argument lists, thoughtfully for readability.

- **Idiomatic Ruby**: Write code that is natural and conventional for the Ruby language.

- **Modern Ruby**: Actively use modern Ruby features. This includes but is not limited to:
  - Shorthand block syntax (`_1`, `_2`, etc.)
  - Endless method definitions where appropriate
  - `case/in` instead of `case/when` for pattern matching
  - The safe navigation operator (`&.`)  
  - Data.define instead of Struct

- **C Extension Guidelines**:
  - Use `rb_define_method` for defining Ruby methods
  - Wrap ICU calls in proper error handling
  - Use `TypedData` for managing C structs in Ruby objects
  - Ensure proper memory cleanup in finalizers

- **Low Cyclomatic Complexity**: Keep methods small and focused
- **Guard Clauses**: Use guard clauses to handle edge cases and invalid conditions at the beginning of a method. Avoid nesting `if/else` statements

- **Memory Management**: Always clean up ICU resources properly. Use RAII patterns in C++ if applicable

### Design & Architecture

- **Skinny Ruby Layer, Fat C Layer**: Keep Ruby wrapper classes minimal, implement complex logic in C
- **Composition over Inheritance**: Use composition patterns when wrapping complex ICU objects
- **Error Handling**: Convert ICU UErrorCode to Ruby exceptions consistently
- **Resource Management**: Implement proper cleanup for ICU resources (collators, break iterators, etc.)

### Testing

- **Use Minitest** for Ruby-level tests
- **Test Coverage**: Aim for 100% coverage of Ruby API layer
- **Integration Tests**: Test against real ICU data files
- **Edge Cases**: Test with various Unicode edge cases (surrogate pairs, combining characters, etc.)
- **Performance Tests**: Benchmark critical paths against pure Ruby implementations
- **Unit Tests**: Inherit from Minitest::Test, follow existing patterns in test/ directory

### Native Extension Guidelines

- **Build Configuration**: Use `have_library` and `find_header` in extconf.rb to ensure ICU availability
- **Platform Support**: Test on Linux, macOS, and Windows
- **ICU Version Compatibility**: Support multiple ICU versions with appropriate fallbacks
- **Thread Safety**: Ensure all C extensions release the GVL for long-running operations
- **Type Safety**: Use proper type checking in C extensions to prevent segfaults

### Common Development Tasks

- **Adding New ICU Features**:
  1. Add C wrapper function in `ext/icu4rb/`
  2. Create Ruby class/method in `lib/icu4rb/`
  3. Add RSpec tests in `spec/`
  4. Update RBS signatures in `sig/`
  5. Add documentation and examples

- **Debugging C Extensions**:
  - Use `puts` debugging in C code during development
  - Use Valgrind to check for memory leaks
  - Use GDB with Ruby for complex debugging
  - Check `mkmf.log` for build issues

- **Cross-Platform Testing**:
  - Test ICU version compatibility
  - Test with different system ICU installations
  - Test with bundled ICU (if implemented)