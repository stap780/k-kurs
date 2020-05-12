class KursController < ApplicationController

  before_action :authenticate_user! #, except: [:updatekur]
  before_action :set_kur, only: [:show, :edit, :update, :destroy]

  # GET /kurs
  # GET /kurs.json
  def index
    @search = Kur.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @kurs = @search.result.paginate(page: params[:page], per_page: 30)
  end

  # GET /kurs/1
  # GET /kurs/1.json
  def show
  end

  # GET /kurs/new
  def new
    if current_admin
      @kur = Kur.new
    else
      redirect_to dashboard_index_path
    end
  end

  # GET /kurs/1/edit
  def edit
  end

  # POST /kurs
  # POST /kurs.json
  def create
    @kur = Kur.new(kur_params)

    respond_to do |format|
      if @kur.save
        format.html { redirect_to @kur, notice: 'Kur was successfully created.' }
        format.json { render :show, status: :created, location: @kur }
      else
        format.html { render :new }
        format.json { render json: @kur.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kurs/1
  # PATCH/PUT /kurs/1.json
  def update
    respond_to do |format|
      if @kur.update(kur_params)
        format.html { redirect_to @kur, notice: 'Kur was successfully updated.' }
        format.json { render :show, status: :ok, location: @kur }
      else
        format.html { render :edit }
        format.json { render json: @kur.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kurs/1
  # DELETE /kurs/1.json
  def destroy
    @kur.destroy
    respond_to do |format|
      format.html { redirect_to kurs_url, notice: 'Kur was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def updatekur
    Kur.updatekur
    flash[:notice] = 'Загрузили'
    redirect_to dashboard_index_path
  end

  def update_snippet
    Insint.update_kurs_snippet(current_user.id)
    flash[:notice] = 'Обновили сниппет'
    redirect_to dashboard_index_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kur
      @kur = Kur.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kur_params
      params.require(:kur).permit(:date, :gbp, :byn, :usd, :eur, :kzt, :cny, :uah, :chf, :jpy)
    end
end
