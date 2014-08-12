class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
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
  :omniauthable, :omniauth_providers => [:google_oauth2]

  validates_presence_of :nickname
  validates_uniqueness_of :nickname

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      logger.debug "test fb"
      logger.debug auth.info.nickname

      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]

      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(email: data["email"],
       password: Devise.friendly_token[0,20],
       nickname: data["name"]
       )
    end
    user
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
   
    unless user
      user = User.create(provider:auth.provider,
        uid:auth.uid,
        email: auth.extra.raw_info.screen_name + "@todo.nut",
        password:Devise.friendly_token[0,20])
    end
    
    user
  end
end
