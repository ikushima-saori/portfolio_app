class ApplicationController < ActionController::Base
  before_action :restrict_guest_access

  protected
  def restrict_guest_access  #ゲストユーザーにアクセス制限をかける
    if guest_user_signed_in?  #ゲストユーザーかどうかをチェックする
      unless allowed_guest_actions?  #ゲストユーザーがアクセスできるアクションかチェックする
        redirect_to root_path, alert: 'ゲストユーザーはTOPとaboutページのみ閲覧可能です。'
      end
    end
  end

  def guest_user_signed_in?
    customer_signed_in? && current_customer.email == Customer::GUEST_USER_EMAIL #メールアドレスがゲストのアドレスかどうか
  end


  def allowed_guest_actions?
    controller_name == 'homes' && %w[top about].include?(action_name) || controller_name == 'sessions' && action_name == 'destroy'  #ゲストユーザーはhomesのtopとaboutしかアクセスできない
  end
end
