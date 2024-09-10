class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @customers = Customer.where.not(email: Customer::GUEST_USER_EMAIL)  #Customer.allの中にゲストユーザーは含まない
                       .where(is_active: true)  # is_activeがtrueのユーザーのみを取得
                       .page(params[:page])
                       .per(4)  # ページネーションで1ページ5人
  end

  def show
    if params[:id]
      @customer = Customer.find(params[:id])
      if @customer != current_customer
        @ideas = @customer.ideas.where(is_active: true)
      else
        @ideas = @customer.ideas
      end
    else
      @customer = current_customer
      @ideas = @customer.ideas
    end
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
    flash[:notice] = "退会しました。"
    redirect_to new_customer_registration_path
  end

  private
    def customer_params
      params.require(:customer).permit(:name, :profile_image, :preference, :weak, :email, :password)
    end

end
