class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :histories
  has_many :todos
  belongs_to :comment
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
