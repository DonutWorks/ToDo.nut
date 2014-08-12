class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :is_nickname_not_empty?
end