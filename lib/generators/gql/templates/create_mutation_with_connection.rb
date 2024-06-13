# frozen_string_literal: true

module Mutations
  class <%= prefixed_class_name('Create') %> < Mutations::BaseMutation
    argument :attributes, Types::Attributes::<%= name %>Attributes, required: true
    
    field :<%= singular_name %>, Types::<%= name %>Type.edge_type, null: true

    def resolve(attributes:)
      <%= singular_name %> = <%= name %>.new(attributes.to_h)

      if <%= singular_name %>.save
        range_add = GraphQL::Relay::RangeAdd.new(
          parent: parent,
          collection: parent.action_keys,
          item: <%= singular_name %>,
          context: context
        )

        {
          <%= singular_name %>: range_add.edge,
          errors: []
        }
      else
        model_errors!(<%= singular_name %>)
      end
    end
  end
end