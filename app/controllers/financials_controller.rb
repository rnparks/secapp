class FinancialsController < ApplicationController
	before_action :set_sub

	def index
		@morningStarIsQt = @sub.stock.getMorningStarData("is", 3)
		@morningStarIsYr = @sub.stock.getMorningStarData("is", 12)
		@morningStarCfQt = @sub.stock.getMorningStarData("cf", 3)
		@morningStarCfYr = @sub.stock.getMorningStarData("cf", 12)
		@morningStarBsQt = @sub.stock.getMorningStarData("bs", 3)
		@morningStarBsYr = @sub.stock.getMorningStarData("bs", 12)
		@allMorningStarData = [
			@morningStarIsQt,
			@morningStarIsYr,
			@morningStarCfQt,
			@morningStarCfYr,
			@morningStarBsQt,
			@morningStarBsYr
		]
  end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_sub
		@sub = Sub.find(params[:sub_id])
	end
end
