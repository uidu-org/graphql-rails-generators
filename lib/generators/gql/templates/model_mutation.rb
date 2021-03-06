# frozen_string_literal: true

module Mutations
  class <%= prefixed_class_name(mutation_prefix) %> < Mutations::BaseMutation
    argument :attributes, Types::Attributes::<%= @model_name %>Attributes, required: true
    argument :id, ID, required: false

    field :<%= singular_name %>, Types::<%= @model_name %>Type, null: true

    def resolve(attributes:, id: nil)
      model = find_or_build_model(id)
      model.attributes = attributes.to_h

      if model.save
        {<%= singular_name %>: model}
      else
        {errors: model.errors.full_messages}
      end
    end

    def find_or_build_model(id)
      if id
        <%= @model_name %>.find(id)
      else
        <%= @model_name %>.new
      end
    end
  end
end