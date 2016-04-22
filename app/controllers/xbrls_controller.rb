class XbrlsController < ApplicationController
	before_action :set_filer
	before_action :set_xbrls
	before_action :set_xbrl_data

	def index
  end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_filer
		@filer = Filer.find(params[:filer_id])
	end

	def set_xbrls
		@xbrls = @filer.xbrls
	end
	def set_xbrl_data
		@html = ""
		@xbrls.each do |xbrl|
			@html += xbrl.getTables.to_s
		end
	end
end
