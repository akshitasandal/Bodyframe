# module ErrorSerializer
#   class << self
#     def serialize(errors)
#       return if errors.nil?

#       json = {}
#       new_hash = errors.to_hash(true).map do |k, v|
#         v.map do |msg|
#           { id: k, title: msg }
#         end
#       end.flatten
#       json[:errors] = new_hash
#       json
#     end
#   end
# end


# https://github.com/Netflix/fast_jsonapi/issues/53
class ErrorSerializer
  def initialize(model)
    @model = model
  end

  def serialized_json
    errors = @model.errors.messages.map do |field, errors|
      errors.map do |error_message|
        {
          source: {pointer: "/data/attributes/#{field}"},
          detail: error_message
        }
      end
    end
    @model.class.reflect_on_all_associations.each do |relationship|      
      @model.send(relationship.name).each_with_index do |child, index|
        errors << child.errors.messages.map do |field, errors|
          errors.map do |error_message|
            {
              source: {pointer: "/data/attributes/#{child.model_name.plural}[#{index}].#{field}"},
              detail: error_message
            }
          end
        end
      end
    end
    errors.flatten
  end
end
