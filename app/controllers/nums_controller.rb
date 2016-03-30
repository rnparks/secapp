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
  end

  # GET /nums/new
  def new
    @num = Num.new
  end

  # GET /nums/1/edit
  def edit
  end

  # POST /nums
  # POST /nums.json
  def create
    @num = Num.new(num_params)

    respond_to do |format|
      if @num.save
        format.html { redirect_to @num, notice: 'Num was successfully created.' }
        format.json { render :show, status: :created, location: @num }
      else
        format.html { render :new }
        format.json { render json: @num.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nums/1
  # PATCH/PUT /nums/1.json
  def update
    respond_to do |format|
      if @num.update(num_params)
        format.html { redirect_to @num, notice: 'Num was successfully updated.' }
        format.json { render :show, status: :ok, location: @num }
      else
        format.html { render :edit }
        format.json { render json: @num.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nums/1
  # DELETE /nums/1.json
  def destroy
    @num.destroy
    respond_to do |format|
      format.html { redirect_to nums_url, notice: 'Num was successfully destroyed.' }
      format.json { head :no_content }
    end
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
