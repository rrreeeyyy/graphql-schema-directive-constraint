# frozen_string_literal: true

require "graphql"

module GraphQL
  class Schema
    class Directive < GraphQL::Schema::Member
      # Allows using @constraint as a directive to validate input data
      #
      # This directive validates the input value.
      #
      # @example Generates @constraint directive and validates input length and patten
      #   class LengthInput < GraphQL::Schema::InputObject
      #     argument :arg, String,
      #       directives: {
      #         GraphQL::Schema::Directive::Constraint => {
      #           minLength: 3,
      #           maxLength: 5,
      #           pattern: '[0-9a-zA-Z]*$',
      #         },
      #       }
      #   end
      class Constraint < GraphQL::Schema::Directive
        description "Allows using @constraint as a directive to validate input data"

        argument(:minLength, Integer, description: "Restrict to a minimum length", required: false)
        argument(:maxLength, Integer, description: "Restrict to a maximum length", required: false)
        argument(:startsWith, String, description: "Ensure value starts with", required: false)
        argument(:endsWith, String, description: "Ensure value ends with", required: false)
        argument(:contains, String, description: "Ensure value contains", required: false)
        argument(:notContains, String, description: "Ensure value does not contain", required: false)
        argument(:pattern, String, description: "Ensure value matches regex, e.g. alphanumeric", required: false)
        argument(:format, String, description: "Ensure value is in a particular format", required: false)

        argument(:without_validator, Boolean, description: "Use constraint directive without validator", required: false)

        locations(
          GraphQL::Schema::Directive::INPUT_FIELD_DEFINITION,
          GraphQL::Schema::Directive::FIELD_DEFINITION,
          GraphQL::Schema::Directive::ARGUMENT_DEFINITION,
        )

        def initialize(owner, **arguments)
          arguments.each { |a| add_validator(owner, a) } unless arguments[:without_validator]
          super
        end

        def add_validator(owner, argument)
          case argument
          in [:minLength, minLength]
            owner.validates({ length: { minimum: minLength } })
          in [:maxLength, maxLength]
            owner.validates({ length: { maximum: maxLength } })
          in [:pattern, pattern]
            owner.validates({ format: { with: pattern } })
          else
            raise NotImplementedError("Given arguments are not implemented yet")
          end
        end
      end
    end
  end
end
