class Public::IdeasController < ApplicationController
  def index
  end

  def new
    @idea = Idea.new
  end

  def create
    @idea = Idea.new(idea_params)
    @idea.customer_id = current_customer.id
    if @idea.save
      flash[:notice] = "ネタをメモしました！"
      redirect_to edit_idea_path(@idea.id)
    else
      flash[:notice] = "アイデアが入力されていません"
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def tags
  end

  def search
  end

  private

  def idea_params
    params.require(:idea).permit(:introduction, :title, :body, :is_active)
  end

end
