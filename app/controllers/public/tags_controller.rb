class Public::TagsController < ApplicationController
  before_action :authenticate_customer!
  before_action :admin_notview!

  def index
    @tags = Tag.find(IdeaTag.pluck(:tag_id))  #Tagテーブルで探すのは中間テーブルにあるtagidのみ
  end  #ideaモデルでタグが削除された時に中間テーブルから関連付けを削除しているので、中間にidがある＝紐づいたideaがある

  def show
    @tag = Tag.find(params[:id])
    @ideas = @tag.ideas.where(is_active: true).page(params[:page]).per(4)
  end
end