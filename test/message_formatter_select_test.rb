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
    pattern = '{gender, select, male {He is} female {She is} other {They are}} {role, select, admin {an admin} user {a user} guest {a guest}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    
    assert_equal 'He is an admin', formatter.format({ 'gender' => 'male', 'role' => 'admin' })
    assert_equal 'She is a user', formatter.format({ 'gender' => 'female', 'role' => 'user' })
    assert_equal 'They are a guest', formatter.format({ 'gender' => 'other', 'role' => 'guest' })
  end

  def test_combined_select_and_plural
    pattern = '{name} {gender, select, male {has} female {has} other {have}} {count, plural, one {one message} other {# messages}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    
    assert_equal 'Alice has one message', formatter.format({ 'name' => 'Alice', 'gender' => 'female', 'count' => 1 })
    assert_equal 'Bob has 5 messages', formatter.format({ 'name' => 'Bob', 'gender' => 'male', 'count' => 5 })
    assert_equal 'Alex have 3 messages', formatter.format({ 'name' => 'Alex', 'gender' => 'nonbinary', 'count' => 3 })
  end

  def test_select_with_underscores
    pattern = '{status, select, inprogress {In Progress} completed {Completed} pending {Pending}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    
    assert_equal 'In Progress', formatter.format({ 'status' => 'inprogress' })
    assert_equal 'Completed', formatter.format({ 'status' => 'completed' })
    assert_equal 'Pending', formatter.format({ 'status' => 'pending' })
  end

  def test_select_with_strings
    pattern = '{type, select, cpu {CPU Usage} memory {Memory Usage} disk {Disk Space}}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    
    assert_equal 'CPU Usage', formatter.format({ 'type' => 'cpu' })
    assert_equal 'Memory Usage', formatter.format({ 'type' => 'memory' })
    assert_equal 'Disk Space', formatter.format({ 'type' => 'disk' })
  end
end