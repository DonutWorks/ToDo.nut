class AddReferenceProjectUser < ActiveRecord::Migration
  def change
    drop_table :project_users
    create_table :project_users do |t|
      t.references :assigned_project, references: :project, index: true
      t.references :assignee, references: :user, index: true
      t.timestamps
    end
  end
end
