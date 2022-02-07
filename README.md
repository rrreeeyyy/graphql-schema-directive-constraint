# GraphQL::Schema::Directive::Constraint

Allows using @constraint as a directive to validate input data for [graphql-ruby](https://graphql-ruby.org).

This gem is greatly inspired by [confuser/graphql-constraint-directive](https://github.com/confuser/graphql-constraint-directive)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-schema-directive-constraint'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install graphql-schema-directive-constraint
```

## Usage

Specify `GraphQL::Schema::Directive::Constraint` with parameter to `directive` arguments in `argument`

```ruby
class LengthInput < GraphQL::Schema::InputObject
  argument :arg, String,
    directives: {
      GraphQL::Schema::Directive::Constraint => {
        minLength: 3,
        maxLength: 5,
        pattern: '[0-9a-zA-Z]*$',
      },
    }
end
```

This `LengthInput` example will generates definition as below:

```graphql
input LengthInput {
  arg: String! @constraint(minLength: 3, maxLength: 5, pattern: "[0-9a-zA-Z]*$")
}
```

This example generates [Validators](https://graphql-ruby.org/fields/validation.html) to validates input.
You can disable generate validator with `without_validator` argument like below:

```ruby
field :without_validator, String, null: false do
  argument :input, String, directives: {
    GraphQL::Schema::Directive::Constraint => {
      pattern: '^[a-z]+$',
      without_validator: true,
    }
  }
end
```

This example only generates `@constraint` directive on schema but it does not validates input variable.

## Implementation status

- [ ] String
  - [x] minLength
    - [x] constraint
    - [x] validator
  - [x] maxLength
    - [x] constraint
    - [x] validator
  - [ ] startsWith
    - [x] constarints
    - [ ] validator
  - [ ] endsWith
    - [x] constraint
    - [ ] validator
  - [ ] contains
    - [x] constraint
    - [ ] validator
  - [ ] notContains
    - [x] constraint
    - [ ] validator
  - [x] pattern
    - [x] constraint
    - [x] validator
  - [ ] format
    - [x] constraint
    - [ ] validator
- [ ] Integer
  - [ ] min
    - [ ] constraint
    - [ ] validator
  - [ ] max
    - [ ] constraint
    - [ ] validator
  - [ ] exclusiveMin
    - [ ] constraint
    - [ ] validator
  - [ ] exclusiveMax
    - [ ] constraint
    - [ ] validator
  - [ ] multipleOf
    - [ ] constraint
    - [ ] validator
- [ ] Errors
  - [ ] ConstraintDirectiveError

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rrreeeyyy/graphql-schema-directive-constraint. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rrreeeyyy/graphql-schema-directive-constraint/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GraphQL::Schema::Directive::Constraint project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rrreeeyyy/graphql-schema-directive-constraint/blob/master/CODE_OF_CONDUCT.md).
