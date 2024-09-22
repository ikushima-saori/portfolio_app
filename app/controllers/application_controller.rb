class ApplicationController < ActionController::Base
  before_action :restrict_guest_access  #↓で定義  全てのcontrollerにゲストのアクセス制限を適用
  helper_method :guest_user_signed_in?  #↓で定義  application.htmlでguest_user_signed_in?を使いたいのでhelper_methodとして設定(viewではcontrollerに定義したメソッドを直で使えない)

  protected

  #ゲストユーザーにアクセス制限をかける
  def restrict_guest_access
    if guest_user_signed_in?  #↓で定義
      unless allowed_guest_actions?  #↓で定義
        redirect_to root_path, alert: 'ゲストユーザーはTOPとaboutページのみ閲覧可能です。'
      end
    end
  end
  def guest_user_signed_in? #メールアドレスがゲストのアドレスかどうか
    customer_signed_in? && current_customer.email == Customer::GUEST_USER_EMAIL #GUEST_USER_EMAILはcustomerモデルで定義
  end
  def allowed_guest_actions?  #homesコントローラのtopとabout、sesstionsコントローラのdestroyしかアクセスできない
    controller_name == 'homes' && %w[top about].include?(action_name) || controller_name == 'sessions' && action_name == 'destroy'
  end

  #adminコントローラアクセス制限用
   def admin_login!  #管理者としてログインしていなければアクセスさせない
     unless admin_signed_in?
       redirect_to root_path, alert: "管理者としてログインしてください。"
     end
   end
  def customer_notview!  #ユーザーとしてログインしている場合はアクセスさせない
    if customer_signed_in?
      redirect_to root_path, alert: '管理者としてログインしてください。'
    end
  end

  #publicコントローラアクセス制限用
   def admin_notview!  #管理者としてログインしている場合はアクセスさせない
     if admin_signed_in?
       redirect_to admin_path, alert: "ユーザーとしてログインしてください。"
     end
   end

end