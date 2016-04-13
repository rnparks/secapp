class XbrlsController < ApplicationController
	before_action :set_sub

	def index
  end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_sub
		@sub = Sub.find(params[:sub_id])
	end
end
