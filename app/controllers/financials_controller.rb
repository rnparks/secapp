class FinancialsController < ApplicationController
	before_action :set_filer

	def index
		@hasStock = @filer.stock
		@morningStarIsQt = @filer.stock.getMorningStarData("is", 3)
		@morningStarIsYr = @filer.stock.getMorningStarData("is", 12)
		@morningStarCfQt = @filer.stock.getMorningStarData("cf", 3)
		@morningStarCfYr = @filer.stock.getMorningStarData("cf", 12)
		@morningStarBsQt = @filer.stock.getMorningStarData("bs", 3)
		@morningStarBsYr = @filer.stock.getMorningStarData("bs", 12)
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
	def set_filer
		@filer = Filer.find(params[:filer_id])
	end
end
