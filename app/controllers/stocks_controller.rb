class StocksController < ApplicationController
  before_action :set_sub
  before_action :set_stock
  before_action :set_stockData

	def index
	end
	private
	# Use callbacks to share common setup or constraints between actions.
	def set_sub
	  @sub = Sub.find(params[:sub_id])
	end

	def set_stock
		@stock = @sub.stock
	end

	def set_stockData
		@stockData = @stock.getYahooFinanceData
	end
end
