# preferred

preferred provides a simple mechanism defining and storing preferences on a model.
This becomes powerful when used in conjunction with Single Table Inheritance
in Rails. Concepts for this gem were initially taken from the Spree open source
project and ported to use PostgreSQL JSONB columns instead of separate preferences
table.

# Usage

To install preferred add the following to your Gemfile

```ruby
gem 'preferred', git: 'https://github.com/nwwatson/preferred.git'
```

Once in your Gemfile

```shell
bundle install
```

# Simple Example

This simple example shows how to use preferred in a Rails model. Default values are optional. Preferred will provides types for string, decimal, integer, boolean, and date.

Create a model and ensure that it has a JSONB column called preference_hash

```shell
bin/rails g model example_model preference_hash:jsonb
```

Define preferences in the model and use

```ruby
class ExampleModel < ApplicationRecord
  preference :nickname, :string
  preference :min_value, :decimal, default: 32.0
  preference :year, :integer, default: 2018
  preference :has_example, :boolean, default: true
  preference :birthday, :date, default: Date.today
end

example_model = ExampleModel.new
example_model.has_preference?(:min_value) # returns true
example_model.preferred_min_value # returns 32.0
example_model.preferred_min_value = 0 # sets min_value to 0
example_model.preference_default(:min_value) # returns 32.0
example_model.preference_type(:min_value) # returns :decimal
```

# Complex example using Single Table Inheritance

Create base model

```
bin/rails g model strategy description:string type:string preference_hash:jsonb
```

## Include Preferable in Strategy model

```ruby
class Strategy < ApplicationRecord
  include Preferable

  validates_presence_of :description

end
```

Define a models that extends Strategy

## WithinRange Strategy

```ruby
class WithinRange < Strategy
  # The minimum temperature value for the range
  preference :min, :decimal, default: 28.0
  # The maximum temperature value for the range
  preference :max, :decimal, default: 42.0

  def good?(value)
    (value => preferred_min) and (value <= preferred_max)
  end
end
```

## BelowMaximum Strategy

```ruby
class BelowMaximum < Strategy
  # The maximum temperature value for the range
  preference :max, :decimal, default: 160.0

  def good?(value)
    value < preferred_max
  end
end
```
