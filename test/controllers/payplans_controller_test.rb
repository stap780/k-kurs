require 'test_helper'

class PayplansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payplan = payplans(:one)
  end

  test "should get index" do
    get payplans_url
    assert_response :success
  end

  test "should get new" do
    get new_payplan_url
    assert_response :success
  end

  test "should create payplan" do
    assert_difference('Payplan.count') do
      post payplans_url, params: { payplan: { period: @payplan.period, price: @payplan.price } }
    end

    assert_redirected_to payplan_url(Payplan.last)
  end

  test "should show payplan" do
    get payplan_url(@payplan)
    assert_response :success
  end

  test "should get edit" do
    get edit_payplan_url(@payplan)
    assert_response :success
  end

  test "should update payplan" do
    patch payplan_url(@payplan), params: { payplan: { period: @payplan.period, price: @payplan.price } }
    assert_redirected_to payplan_url(@payplan)
  end

  test "should destroy payplan" do
    assert_difference('Payplan.count', -1) do
      delete payplan_url(@payplan)
    end

    assert_redirected_to payplans_url
  end
end
