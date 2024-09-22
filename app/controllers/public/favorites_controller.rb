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
end
