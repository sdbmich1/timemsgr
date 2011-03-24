class SubscriptionsController < Devise::RegistrationsController
  def new
  	    @city = City.order(:city)
  end
end
