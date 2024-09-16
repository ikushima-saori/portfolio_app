class Public::IdeasController < ApplicationController
  before_action :authenticate_customer!
  before_action :is_matching_login_customer, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @idea = Idea.new
  end

  def create
    @idea = Idea.new(idea_params)
    @idea.customer_id = current_customer.id
    tag_list = params[:idea][:tags].split(",").map(&:strip) # カンマで分割し、空白を削除
    if @idea.save
      @idea.save_tag(tag_list)  # タグを保存
      flash[:notice] = "アイデアをメモしました！"
      redirect_to edit_idea_path(@idea.id)
    else
      flash[:notice] = "アイデアを入力してください"
      render :new
    end
  end

  def edit
    @idea = Idea.find(params[:id])
    @tag_list = @idea.tags.pluck(:word).join(', ')
  end

  def update
    @idea = Idea.find(params[:id])
    if @idea.update(idea_params)
      tag_list = params[:idea][:tag_names].split(",").map(&:strip)  # タグのリストを分割
      @idea.save_tag(tag_list)  # タグを保存
      flash[:notice] = "変更が保存されました！"
      redirect_to edit_idea_path(@idea.id)
    else
      flash[:notice] = "アイデアを入力してください"
      render :edit
    end
  end

  def destroy
    @idea =Idea.find(params[:id])
    @idea.destroy
    flash[:notice] = "アイデアが削除されました"
    redirect_to request.referer
  end

  def tags
  end

  def search
  end

  private
    def is_matching_login_customer
      @idea = Idea.find(params[:id])
      unless @idea.customer == current_customer
        redirect_to my_page_path, alert: 'アクセス権がありません。'
      end
    end

    def idea_params
      params.require(:idea).permit(:introduction, :title, :body, :is_active, :tag_names)
    end
end
