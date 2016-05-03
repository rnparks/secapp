class DownloadExcelsController < ApplicationController
  before_action :set_keys
  before_action :set_filer
  before_action :set_stock
  before_action :set_subs

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
  	@subs = @filer.subs
  end
  
  def download_excel
    cik = @filer.cik
    ticker = @filer.symbol
    @subs.each do |sub|
      types.each do |type|
        uri = "#{sub.get_sub_data_path}Financial_Report.xlsx"
        send_file(Net::HTTP.get(uri),
        filename: "#{ticker}_#{type}_#{self.period.strftime('%d%b%Y')}.xlsx",
        type: "application/xlsx")
      end
    end
  end
end
