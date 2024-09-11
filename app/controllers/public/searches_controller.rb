class Public::SearchesController < ApplicationController
  def search
    @model = params[:model]
    @word = params[:word]
    @method = params[:method]

    if @model  == "customer"
    @records = Customer.where.not(email: Customer::GUEST_USER_EMAIL)  #Customerの中にゲストユーザーは含まない
                       .where(is_active: true)  # is_activeがtrueのユーザーのみを取得
                       .search_for(@word, @method) # Customerモデル内を検索ワードと検索方法で検索して該当するユーザーを取得
                       .page(params[:page])
                       .per(4)  # ページネーションで1ページ4人
    else
      @records = Idea.where(is_active: true)  # is_activeがtrueのアイデアのみを取得
                     .search_for(@word, @method) # Customerモデル内を検索ワードと検索方法で検索して該当するユーザーを取得
                     .page(params[:page])
                     .per(4)
    end
  end
end
