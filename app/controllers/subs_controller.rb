class SubsController < ApplicationController
  before_action :set_sub, only: [:show, :edit, :update, :destroy]

  # GET /subs
  # GET /subs.json
  def index
    @subs = Sub.all
  end

  # GET /subs/1
  # GET /subs/1.json
  def show
    @filer = @sub
    @nums = Num.where(adsh: @sub.adsh)
    @numKeys = Num.new.attributes.keys
  end

  # GET /subs/new
  def new
    @sub = Sub.new
  end

  # GET /subs/1/edit
  def edit
  end

  # POST /subs
  # POST /subs.json
  def create
    @sub = Sub.new(sub_params)

    respond_to do |format|
      if @sub.save
        format.html { redirect_to @sub, notice: 'Sub was successfully created.' }
        format.json { render :show, status: :created, location: @sub }
      else
        format.html { render :new }
        format.json { render json: @sub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subs/1
  # PATCH/PUT /subs/1.json
  def update
    respond_to do |format|
      if @sub.update(sub_params)
        format.html { redirect_to @sub, notice: 'Sub was successfully updated.' }
        format.json { render :show, status: :ok, location: @sub }
      else
        format.html { render :edit }
        format.json { render json: @sub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subs/1
  # DELETE /subs/1.json
  def destroy
    @sub.destroy
    respond_to do |format|
      format.html { redirect_to subs_url, notice: 'Sub was successfully destroyed.' }
      format.json { head :no_content }
    end
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
end
