# frozen_string_literal: true

require "active_support"
require "active_support/test_case"
require "minitest/autorun"
require "icu4rb"

class LibraryTestCase < ActiveSupport::TestCase
  # Add any common test setup or helper methods here
  
  # Example: helper method to test Unicode string handling
  def assert_unicode_equal(expected, actual, message = nil)
    assert_equal expected, actual, message || "Expected unicode strings to be equal"
  end
  
  # Example: helper for ICU error code testing
  def assert_icu_success(error_code)
    assert_equal 0, error_code, "ICU operation failed with error code: #{error_code}"
  end
end