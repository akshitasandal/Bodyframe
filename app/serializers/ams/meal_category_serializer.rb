class AMS::MealCategorySerializer < AmsSerializer
  attributes :id, :name

  def id
    @id ||= object[:id].to_s
  end
end
