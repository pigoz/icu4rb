# frozen_string_literal: true

require "test_helper_library_test_case"

class MessageFormatterNumberTest < LibraryTestCase
  def test_basic_number_formatting
    pattern = 'Your score is {score}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    assert_equal 'Your score is 42', formatter.format({ 'score' => 42 })
  end

  def test_currency_formatting_usd
    pattern = 'Price: {price, number, currency}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'price' => 29.99 })
    assert_includes result, '$29.99'
  end

  def test_currency_formatting_eur
    pattern = 'Price: {price, number, currency}'
    formatter = ICU::MessageFormatter.new(pattern, 'de_DE')
    result = formatter.format({ 'price' => 29.99 })
    assert_includes result, '29,99'
    assert_includes result, '€'
  end

  def test_percent_formatting
    pattern = 'Progress: {progress, number, percent}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'progress' => 0.85 })
    assert_includes result, '85%'
  end

  def test_integer_formatting
    pattern = 'Count: {count, number, integer}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'count' => 1234.56 })
    assert_includes result, '1,235'
  end

  def test_decimal_formatting
    pattern = 'Value: {value, number, .00}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'value' => 3.14159 })
    assert_includes result, '3.14'
  end

  def test_large_numbers
    pattern = 'Population: {population, number}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'population' => 1_234_567_890 })
    assert_includes result, '1,234,567,890'
  end

  def test_negative_numbers
    pattern = 'Balance: {balance, number, currency}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'balance' => -50.25 })
    assert_includes result, '-$50.25'
  end

  def test_scientific_notation
    pattern = 'Large number: {number, number, scientific}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'number' => 1234567 })
    assert_match /1[,.]234567E[+-]?>?3/, result
  end
end