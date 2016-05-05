require 'zip'
class FilersController < ApplicationController
  before_action :set_keys
  before_action :set_filer, only: [:show]
  before_action :set_download_filer, only: [:download_excel]
  before_action :set_stock, only: [:show, :download_excel]

  def index
    @filers = Filer.all
  end
  def show
    redirect_to filer_pres_path(@filer) if !@hasStock
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
      @historicalData = @stockData[:historical].map{|data| data.to_h}
    end
  end
  def set_download_filer
    @filer = Filer.find(params[:filer_id])
  end
  def download_excel
    cik = @filer.cik
    ticker = @filer.symbol
    @hasStock ? filename = "#{@filer.symbol}.zip" : filename = "#{@filer.displayName.gsub(" ", "_")}.zip"
    files = {}
    outputFile = nil
    Dir.mktmpdir do|dir|
      @filer.subs.each do |sub|
        url = "#{sub.get_sub_data_path}Financial_Report.xlsx"
        uri = URI(url)
        request = Net::HTTP.new uri.host
        response= request.request_head uri.path
        Net::HTTP.start(uri.host) do |http|
          resp = http.get(uri.path)
          content = resp.body if response.code.to_i == 200
          save_location = "#{ticker}_#{sub.form}_#{sub.period.strftime('%d%b%Y')}.xlsx"
          File.open("#{dir}/#{save_location}", "wb") {|f| f.write(content) }
        end
      end
      directoryToZip = dir
      outputFile = "#{dir}/#{filename}"
      zf = ZipFileGenerator.new(directoryToZip, outputFile)
      zf.write()
      File.open(outputFile, 'r') do |f|
       send_data f.read.force_encoding('BINARY'), :filename => filename, :type => "zip", :disposition => "attachment"
      end
    end
  end
end
