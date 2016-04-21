class SubsController < ApplicationController
  before_action :set_sub, only: [:show]
  before_action :set_keys
  before_action :set_filer, only: [:show, :index]

  def index
    @subs = @filer.subs
  end

  def show
    @nums = Num.where(adsh: @sub.adsh)
    @numKeys = Num.new.attributes.keys
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub
      @sub = Sub.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_params
      params.fetch(:sub, {})
    end

    def set_keys
      @subKeys = Sub.new.attributes.keys
    end

    def set_filer
      @filer = Filer.find(params[:filer_id])
    end
end
