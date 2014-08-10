class AddProjectToHistory < ActiveRecord::Migration
  def change
    add_reference :histories, :project, index: true
  end
end
