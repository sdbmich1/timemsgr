class MemberController < ApplicationController
  before_filter :authenticate_user!
  def new
  	    @title = "Sign up"
  end
end
