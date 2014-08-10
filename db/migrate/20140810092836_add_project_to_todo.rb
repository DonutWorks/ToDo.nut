class AddProjectToTodo < ActiveRecord::Migration
  def change
    add_reference :todos, :project, index: true
  end
end
