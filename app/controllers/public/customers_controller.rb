class Public::CustomersController < ApplicationController
  def index
  end

  def show
    if params[:id]
      @customer = Customer.find(params[:id])
    else
      @customer = current_customer
    end
    @ideas = Idea.all
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      flash[:notice] = "プロフィールが更新されました！"
      redirect_to my_page_path
    else
      render :edit
    end
  end

  def out
    @customer = current_customer
    @customer.update(is_active: false)
    reset_session
    flash[:notice] = "退会しました"
    redirect_to root_path
  end

  private
    def customer_params
      params.require(:customer).permit(:name, :profile_image, :preference, :weak, :email, :password)
    end

end
