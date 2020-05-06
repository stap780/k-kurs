class DashboardController < ApplicationController
  def index
    insint = current_user.insints.first
    if insint.present?
      if insint.inskey.present?
        uri = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/products/count.json"
      else
        uri = "http://k-comment:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/products/count.json"
        url = "http://k-comment:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/account.json"
      end
        puts uri
        response = RestClient.get(uri)
        data = JSON.parse(response)
        @product_count = data['count']
    end
  end # index

  def users
    @q = User.ransack(params[:q])
    @q.sorts = 'id desc' if @q.sorts.empty?
    @users = @q.result.paginate(page: params[:page], per_page: 30)
  end

  def user_destroy
    @user = User.find(params[:user_id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def test_email
    User.service_end_email
    # Client.emailizb('fishartel', 29250124, 64 ) #development test
    # Client.emailizb('insales22810', 27968659, 20 ) #production test
    flash[:notice] = 'Отправили'
		redirect_to dashboard_index_path
  end

end # index
