class Admin::CustomersController < ApplicationController
  before_action :customer_notview!
  before_action :admin_login!

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update!(customer_params)  #!=失敗したら、falseを返すのではなく処理を中断してエラーを返すだけでいいのでif分岐ではなく[!]で対応
    redirect_to admin_path
  end

  private
    def customer_params
      params.require(:customer).permit(:name, :profile_image, :preference, :weak, :is_active)
    end

end
