class Public::FavoritesController < ApplicationController
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
