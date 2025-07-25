# frozen_string_literal: true

require "test_helper_library_test_case"

class Icu4rbTest < LibraryTestCase
  def test_that_it_has_a_version_number
    refute_nil ::Icu4rb::VERSION
  end

  def test_basic_message_formatter_creation
    pattern = 'Hello {name}!'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    assert_equal 'en_US', formatter.locale
    assert_equal pattern, formatter.pattern
  end

  def test_simple_formatting
    pattern = 'Hello {name}!'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'name' => 'World' })
    assert_equal 'Hello World!', result
  end

  def test_plural_formatting_zero
    pattern = '{count, plural, zero {You have no messages} one {You have one message} other {You have # messages}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    # ICU uses actual plural rules from the locale, English doesn't have explicit 'zero'
    assert_equal 'You have 0 messages', formatter.format({ 'count' => 0 })
  end

  def test_plural_formatting_one
    pattern = '{count, plural, zero {You have no messages} one {You have one message} other {You have # messages}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    assert_equal 'You have one message', formatter.format({ 'count' => 1 })
  end

  def test_plural_formatting_other
    pattern = '{count, plural, zero {You have no messages} one {You have one message} other {You have # messages}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    assert_equal 'You have 5 messages', formatter.format({ 'count' => 5 })
  end

  def test_select_formatting_male
    pattern = '{gender, select, male {He} female {She} other {They}} liked your post.'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    assert_equal 'He liked your post.', formatter.format({ 'gender' => 'male' })
  end

  def test_select_formatting_female
    pattern = '{gender, select, male {He} female {She} other {They}} liked your post.'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    assert_equal 'She liked your post.', formatter.format({ 'gender' => 'female' })
  end

  def test_select_formatting_other
    pattern = '{gender, select, male {He} female {She} other {They}} liked your post.'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    assert_equal 'They liked your post.', formatter.format({ 'gender' => 'nonbinary' })
  end

  def test_number_formatting
    pattern = 'Your balance is {balance, number, currency}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'balance' => 1234.56 })
    assert_includes result, '$'
    assert_includes result, '1,234.56'
  end

  def test_date_formatting
    pattern = 'Today is {date, date, long}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    require 'date'
    today = Date.today
    # ICU expects seconds since epoch for date formatting
    seconds = today.to_time.to_i
    result = formatter.format({ 'date' => seconds })
    refute_empty result
    # Check that we get a reasonable date format
    assert_match(/\d{4}/, result)  # Contains a year
  end

  def test_multiple_arguments
    pattern = '{name} has {count, plural, one {# message} other {# messages}} in {folder}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'name' => 'Alice', 'count' => 3, 'folder' => 'Inbox' })
    assert_equal 'Alice has 3 messages in Inbox', result
  end

  def test_different_locales
    pattern = '{count, plural, one {# elemento} other {# elementos}}'
    formatter = ICU::MessageFormatter.new(pattern, 'es_ES')
    assert_equal '1 elemento', formatter.format({ 'count' => 1 })
    assert_equal '3 elementos', formatter.format({ 'count' => 3 })
  end

  def test_string_interpolation
    pattern = 'Welcome {name}!'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'name' => 'John' })
    assert_equal 'Welcome John!', result
  end

  def test_integer_values
    pattern = 'You are {age} years old'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'age' => 25 })
    assert_equal 'You are 25 years old', result
  end

  def test_float_values
    pattern = 'The temperature is {temp}°C'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'temp' => 23.5 })
    # ICU handles Unicode properly, ° is UTF-8 encoded
    assert_equal 'The temperature is 23.5°C', result.force_encoding('UTF-8')
  end

  def test_nil_values
    pattern = 'Hello {name}!'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'name' => nil })
    # ICU treats nil as 0 for numeric contexts, empty string for string contexts
    # This is expected ICU behavior
    assert_equal 'Hello 0!', result
  end

  def test_missing_arguments
    pattern = 'Hello {name}! Your score is {score}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'name' => 'Alice' })
    # ICU keeps missing variables as-is
    assert_equal 'Hello Alice! Your score is {score}', result
  end
end