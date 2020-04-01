# frozen_string_literal: true

module Mutations
  class <%= prefixed_class_name('Update') %> < Mutations::BaseMutation
    argument :id, ID, required: true, loads: Types::<%= name %>Type, as: :<%= singular_name %>
    argument :attributes, Types::Attributes::<%= name %>Attributes, required: true

    field :<%= singular_name %>, Types::<%= name %>Type, null: true
    
    def resolve(<%= singular_name %>:, attributes:)
      if <%= singular_name %>.update(attributes.to_h)
        {
          <%= singular_name %>: <%= singular_name %>,
          errors: []
        }
      else
        model_errors!(<%= singular_name %>)
      end
    end
  end
end