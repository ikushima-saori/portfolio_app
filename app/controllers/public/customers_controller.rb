class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :admin_notview!

  def index
    @customers = Customer.where(is_active: true)  #is_activeがtrueのユーザーのみを取得
                         .where.not(email: "guest@example.com")  #Customer.allの中にゲストユーザーは含まない
                         .order(:id)  #idで並べ替え
                         .page(params[:page]).per(4)  # ページネーションで1ページ4人
  end

  def show
    if params[:id]  #currentユーザーの詳細URLにidは含まれないので、
      @customer = Customer.find(params[:id])  #idがあればidユーザーの情報
      if @customer != current_customer  #自分以外の詳細ページの場合
        @ideas = @customer.ideas.where(is_active: true).order(updated_at: :desc, created_at: :desc).page(params[:page]).per(4)  #投稿ステータスが公開のアイデアのみ含める
      else
        @ideas = @customer.ideas.page(params[:page]).per(4)  #自分は全てのアイデアを取得
      end
    else
      @customer = current_customer  #idが無ければcurrentユーザーの情報
      @ideas = @customer.ideas.page(params[:page]).per(4)
    end
    @favorite_ideas_count = @customer.favorites.count  #ユーザーのお気に入りアイデアの数を取得
  end

  def favorite
    @customer = Customer.find(params[:id])
    @favorite_ideas = Idea.joins(:favorites)  #favoritesとideasテーブルを結合
                         .where(favorites: { customer_id: @customer.id })  #favoritesテーブルからcustomerに紐づいたお気に入りアイデアを取得
                         .where(is_active: true)  #公開状態のみを含める
                         .includes(:tags)  # アイデアに関連するタグも同時に読み込むためのメソッド
                         .order(updated_at: :desc, created_at: :desc)
                         .page(params[:page]).per(4)
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      flash[:notice] = "プロフィールが更新されました！"
      redirect_to my_page_path
    else
      render :edit
    end
  end

  def out
    @customer = current_customer
    @customer.update(is_active: false)  #更新時にis_activeをfalseに変更
    reset_session  #sessionをリセットしてログアウト状態に
    flash[:notice] = "退会しました。"
    redirect_to new_customer_registration_path
  end

  private
    def customer_params
      params.require(:customer).permit(:name, :profile_image, :preference, :weak)
    end

end
