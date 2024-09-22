class Admin::HomesController < ApplicationController
  before_action :customer_notview!
  before_action :admin_login!

  def top
    @customers = Customer.all.page(params[:page]).per(4)  #ユーザー一覧をページネーションする
  end
end
