module Mutations
  class <%= prefixed_class_name('Update') %> < Mutations::BaseMutation
    argument :id, ID, required: true, loads: Types::Input::<%= name %>Input, as: <%= singular_name %>
    argument :attributes, Types::Input::<%= name %>Input, required: true

    field :<%= singular_name %>, Types::<%= name %>Type, null: true
    
    def resolve(attributes:, <%= singular_name %>:)
      if <%= singular_name %>.update_attributes(attributes.to_h)
        {
          <%= singular_name %>: <%= singular_name %>,
          errors: []
        }
      else
        model_errors!(model)
      end
    end
  end
end