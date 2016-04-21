class PresController < ApplicationController
	before_action :set_tag, only: [:show]
	before_action :set_keys
  before_action :set_filer
  before_action :set_statement_names, only: [:show, :index]

  # GET /tagss
  # GET /tags.json
  def index
    @pres = @filer.pres
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
      @tableData = {}
      @pres.each do |pre| 
        stmt = pre.stmt.to_sym
        @tableData[stmt] ? @tableData[stmt][:pres].push(pre) : @tableData[stmt] = {pres: [pre], periods: []}
        nums.each {|num| @tableData[stmt][:periods].push(num.dd)}
      end
      @tableData.each {|key, value| value[:periods].uniq!.sort!}
      @tableData.each do |key, value|
        value[:pres].each do |pre|
        end
      end
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
