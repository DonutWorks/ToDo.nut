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
    user = User.where(:nickname => nickname).first
  end

  def self.from_omniauth(auth)

    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.nickname = auth.info.name
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["omniauth"] && session["omniauth"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_for_oauth2(access_token)
    data = access_token.info
    user = User.where(provider: access_token.provider, uid: access_token.uid).first

    unless user
      if User.where(email: data["email"]).first
        user = "duplicated"
      else
        user = nil
      end
    end
    user
  end


  def self.find_for_twitter_oauth(auth)
    user = User.where(:uid => auth.uid, :provider => auth.provider).first
  end

  def merge(id, provider, uid)
    user = User.where(:id => id).first
    user.provider = provider
    user.uid = uid
    user.save!
  end

  def update_from_twitter(id, email)
    user = User.where(:id => id).first
    user.email = email
    user.save!
  end

  def password_required?
    if provider.nil?
      super
    end    
  end

end
