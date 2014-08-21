module ProjectsHelper

  def decorate(todos)

    return ActiveModel::ArraySerializer.new(todos, each_serializer: TodovisSerializer).to_json

  end

end
