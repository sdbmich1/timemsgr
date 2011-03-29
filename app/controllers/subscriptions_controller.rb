class SubscriptionsController::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    welcome_path # it's not a home path
  end

  def after_sign_in_path_for(resource)
    home_path
  end
end
