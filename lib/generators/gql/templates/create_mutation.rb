# frozen_string_literal: true

module Mutations
  class <%= prefixed_class_name('Create') %> < Mutations::BaseMutation
    argument :attributes, Types::Attributes::<%= name %>Attributes, required: true
    
    field :<%= singular_name %>, Types::<%= name %>Type, null: true

    def resolve(attributes:)
      <%= singular_name %> = <%= name %>.new(attributes.to_h)

      if <%= singular_name %>.save
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