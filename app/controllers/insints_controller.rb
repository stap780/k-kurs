class InsintsController < ApplicationController
  before_action :authenticate_user! , except: [:install, :uninstall, :login, :setup_script]
  before_action :set_insint, only: [:show, :edit, :update, :destroy]

  # GET /insints
  # GET /insints.json
  def index
    @insints = current_user.insints
  end

  def adminindex
    @search = Insint.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @insints = @search.result.paginate(page: params[:page], per_page: 30)
  end


  # GET /insints/1
  # GET /insints/1.json
  def show
  end

  # GET /insints/new
  def new
    @insint = Insint.new
  end

  # GET /insints/1/edit
  def edit
  end

  # POST /insints
  # POST /insints.json
  def create
    @insint = Insint.new(insint_params)

    respond_to do |format|
      if @insint.save
        format.html { redirect_to @insint, notice: 'Интеграция создана.' }
        format.json { render :show, status: :created, location: @insint }
      else
        format.html { render :new }
        format.json { render json: @insint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /insints/1
  # PATCH/PUT /insints/1.json
  def update
    respond_to do |format|
      if @insint.update(insint_params)
        format.html { redirect_to @insint, notice: 'Интеграция обновлена.' }
        format.json { render :show, status: :ok, location: @insint }
      else
        format.html { render :edit }
        format.json { render json: @insint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /insints/1
  # DELETE /insints/1.json
  def destroy
    @insint.destroy
    respond_to do |format|
      format.html { redirect_to insints_url, notice: 'Интеграция удалена.' }
      format.json { head :no_content }
    end
  end

  def install
    # puts params[:insales_id]
    @insint = Insint.find_by_insalesid(params[:insales_id])
    if @insint.present?
      puts "есть пользователь insint"
    else
      save_subdomain = "insales"+params[:insales_id]
      email = save_subdomain+"@mail.ru"
      # puts save_subdomain
      valid_from = Time.now
      valid_until = valid_from + 1.year
      user = User.create(:name => params[:insales_id], :subdomain => save_subdomain, :password => save_subdomain, :password_confirmation => save_subdomain, :email => email, :valid_from => valid_from, :valid_until => valid_until)
      puts "user id - "+user.id.to_s+" - должно быть здесь"
      secret_key = ENV["INS_APP_SECRET_KEY"]
      password = Digest::MD5.hexdigest(params[:token] + secret_key)
      insint_new = Insint.create(:subdomen => params[:shop],  password: password, insalesid: params[:insales_id], :user_id => user.id)
      Insint.setup_ins_shop(insint_new.id)
      head :ok
      # render status: 200
      ## ниже обновляем почту клиента из инсалес и письмо нам о том что зарегился клиент
      Insint.update_and_email(insint_new.id)
    end
  end

  def uninstall
    @insint = Insint.find_by_insalesid(params[:insales_id])
    saved_subdomain = "insales"+params[:insales_id]
    @user = User.find_by_subdomain(saved_subdomain)
    if @insint.present?
      Insint.delete_ins_file(@insint.id)
      puts "удаляем пользователя insint - ""#{@insint.id}"
      @insint.delete
      @user.delete
      Apartment::Tenant.drop(saved_subdomain)
      head :ok
    end
  end

  def login
    @insint = Insint.find_by_insalesid(params[:insales_id])
    saved_subdomain = "insales"+params[:insales_id]
    Apartment::Tenant.switch!(saved_subdomain)
    @user = User.find_by_subdomain(saved_subdomain)
    if @user.present?
      # puts @user.present?
      if @insint.present?
          sign_in(:user, @user)
          redirect_to after_sign_in_path_for(@user)
      end
    end
  end

  def setup_script
    Insint.setup_ins_shop(params[:insint_id])
    respond_to do |format|
        # format.html { :controller => 'useraccount', :action => 'index', notice: 'Скрипты добавлены в магазин' }
        format.html { redirect_to dashboard_index_path, notice: 'Скрипты добавлены в магазин' }
    end
  end

  def delete_script
    Insint.delete_ins_file(params[:insint_id])
    respond_to do |format|
        # format.html { :controller => 'useraccount', :action => 'index', notice: 'Скрипты добавлены в магазин' }
        format.html { redirect_to dashboard_index_path, notice: 'Скрипты удалены из магазин' }
    end
  end

  def checkint
    insint = Insint.find(params[:insint_id])
    if insint.inskey.present?
      uri = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/account.json"
    else
      uri = "http://k-comment.ru"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/account.json"
    end
    # puts uri
    RestClient.get( uri, {:content_type => 'application/json', accept: :json}) { |response, request, result, &block|
            # puts response.code
            case response.code
            when 200
              @check_status = true
            when 401
              @check_status = false
            else
              response.return!(&block)
            end
            }
    respond_to do |format|
        format.js do
          if @check_status == true
            flash.now[:notice] = "Интеграция работает!"
          end
          if @check_status == false
            flash.now[:error] = "Не работает интеграция!"
          end
        end
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_insint
      @insint = Insint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def insint_params
      params.require(:insint).permit(:subdomen, :password, :insalesid, :user_id, :inskey, :status)
    end
end
