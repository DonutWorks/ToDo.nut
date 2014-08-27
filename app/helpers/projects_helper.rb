module ProjectsHelper

  def decorate(todos)

    return ActiveModel::ArraySerializer.new(todos, each_serializer: TodoVisualizationSerializer).to_json

  end

end
