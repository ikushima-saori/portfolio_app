class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!  #adminログインしているか確認
  def top
    @customers = Customer.all.page(params[:page]).per(4)  #ユーザー一覧をページネーションする
  end
end
