class Public::RelationshipsController < ApplicationController
  before_action :authenticate_customer!
  before_action :admin_notview!

  def create
    customer = Customer.find(params[:id])
    current_customer.follow(customer)
    redirect_to request.referer
  end

  def destroy
    customer = Customer.find(params[:id])
    current_customer.unfollow(customer)
    redirect_to  request.referer
  end

  def follower_customer  #自分がフォローしているユーザーを取得する
    @customer = Customer.find(params[:id])
    @customers = @customer.follower_customer.where(is_active: true).page(params[:page]).per(4)
  end

  def followed_customer  #自分をフォローしているユーザーを取得する
    @customer = Customer.find(params[:id])
    @customers = @customer.followed_customer.where(is_active: true).page(params[:page]).per(4)
  end
end
