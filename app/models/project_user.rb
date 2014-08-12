class ProjectUser < ActiveRecord::Base
  belongs_to :assigned_project, class_name: "Project"
  belongs_to :assignee, class_name: "User"
end
