class CreateProjectUsers < ActiveRecord::Migration
  def change
    #drop_table :project_users
    create_table :project_users do |t|

      t.timestamps
    end
  end
end
