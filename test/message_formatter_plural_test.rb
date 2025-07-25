# frozen_string_literal: true

require "test_helper_library_test_case"

class MessageFormatterPluralTest < LibraryTestCase
  def setup
    @pattern = '{count, plural, one {You have one message} other {You have # messages}}'
  end

  def test_english_zero
    formatter = ICU::MessageFormatter.new(@pattern, 'en_US')
    assert_equal 'You have 0 messages', formatter.format({ 'count' => 0 })
  end

  def test_english_one
    formatter = ICU::MessageFormatter.new(@pattern, 'en_US')
    assert_equal 'You have one message', formatter.format({ 'count' => 1 })
  end

  def test_english_two
    formatter = ICU::MessageFormatter.new(@pattern, 'en_US')
    assert_equal 'You have 2 messages', formatter.format({ 'count' => 2 })
  end

  def test_english_other
    formatter = ICU::MessageFormatter.new(@pattern, 'en_US')
    assert_equal 'You have 5 messages', formatter.format({ 'count' => 5 })
  end

  def test_russian_one
    pattern = '{count, plural, one {# сообщение} few {# сообщения} many {# сообщений} other {# сообщений}}'
    formatter = ICU::MessageFormatter.new(pattern, 'ru_RU')
    result = formatter.format({ 'count' => 1 })
    assert_match(/1/, result)
    assert_match(/сообщение/, result.force_encoding('UTF-8'))
  end

  def test_russian_few
    pattern = '{count, plural, one {# сообщение} few {# сообщения} many {# сообщений} other {# сообщений}}'
    formatter = ICU::MessageFormatter.new(pattern, 'ru_RU')
    result = formatter.format({ 'count' => 3 })
    assert_match(/3/, result)
    assert_match(/сообщени/, result.force_encoding('UTF-8'))  # Base form
  end

  def test_russian_many
    pattern = '{count, plural, one {# сообщение} few {# сообщения} many {# сообщений} other {# сообщений}}'
    formatter = ICU::MessageFormatter.new(pattern, 'ru_RU')
    result = formatter.format({ 'count' => 11 })
    assert_match(/11/, result)
    assert_match(/сообщени/, result.force_encoding('UTF-8'))  # Base form
  end

  def test_decimal_plurals
    pattern = '{count, plural, one {# item} other {# items}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    assert_equal '1.5 items', formatter.format({ 'count' => 1.5 })
  end
end