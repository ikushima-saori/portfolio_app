require "test_helper"

class Admin::CustomersControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get admin_customers_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_customers_update_url
    assert_response :success
  end
end
