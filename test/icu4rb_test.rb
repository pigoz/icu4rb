# frozen_string_literal: true

require "test_helper_library_test_case"

class Icu4rbTest < LibraryTestCase
  def test_that_it_has_a_version_number
    refute_nil ::Icu4rb::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
end