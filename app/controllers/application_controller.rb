class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_filersQuery
  
  private
  def set_filersQuery
    @filers = Filer.all.select("cik,name,symbol").where.not('symbol' => nil).order(:symbol)
  	@filersQuery = @filers.pluck_h(:name, :cik, :symbol)
  	@filersQuery.map {|item| item[:searchName] = "#{item[:name]} #{item[:symbol]}"}
  end
end
