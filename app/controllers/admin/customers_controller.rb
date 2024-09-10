class Admin::CustomersController < ApplicationController
  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admin_path
    else
      render :edit
    end
  end

  private
    def customer_params
      params.require(:customer).permit(:name, :profile_image, :preference, :weak, :email, :password, :is_active)
    end

end
