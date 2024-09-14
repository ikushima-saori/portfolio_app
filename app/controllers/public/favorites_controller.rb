class Public::FavoritesController < ApplicationController
  def create
    @idea = Idea.find(params[:idea_id])
    favorite = current_customer.favorites.new(idea_id: @idea.id)
    favorite.save
  end

  def destroy
    @idea = Idea.find(params[:idea_id])
    favorite = current_customer.favorites.find_by(idea_id: @idea.id)
    favorite.destroy
  end
end
