# ICU4RB - Ruby bindings for ICU4C MessageFormat

A Ruby native extension that provides bindings to the ICU4C library, focusing on the MessageFormat API for internationalization and localization.

## Features

- **MessageFormat support**: Full ICU4C MessageFormat API integration
- **Plural formatting**: Locale-aware plural rules (one, few, many, other)
- **Select formatting**: Conditional text based on string values
- **Number formatting**: Currency, percent, scientific notation
- **Date/time formatting**: Short, medium, long, full formats
- **UTF-8 support**: Proper Unicode handling between Ruby and ICU4C
- **Cross-platform**: Works on macOS, Linux with ICU4C installed

## Installation

### Prerequisites

Install ICU4C on your system:

**macOS (Homebrew)**:
```bash
brew install icu4c
```

**Ubuntu/Debian**:
```bash
sudo apt-get install libicu-dev
```

**CentOS/RHEL**:
```bash
sudo yum install libicu-devel
```

### Install the gem

Add to your Gemfile:
```ruby
gem 'icu4rb', git: 'https://github.com/pigoz/icu4rb'
```

Or install directly:
```bash
gem install icu4rb --source https://github.com/pigoz/icu4rb
```

## Usage

### Basic Message Formatting

```ruby
require 'icu4rb'

# Simple string substitution
formatter = ICU::MessageFormatter.new("Hello {name}!")
puts formatter.format({ 'name' => 'World' })  # => "Hello World!"

# Plural formatting
plural = ICU::MessageFormatter.new(
  "{count, plural, one {You have one message} other {You have # messages}}",
  "en_US"
)
puts plural.format({ 'count' => 1 })   # => "You have one message"
puts plural.format({ 'count' => 5 })   # => "You have 5 messages"

# Select formatting
select = ICU::MessageFormatter.new(
  "{gender, select, male {He} female {She} other {They}} liked your post."
)
puts select.format({ 'gender' => 'female' })  # => "She liked your post."
```

### Number Formatting

```ruby
# Currency
currency = ICU::MessageFormatter.new("Price: {price, number, currency}")
puts currency.format({ 'price' => 29.99 })  # => "Price: $29.99"

# Percent
percent = ICU::MessageFormatter.new("Progress: {progress, number, percent}")
puts percent.format({ 'progress' => 0.85 })  # => "Progress: 85%"

# Scientific notation
scientific = ICU::MessageFormatter.new("Large: {num, number, scientific}")
puts scientific.format({ 'num' => 1234567 })  # => "Large: 1.23E6"
```

### Date/Time Formatting

```ruby
require 'date'

# Date formats
date = ICU::MessageFormatter.new("Today: {date, date, long}")
today = Date.today.to_time.to_i  # Unix timestamp
puts date.format({ 'date' => today })

# Time formats
time = ICU::MessageFormatter.new("Time: {time, time, medium}")
now = Time.now.to_i
puts time.format({ 'time' => now })
```

### Locale Support

```ruby
# Russian plural rules
russian = ICU::MessageFormatter.new(
  "{count, plural, one {# сообщение} few {# сообщения} many {# сообщений} other {# сообщений}}",
  "ru_RU"
)
puts russian.format({ 'count' => 1 })  # => "1 сообщение"
puts russian.format({ 'count' => 3 })  # => "3 сообщения"

# German currency
german = ICU::MessageFormatter.new("Preis: {price, number, currency}", "de_DE")
puts german.format({ 'price' => 29.99 })  # => "Preis: 29,99 €"
```

### Complex Patterns

```ruby
# Combined plural and select
complex = ICU::MessageFormatter.new(
  "{name}: {count, plural, one {one message} other {# messages}} from {sender, select, system {System} other {{sender}}}",
  "en_US"
)
puts complex.format({ 
  'name' => 'Alice', 
  'count' => 5, 
  'sender' => 'system' 
})  # => "Alice: 5 messages from System"
```

## Development

### Setup

```bash
git clone https://github.com/pigoz/icu4rb.git
cd icu4rb
bundle install
rake compile
```

### Running Tests

```bash
# Run all tests
rake test

# Run specific test file
ruby -Itest test/icu4rb_test.rb

# Interactive console
bin/console
```

### Building

```bash
# Compile extension
rake compile

# Install locally
rake install
```

## API Reference

### ICU::MessageFormatter

#### `new(pattern, locale = "en_US")`
- `pattern`: ICU MessageFormat pattern string
- `locale`: Locale identifier (e.g., "en_US", "de_DE", "ja_JP")

#### `format(arguments)`
- `arguments`: Hash of variable names to values
- Returns: Formatted string

### Pattern Syntax

ICU MessageFormat patterns support:
- **Simple variables**: `{name}`
- **Plural rules**: `{count, plural, one {...} other {...}}`
- **Select rules**: `{gender, select, male {...} female {...} other {...}}`
- **Number formats**: `{value, number, currency|percent|integer}`
- **Date formats**: `{date, date, short|medium|long|full}`
- **Time formats**: `{time, time, short|medium|long|full}`

## License

MIT License - see LICENSE file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request