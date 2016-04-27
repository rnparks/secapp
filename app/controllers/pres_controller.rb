class PresController < ApplicationController
	before_action :set_tag, only: [:show]
	before_action :set_keys
  before_action :set_filer
  before_action :set_statement_names, only: [:show, :index]

  # GET /tagss
  # GET /tags.json
  def index
    @pres = @filer.pres
    @nums = @filer.nums.select { |nums| nums.dd.year > 2013 }
    set_table_data
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  	@preKeys = Pre.new.attributes.keys
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
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
      @periods = @filer.get_periods
      @tableData = @pres.order('report, line').group_by(&:stmt)
      @tableData.each {|key, value| @tableData[key] = value.group_by(&:tag)}
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
       
end
