class FilersController < ApplicationController
  before_action :set_keys
  before_action :set_filer, only: [:show]
  before_action :set_stock, only: [:show]
  before_action :set_subs

	
	  def index
	    @filers = Filer.all
	  end
	  def show
	    # @filer = @sub
	    # @nums = Num.where(adsh: @sub.adsh)
	    @numKeys = Num.new.attributes.keys
	  end
      def set_keys
      @filerKeys = Filer.new.attributes.keys
    end
    def set_filer
      @filer = Filer.find(params[:id])
    end
        def set_stock
      @hasStock = @filer.stock
      if @hasStock
        @stock = @filer.stock
        @stockData = @stock.getYahooFinanceData
        @stockData[:data][:close] = @stockData[:data][:close].to_f
        @stockData[:data][:stock_current] = @stockData[:data][:last_trade_price].to_f
        @stockData[:data][:change_in_percent] = @stockData[:data][:change_in_percent].to_f
        @stockData[:data][:change] = @stockData[:data][:change].to_f
        @stockState = @stockData[:data][:change] > 0 ? "up" : "down"

      end
    end
    def set_subs
    end
end
