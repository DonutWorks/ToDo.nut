class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :histories
  has_many :todos
  

  has_many :history_users, foreign_key: :assignee_id
  has_many :assigned_histories, through: :history_users  
  
  has_many :project_users, foreign_key: :assignee_id
  has_many :assigned_project, through: :project_users

  belongs_to :user

  belongs_to :comment
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
