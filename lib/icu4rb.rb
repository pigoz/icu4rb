# frozen_string_literal: true

require_relative "icu4rb/version"

# Load the native extension
begin
  require_relative "icu4rb/icu4rb"
rescue LoadError => e
  raise LoadError, "Failed to load native extension: #{e.message}"
end

module Icu4rb
  class Error < StandardError; end
  
  # The ICU module is defined in the native extension
  # This provides the MessageFormatter class
end
