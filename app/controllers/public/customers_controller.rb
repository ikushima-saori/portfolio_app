class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @customers = Customer.where.not(email: Customer::GUEST_USER_EMAIL)  #Customer.allの中にゲストユーザーは含まない
                       .where(is_active: true)  # is_activeがtrueのユーザーのみを取得
                       .page(params[:page])
                       .per(4)  # ページネーションで1ページ4人
  end

  def show
    if params[:id]
      @customer = Customer.find(params[:id])
      if @customer != current_customer
        @ideas = @customer.ideas.where(is_active: true).page(params[:page]).per(4)
      else
        @ideas = @customer.ideas.page(params[:page]).per(4)
      end
    else
      @customer = current_customer
      @ideas = @customer.ideas.page(params[:page]).per(4)
    end
    @favorite_ideas_count = @customer.favorites.count
  end

  def favorite
    @customer = Customer.find(params[:id])
    @favorite_ideas = @customer.favorites.joins(:idea).select('ideas.*').page(params[:page]).per(4)
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
