require 'rails/generators/base'

module Gql
  module GqlGeneratorBase
    protected

    # Generate a namedspaced class name with the mutation prefix
    def prefixed_class_name(prefix)
      (class_path + ["#{prefix}_#{file_name}"]).map!(&:camelize).join("::")
    end

    def type_map(model_name, col)
      klass = model_name.constantize
      if klass.defined_enums.has_key?(col.name)
        return 'String'
      end
      if col.name === 'preferences'
        return GraphQL::Types::JSON
      end
      types = {
        integer: 'Integer',
        string: 'String',
        boolean: 'Boolean',
        decimal: 'Float',
        datetime: 'GraphQL::Types::ISO8601DateTime',
        date: 'GraphQL::Types::ISO8601Date',
        hstore: 'GraphQL::Types::JSON',
        text: 'String',
        json: 'GraphQL::Types::JSON',
        jsonb: 'GraphQL::Types::JSON'
      }
      types[col.type]
    end

    def map_model_types(model_name)
      klass = model_name.constantize
      # associations = klass.reflect_on_all_associations(:belongs_to)
      # bt_columns = associations.map(&:foreign_key)

      # .reject { |col| bt_columns.include?(col.name) }
      klass.columns
        .reject { |col| col.name == 'id' }
        .reject { |col| type_map(model_name, col).nil? }
        .map do |col|
          {
            name: col.name,
            null: col.null,
            gql_type: klass.primary_key == col.name ? 'GraphQL::Types::ID' : type_map(model_name, col)
          }
        end
    end

    def root_directory(namespace)
      "app/graphql/#{namespace.underscore}"
    end

    def wrap_in_namespace(namespace)
      namespace = namespace.split('::')
      namespace.shift if namespace[0].empty?
      code = "# frozen_string_literal: true"
      code << "\n"
      code << "\n"
      code << namespace.each_with_index.map { |name, i| "  " * i + "module #{name}" }.join("\n")
      code << "\n" << yield(namespace.size) << "\n"
      code << (namespace.size - 1).downto(0).map { |i| "  " * i  + "end" }.join("\n")
      code
    end

    def class_with_fields(namespace, name, superclass, fields, method = 'field')
      wrap_in_namespace(namespace) do |indent|
        klass = []
        klass << sprintf("%sclass %s < %s", "  " * indent, name, superclass)

        klass << sprintf("%sglobal_id_field :id", "  " * (indent + 1)) if method == 'field'

        fields.each do |field|
          klass << sprintf("%s%s :%s, %s, %s", "  " * (indent + 1), method, field[:name], field[:gql_type], method == 'field' ? "null: #{field[:null]}" : "required: false")
        end

        klass << sprintf("%send", "  " * indent)
        klass.join("\n")
      end
    end
  end
end
