class Public::RelationshipsController < ApplicationController
  def create
    customer = Customer.find(params[:customer_id])
    current_customer.follow(customer)
    redirect_to request.referer
  end

  def destroy
    customer = Customer.find(params[:customer_id])
    current_customer.unfollow(customer)
    redirect_to  request.referer
  end

  def follower_customer
    @customer = Customer.find(params[:customer_id])
    @customers = @customer.follower_customer.where(is_active: true).page(params[:page]).per(4)
  end

  def followed_customer
    @customer = Customer.find(params[:customer_id])
    @customers = @customer.followed_customer.where(is_active: true).page(params[:page]).per(4)
  end
end
