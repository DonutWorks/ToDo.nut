class Users::SessionsController < Devise::SessionsController
  skip_before_action :is_nickname_not_empty?
end