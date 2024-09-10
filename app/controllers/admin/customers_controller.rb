class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update!(customer_params)  #!=失敗したら、falseではなくエラーメッセージを返す
    redirect_to admin_path
  end

  private
    def customer_params
      params.require(:customer).permit(:name, :profile_image, :preference, :weak, :email, :password, :is_active)
    end

end
