class Admin::HomesController < ApplicationController
  def top
    @customers = Customer.all.page(params[:page]).per(8)
  end
end
