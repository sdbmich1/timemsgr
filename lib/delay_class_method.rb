# used to address delayed_jobs problem with rails/passenger in production mode with class methods
class DelayClassMethod
  def initialize(receiver_name, method_name, options={})
    @receiver_name = receiver_name
    @method_name = method_name
    @parameters = options[:params] || []
  end

  def perform
    eval(@receiver_name).send(@method_name, *@parameters)
  end
end 