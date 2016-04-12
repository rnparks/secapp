class FinancialsController < ApplicationController
	before_action :set_sub

	def index
  	@nums = Num.all
  end
  
	private
	# Use callbacks to share common setup or constraints between actions.
	def set_sub
		@sub = Sub.find(params[:sub_id])
	end
end
