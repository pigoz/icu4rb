# frozen_string_literal: true

require "test_helper_library_test_case"

class MessageFormatterSelectTest < LibraryTestCase
  def test_simple_select
    pattern = '{gender, select, male {He} female {She} other {They}} liked your post.'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    
    assert_equal 'He liked your post.', formatter.format({ 'gender' => 'male' })
    assert_equal 'She liked your post.', formatter.format({ 'gender' => 'female' })
    assert_equal 'They liked your post.', formatter.format({ 'gender' => 'nonbinary' })
  end

  def test_nested_select
    pattern = '{gender, select, male {He} female {She} other {They}} liked it'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    
    assert_equal 'He liked it', formatter.format({ 'gender' => 'male' })
    assert_equal 'She liked it', formatter.format({ 'gender' => 'female' })
    assert_equal 'They liked it', formatter.format({ 'gender' => 'other' })
  end

  def test_combined_select_and_plural
    pattern = '{name}: {count, plural, one {one message} other {# messages}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    
    assert_equal 'Alice: one message', formatter.format({ 'name' => 'Alice', 'count' => 1 })
    assert_equal 'Bob: 5 messages', formatter.format({ 'name' => 'Bob', 'count' => 5 })
  end

  def test_select_with_simple_keys
    pattern = '{status, select, active {Active} inactive {Inactive} other {Unknown}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    
    assert_equal 'Active', formatter.format({ 'status' => 'active' })
    assert_equal 'Inactive', formatter.format({ 'status' => 'inactive' })
  end

  def test_select_with_types
    pattern = '{type, select, a {Type A} b {Type B} c {Type C} other {Unknown}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    
    assert_equal 'Type A', formatter.format({ 'type' => 'a' })
    assert_equal 'Type B', formatter.format({ 'type' => 'b' })
    assert_equal 'Type C', formatter.format({ 'type' => 'c' })
  end
end