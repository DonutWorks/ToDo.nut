class User < ActiveRecord::Base
  has_many :histories
  has_many :todos

  has_many :history_users, foreign_key: :assignee_id
  has_many :assigned_histories, through: :history_users

  has_many :project_users, foreign_key: :assignee_id
  has_many :assigned_projects, through: :project_users

  belongs_to :user

  belongs_to :comment
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

  validates_presence_of :nickname
  validates_uniqueness_of :nickname

  def to_param
    nickname
  end

  def self.find_by_nickname(nickname)
    user = User.where(nickname: nickname).first
  end

  def self.find_for_oauth(provider, access_token)
    case provider
    when "twitter"
      if user = User.where(uid: access_token.uid, provider: access_token.provider).first
        return {data: user, status: :success}
      else
        return {data: nil, status: :first_login}
      end

    else
      email = access_token.info[:email]

      if user = User.where(uid: access_token.uid, provider: access_token.provider).first
        return {data: user, status: :success}
      elsif User.find_by_email(email)
        return {data: nil, status: :duplicated}
      else
        return {data: nil, status: :first_login}
      end  

    end
  end

  def merge(id, provider, uid)
    user = User.find(id)
    user.provider = provider
    user.uid = uid
    user.save!
  end

  def update_from_twitter(id, email)
    user = User.find(id)
    user.email = email
    user.save!
  end

  def password_required?
    if provider.nil?
      super
    end    
  end
end
