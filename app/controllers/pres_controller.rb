class PresController < ApplicationController
	before_action :set_pre, only: [:show]
	before_action :set_keys
  before_action :set_filer
  before_action :set_subs
  before_action :set_sec_excel_links
  before_action :set_statement_names, only: [:show, :index]

  # GET /tagss
  # GET /tags.json
  def index
    @pres = @filer.pres
    @nums = @filer.nums.select { |nums| nums.dd.year > 2013 }
    @hasStock = @filer.stock
    set_table_data
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  	@preKeys = Pre.new.attributes.keys
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pre
      @pre = Pre.find(params[:id])
    end

    def set_subs
      @subs = @filer.subs.where("form = ? OR form = ?", "10-K", "10-Q")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.fetch(:pre, {})
    end

    def set_keys
    	@preKeys = Pre.new.attributes.keys
    end

    def set_filer
      @filer = Filer.find(params[:filer_id])
    end

    def set_table_data
      @periods = @filer.get_periods
      @tableData = @pres.group_by(&:stmt)
      @tableData.each {|key, value| @tableData[key] = value.group_by { |p| p.sub.form }}
      @tableData.each {|key, value| value.each {|key2, value2| @tableData[key][key2] = value2.group_by { |p| "#{p.report}-#{p.tag}" }}}
    end

    def set_statement_names
      @statementNames = {
        "BS" => "Balance Sheet",
        "IS" => "Income Statement",
        "CF" => "Cash Flow",
        "EQ" => "Equity",
        "CI" => "Comprehensive Income",
        "UN" => "Unclassifiable Statement"
      }
    end

    def set_sec_excel_links
      hash = {}
      @subs.sort_by { |sub| sub.period }.each do |sub|
        path = sub.get_excel_path
        url = URI.parse(path)
        req = Net::HTTP.new(url.host, url.port)
        res = req.request_head(url.path)
        hash["#{sub.form} | #{sub.fy} | #{sub.fp} | #{sub.period}"] = path if res.code == "200"
      end
      @excel_links = hash
    end
end
