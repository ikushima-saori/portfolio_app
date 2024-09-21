class ApplicationController < ActionController::Base
  before_action :restrict_guest_access
  helper_method :guest_user_signed_in? #application.htmlでguest_user_signed_in?を使いたいのでhelper_methodとして設定(viewではcontrollerに定義したメソッドを直で使えない)

  protected
  def restrict_guest_access  #ゲストユーザーにアクセス制限をかける
    if guest_user_signed_in?  #ゲストユーザーかどうかをチェックする
      unless allowed_guest_actions?  #ゲストユーザーがアクセスできるアクションかチェックする
        redirect_to root_path, alert: 'ゲストユーザーはTOPとaboutページのみ閲覧可能です。'
      end
    end
  end

  def guest_user_signed_in? #メールアドレスがゲストのアドレスかどうか
    customer_signed_in? && current_customer.email == Customer::GUEST_USER_EMAIL #GUEST_USER_EMAILはcustomerモデルで定義
  end


  def allowed_guest_actions?  #ゲストユーザーはhomesコントローラのtopとabout、sesstionsコントローラのdestroyしかアクセスできない
    controller_name == 'homes' && %w[top about].include?(action_name) || controller_name == 'sessions' && action_name == 'destroy'
  end
end
