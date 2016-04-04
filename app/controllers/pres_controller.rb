class PresController < ApplicationController
	before_action :set_tag, only: [:show, :edit, :update, :destroy]
	before_action :set_keys

  # GET /tagss
  # GET /tags.json
  def index
    @pres = Pre.all
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
end
