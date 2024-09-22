class Public::TagsController < ApplicationController
  before_action :authenticate_customer!
  before_action :admin_notview!

  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
    @ideas = @tag.ideas.where(is_active: true).page(params[:page]).per(4)
  end
end