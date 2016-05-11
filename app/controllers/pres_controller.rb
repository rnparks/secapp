class PresController < ApplicationController
	before_action :set_pre, only: [:show]
	before_action :set_keys
  before_action :set_filer
  before_action :set_periods, only: [:show, :index]
  before_action :set_table_data
  before_action :set_sec_excel_links
  before_action :set_statement_names, only: [:show, :index]
  before_action :set_period_names, only: [:show, :index]


  def index
    @hasStock = @filer.stock
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pre
      @pre = Pre.find(params[:id])
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
      @subs = @filer.subs.where("form = ? OR form = ?", "10-K", "10-Q")
      @pres = @filer.pres
      @nums = @filer.nums.select { |nums| nums.dd.year > 2013 }
      @tableData = @pres.group_by(&:stmt).slice(*["IS", "BS", "CF"])
      @tableData.each {|key, value| @tableData[key] = value.group_by { |p| p.sub.form }}
      @tableData.each do |key, value| 
        value.each do |key2, value| 
          @tableData[key][key2] = value.group_by { |p| "#{p.report}-#{p.tag}" }
          # add header
          @tableData[key][key2]["headers"] = ["Fiscal year ends in #{Date::MONTHNAMES[Date.strptime(@filer.fye, '%m%d').month]}"]
          @periods[key2].each do |period|
            @tableData[key][key2]["headers"].push(period)
          end
          # add nums
          @tableData[key][key2]
          @tableData[key][key2].each do |key3, pres|
            unless key3 == "headers"
              @tableData[key][key2][key3] = []
              all_nums      = Precollection.get_nums(pres)
              isAbstract    = pres.first.get_tags.first.abstract if pres.first.get_tags.first
              hasNoNums     = all_nums.count == 0
              parenthetical = pres.first.inpth
              isStructural  = ['[Table]', '[Line Items]', '[Axis]', '[Domain]'].any? { |string| pres.first.plabel.include? string }
              isTotal       = pres.first.plabel.downcase.include? "total"
              unless (hasNoNums && !isAbstract) || isAbstract && isStructural
                if isAbstract
                  @tableData[key][key2][key3] = [pres.first]
                else
                  @tableData[key][key2][key3] = Precollection.format_rows(all_nums, @periods, key2).unshift(pres.first)
                end
              end
            end
          end
        end
      end
    end

    def set_periods
      @periods = @filer.get_periods
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

    def set_period_names
      @periodNames = {
        "8-K" => "Current",
        "10-Q" => "Quarterly",
        "10-K" => "Yearly"
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
