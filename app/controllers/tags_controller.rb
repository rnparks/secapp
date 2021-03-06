class TagsController < ApplicationController
before_action :set_tag, only: [:show, :edit, :update, :destroy]
before_action :set_keys

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  	@tagKeys = Num.new.attributes.keys
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.fetch(:tag, {})
    end

    def set_keys
    	@tagKeys = Num.new.attributes.keys
    end
end
