# frozen_string_literal: true

module Mutations
  class <%= prefixed_class_name('Create') %> < Mutations::BaseMutation
    argument :attributes, Types::Attributes::<%= name %>Attributes, required: true
    
    field :<%= singular_name %>, Types::<%= name %>Type, null: true

    def resolve(attributes:)
      model = <%= name %>.new(attributes.to_h)

      if model.save
        {
          <%= singular_name %>: model,
          errors: []
        }
      else
        model_errors!(model)
      end
    end
  end
end