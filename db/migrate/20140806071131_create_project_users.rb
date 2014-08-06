class CreateProjectUsers < ActiveRecord::Migration
  def change
    create_table :project_users do |t|
      t.references :assigned_project, references: :project, index: true
      t.references :assignee, references: :user, index: true
      t.timestamps
    end
  end
end
