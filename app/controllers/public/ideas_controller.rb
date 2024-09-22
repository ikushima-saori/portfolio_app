class Public::IdeasController < ApplicationController
  before_action :authenticate_customer!
  before_action :is_matching_login_customer, only: [:edit, :update, :destroy]  #privateで定義　自分以外のアイデアの編集削除を禁止
  before_action :admin_notview!

  def new
    @idea = Idea.new
  end

  def create
    @idea = Idea.new(idea_params)
    @idea.customer_id = current_customer.id
    tag_list = params[:idea][:tag_list].split(",").map(&:strip)  #new.htmlのf.text_field :tag_listに入力されたタグをカンマ区切りで空白を消して格納
    @idea.save_tag(tag_list)  #ideaモデルで定義　タグの保存
    if @idea.save
      flash[:notice] = "アイデアをメモしました！"
      redirect_to edit_idea_path(@idea.id)
    else
      render :new
    end
  end

  def edit
    @idea = Idea.find(params[:id])
    @tag_list = @idea.tags.pluck(:word).join(', ')  #@ideaのタグwordをカンマで区切って(繋げて)表示する
  end

  def update
    @idea = Idea.find(params[:id])
    if @idea.update(idea_params)
      tag_list = params[:idea][:tag_names].split(",").map(&:strip)  #edit.htmlのf.text_field :tag_namesに入力されたタグをカンマ区切りで空白を消して格納
      @idea.save_tag(tag_list)  #ideaモデルで定義　タグの保存
      flash[:notice] = "変更が保存されました！"
      redirect_to edit_idea_path(@idea.id)
    else
      render :edit
    end
  end

  def destroy
    @idea =Idea.find(params[:id])
    @idea.destroy
    flash[:notice] = "アイデアが削除されました"
    redirect_to request.referer
  end

  private
    def is_matching_login_customer  #自分以外のユーザーのアイデアにはアクセスできないようにするために定義
      @idea = Idea.find(params[:id])
      unless @idea.customer == current_customer
        redirect_to my_page_path, alert: 'アクセス権がありません。'
      end
    end

    def idea_params
      params.require(:idea).permit(:introduction, :title, :body, :is_active, :tag_names)
    end
end
