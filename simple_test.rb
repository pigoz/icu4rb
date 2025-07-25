#!/usr/bin/env ruby
require 'icu4rb'

puts "Testing basic ICU functionality..."

begin
  # Test basic select
  puts "Testing select..."
  formatter = ICU::MessageFormatter.new("{gender, select, male {He} female {She} other {They}}", "en_US")
  puts formatter.format({ 'gender' => 'male' })
  
  # Test basic plural
  puts "Testing plural..."
  plural = ICU::MessageFormatter.new("{count, plural, one {one} other {#}}", "en_US")
  puts plural.format({ 'count' => 1 })
  puts plural.format({ 'count' => 5 })
  
  # Test basic string
  puts "Testing string..."
  string = ICU::MessageFormatter.new("Hello {name}!", "en_US")
  puts string.format({ 'name' => 'World' })
  
  puts "All tests passed!"
rescue => e
  puts "Error: #{e}"
  puts e.backtrace
end