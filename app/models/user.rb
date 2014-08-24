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
  :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

  validates_presence_of :nickname
  validates_uniqueness_of :nickname

  acts_as_reader

  def to_param
    nickname
  end

  def self.find_by_nickname(nickname)
    #where(arel_table[:nickname].matches("#{nickname}")).take(1)
    user = User.where(:nickname => nickname).first
  end

  def self.from_omniauth(auth)
    @my_logger ||= Logger.new("#{Rails.root}/log/my.log")
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      @my_logger.debug "test facebok"
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # user.password = nil
      user.nickname = auth.info.name

      @my_logger.debug user.inspect
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
      user = User.create(provider:access_token.provider,
        uid:access_token.uid,
        email: data["email"],
        password: Devise.friendly_token[0,20],
        nickname: data["name"])
    end
    user
  end


  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:email => auth.extra.raw_info.screen_name + "@todo.nut").first
   
    unless user
      user = User.create(provider:auth.provider,
        uid:auth.uid,
        email: auth.extra.raw_info.screen_name + "@todo.nut",
        nickname: auth.extra.raw_info.screen_name,
        password:Devise.friendly_token[0,20])
    end
    
    user
  end

  def merge(id, provider, uid)
    user = User.where(:id => id).first
    user.provider = provider
    user.uid = uid
    user.save
  end


end
