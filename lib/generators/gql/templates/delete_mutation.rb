# frozen_string_literal: true

module Mutations
  class <%= prefixed_class_name('Delete') %> < Mutations::BaseMutation
    argument :id, ID, required: true, loads: Types::<%= name %>Type, as: :<%= singular_name %>
    
    field :<%= singular_name %>, Types::<%= name %>Type, null: true

    def resolve(<%= singular_name %>:)
      <%= singular_name %>.destroy
      {
        <%= singular_name %>: <%= singular_name %>,
        errors: []
      }
    end
  end
end