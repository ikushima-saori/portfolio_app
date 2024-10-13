class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!
  before_action :admin_notview!

  def create
    @idea = Idea.find(params[:idea_id])
    favorite = current_customer.favorites.new(idea_id: @idea.id)  #自分のお気に入りにidea_idが@ideaのidになっているideaを追加する
    favorite.save
  end

  def destroy
    @idea = Idea.find(params[:idea_id])
    favorite = current_customer.favorites.find_by(idea_id: @idea.id)  #自分のお気に入りからidea_idが@ideaのidになっているideaを探す
    favorite.destroy
  end

  def favorite_customers
    @idea = Idea.find(params[:id])
    customer_ids = @idea.favorites.pluck(:customer_id)  #favoritesテーブルから直接customer_idの値だけを配列として取得
    #@customers = @idea.favorites.includes(:customer).map(&:customer).page(params[:page]).per(4) ※includesとmapで一気に取得した配列はpageメソッドで使えない
    @customers = Customer.where(id: customer_ids).page(params[:page]).per(4)  #取得したcustomer_idsからお気に入りしてくれている全てのユーザーを取得
  end
end