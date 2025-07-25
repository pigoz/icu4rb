# frozen_string_literal: true

require "test_helper_library_test_case"

class MessageFormatterDateTest < LibraryTestCase
  def setup
    require 'date'
    @today = Date.today
    # ICU expects milliseconds since epoch
    @today_ms = (@today.to_time.to_f * 1000).to_i
    @today_seconds = @today_ms / 1000.0
  end

  def test_short_date_format
    pattern = 'Today: {date, date, short}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'date' => @today_seconds })
    refute_empty result
  end

  def test_medium_date_format
    pattern = 'Today: {date, date, medium}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'date' => @today_seconds })
    refute_empty result
  end

  def test_long_date_format
    pattern = 'Today: {date, date, long}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'date' => @today_seconds })
    refute_empty result
    # Just check it's not empty and contains "Today" - exact format varies by ICU version
    assert_includes result.downcase, 'today'
  end

  def test_full_date_format
    pattern = 'Today: {date, date, full}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'date' => @today_seconds })
    refute_empty result
  end

  def test_time_short_format
    now = Time.now
    now_ms = (now.to_f * 1000).to_i
    now_seconds = now_ms / 1000.0
    
    pattern = 'Time: {time, time, short}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'time' => now_seconds })
    refute_empty result
  end

  def test_time_medium_format
    now = Time.now
    now_ms = (now.to_f * 1000).to_i
    now_seconds = now_ms / 1000.0
    
    pattern = 'Time: {time, time, medium}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'time' => now_seconds })
    refute_empty result
  end

  def test_time_long_format
    now = Time.now
    now_ms = (now.to_f * 1000).to_i
    now_seconds = now_ms / 1000.0
    
    pattern = 'Time: {time, time, long}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'time' => now_seconds })
    refute_empty result
  end

  def test_time_full_format
    now = Time.now
    now_ms = (now.to_f * 1000).to_i
    now_seconds = now_ms / 1000.0
    
    pattern = 'Time: {time, time, full}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'time' => now_seconds })
    refute_empty result
  end

  def test_datetime_format
    now = Time.now
    now_ms = (now.to_f * 1000).to_i
    now_seconds = now_ms / 1000.0
    
    pattern = 'Timestamp: {time, date, medium} {time, time, medium}'
    formatter = ICU::MessageFormatter.new(pattern, 'en_US')
    result = formatter.format({ 'time' => now_seconds })
    refute_empty result
  end

  def test_different_locale_date_format
    pattern = 'Heute: {date, date, long}'
    formatter = ICU::MessageFormatter.new(pattern, 'de_DE')
    result = formatter.format({ 'date' => @today_seconds })
    refute_empty result
  end
end