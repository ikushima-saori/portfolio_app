class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!
  before_action :admin_notview!

  def search
    @model = params[:model]  #検索対象のモデル
    @word = params[:word]  #検索するキーワード
    @method = params[:method]  #検索方法

    if @model  == "customer"
      @records = Customer.where.not(email: Customer::GUEST_USER_EMAIL)  #Customerの中にゲストユーザーは含まない
                         .where(is_active: true)  # is_activeがtrueのユーザーのみを取得
                         .search_for(@word, @method) # Customerモデル内を検索ワードと検索方法で検索して該当するユーザーを取得
                         .order(:id)  #idで並べ替え
                         .page(params[:page]).per(4)
      @total_count = Customer.where.not(email: Customer::GUEST_USER_EMAIL)
                             .where(is_active: true)
                             .search_for(@word, @method)
                             .count
    else
      @records = Idea.where(is_active: true)  # is_activeがtrueのアイデアのみを取得
                     .search_for(@word, @method) # Customerモデル内を検索ワードと検索方法で検索して該当するユーザーを取得
                     .page(params[:page]).per(4)
      @total_count = Idea.where(is_active: true)
                         .search_for(@word, @method)
                         .count
    end
  end
end
