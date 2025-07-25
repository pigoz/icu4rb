# frozen_string_literal: true

require_relative '../lib/icu4rb'

# Basic usage examples for ICU MessageFormatter

puts "=== ICU MessageFormatter Examples ==="

# Simple string interpolation
puts "\n1. Simple string interpolation:"
pattern = 'Hello {name}!'
formatter = ICU::MessageFormatter.new(pattern, 'en_US')
puts formatter.format({ 'name' => 'World' })

# Plural formatting
puts "\n2. Plural formatting:"
pattern = '{count, plural, zero {You have no messages} one {You have one message} other {You have # messages}}'
formatter = ICU::MessageFormatter.new(pattern, 'en_US')
puts formatter.format({ 'count' => 0 })
puts formatter.format({ 'count' => 1 })
puts formatter.format({ 'count' => 5 })

# Select formatting
puts "\n3. Select formatting:"
pattern = '{gender, select, male {He} female {She} other {They}} liked your post.'
formatter = ICU::MessageFormatter.new(pattern, 'en_US')
puts formatter.format({ 'gender' => 'male' })
puts formatter.format({ 'gender' => 'female' })
puts formatter.format({ 'gender' => 'nonbinary' })

# Number formatting
puts "\n4. Number formatting:"
pattern = 'Your balance is {balance, number, currency}'
formatter = ICU::MessageFormatter.new(pattern, 'en_US')
puts formatter.format({ 'balance' => 1234.56 })

# Date formatting
puts "\n5. Date formatting:"
pattern = 'Today is {date, date, long}'
formatter = ICU::MessageFormatter.new(pattern, 'en_US')
today_ms = (Time.now.to_f * 1000).to_i
puts formatter.format({ 'date' => today_ms })

# Different locales
puts "\n6. Different locales:"
pattern = '{count, plural, one {# elemento} other {# elementos}}'
formatter = ICU::MessageFormatter.new(pattern, 'es_ES')
puts "Spanish: #{formatter.format({ 'count' => 1 })}"
puts "Spanish: #{formatter.format({ 'count' => 3 })}"

# Complex message with multiple arguments
puts "\n7. Complex message:"
pattern = '{name} has {count, plural, one {# message} other {# messages}} in {folder}'
formatter = ICU::MessageFormatter.new(pattern, 'en_US')
puts formatter.format({ 'name' => 'Alice', 'count' => 3, 'folder' => 'Inbox' })

puts "\n=== Examples Complete ==="