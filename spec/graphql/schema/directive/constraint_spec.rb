# frozen_string_literal: true

RSpec.describe GraphQL::Schema::Directive::Constraint do
  context "ConstraintSchema" do
    class ConstraintSchema < GraphQL::Schema
      class LengthInput < GraphQL::Schema::InputObject
        argument :arg, String, directives: {
          GraphQL::Schema::Directive::Constraint => {
            minLength: 3,
            maxLength: 5,
          },
        }
      end

      class Query < GraphQL::Schema::Object
        field :length, String, null: false do
          argument :input, LengthInput
        end

        field :pattern, String, null: false do
          argument :input, String, directives: {
            GraphQL::Schema::Directive::Constraint => {
              pattern: "^[a-z]+$",
            }
          }
        end

        field :without_validator, String, null: false do
          argument :input, String, directives: {
            GraphQL::Schema::Directive::Constraint => {
              pattern: "^[a-z]+$",
              without_validator: true,
            }
          }
        end

        def length(input:)
          input.arg
        end

        def pattern(input:)
          input
        end

        def without_validator(input:)
          input
        end
      end

      query(Query)
    end

    it "input arguments has one constraint directive" do
      directives = ConstraintSchema::LengthInput.arguments["arg"].directives

      expect(directives.length).to eq(1)
      expect(directives.first).to be_instance_of(GraphQL::Schema::Directive::Constraint)
    end

    it "returns errors with minimum length" do
      q = '{
        res: length(input: { arg: "1" })
      }'
      res = ConstraintSchema.execute(q)

      expect(res["data"]).to be(nil)
      expect(res["errors"]).not_to be(nil)
    end

    it "returns errors with maximum length" do
      q = '{
        res: length(input: { arg: "123456" })
      }'
      res = ConstraintSchema.execute(q)

      expect(res["data"]).to be(nil)
      expect(res["errors"]).not_to be(nil)
    end

    it "returns data with valid length" do
      q = '{
        res: length(input: { arg: "12345" })
      }'
      res = ConstraintSchema.execute(q)

      expect(res["data"]["res"]).to be("12345")
      expect(res["errors"]).to be(nil)
    end

    it "returns errors with invalid pattern" do
      q = '{
        res: pattern(input: "12345")
      }'
      res = ConstraintSchema.execute(q)

      expect(res["data"]).to be(nil)
      expect(res["errors"]).not_to be(nil)
    end

    it "returns data with valid pattern" do
      q = '{
        res: pattern(input: "abcde")
      }'
      res = ConstraintSchema.execute(q)

      expect(res["data"]["res"]).to be("abcde")
      expect(res["errors"]).to be(nil)
    end

    it "without_validator arguments has one constraint directive" do
      directives = ConstraintSchema::Query.fields["withoutValidator"].arguments["input"].directives

      expect(directives.length).to eq(1)
      expect(directives.first).to be_instance_of(GraphQL::Schema::Directive::Constraint)
    end

    it "without_validator returns data with invalid pattern" do
      q = '{
        res: length(input: { arg: "12345" })
      }'
      res = ConstraintSchema.execute(q)

      expect(res["data"]["res"]).to be("12345")
      expect(res["errors"]).to be(nil)
    end
  end
end
