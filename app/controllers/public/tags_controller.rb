class Public::TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
    @ideas = @tag.ideas.where(is_active: true).page(params[:page]).per(4)
  end
end