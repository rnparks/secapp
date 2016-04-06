class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_subsQuery
  private
  def set_subsQuery
  	@subsQuery = Sub.all.pluck_h(:name, :adsh)
  end
end
