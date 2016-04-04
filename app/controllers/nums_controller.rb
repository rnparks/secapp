class NumsController < ApplicationController
  before_action :set_num, only: [:show, :edit, :update, :destroy]

  # GET /nums
  # GET /nums.json
  def index
    @nums = Num.all
  end

  # GET /nums/1
  # GET /nums/1.json
  def show
    @numKeys = Num.new.attributes.keys
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_num
      @num = Num.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def num_params
      params.fetch(:num, {})
    end
end
