# BindingDumper

[![Build Status](https://travis-ci.org/iliabylich/binding_dumper.svg?branch=master)](https://travis-ci.org/iliabylich/binding_dumper)
[![Code Climate](https://codeclimate.com/github/iliabylich/binding_dumper/badges/gpa.svg)](https://codeclimate.com/github/iliabylich/binding_dumper)
[![Coverage Status](https://coveralls.io/repos/iliabylich/binding_dumper/badge.svg?branch=master&service=github)](https://coveralls.io/github/iliabylich/binding_dumper?branch=master)
[![Inline docs](http://inch-ci.org/github/iliabylich/binding_dumper.svg?branch=master)](http://inch-ci.org/github/iliabylich/binding_dumper)

A gem for dumping a whole binding and restoring it later. After restoring you can use `pry` to perform delayed debugging.

**WARNING** this gem is not ready for production yet, please, use it only in development environment.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'binding_dumper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install binding_dumper

## Usage

To dump a binding run

``` ruby
binding.dump
# => "a lot of strange output here, that's fine"
```

Ideally, you should persist an output somewhere (like in the database). Let's say we have a Rails model called `DumpedBinding` with `data` field:

``` ruby
StoredBinding.create(data: binding.dump)
```

Make your server to execute the code above (just put it to any controller's action), go to the console, and run:
``` ruby
b = Binding.load(StoredBinding.last.data)
b.pry
```

And enjoy!

[Blog post about internal parts of the gem](https://ilyabylich.svbtle.com/saving-execution-context-for-later-debugging)

## Requirements

+ Ruby >= 1.9.3 (see travis.yml for supported versions)

## Examples

The simplest one is in the file `test.rb`.

A bit more complex example with Rails environment is in `spec/dummy/app/controllers/users_controller.rb`

## Development

Clone the repo, run `bundle install`.

To run all tests using current ruby version, run `rspec` or `rake`.

To run all tests with ALL supported ruby versions, run `bin/multitest` and follow the output.

To run dummy app, run `bin/dummy_rails s` (`bin/dummy_rails c` for console).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/binding_dumper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
