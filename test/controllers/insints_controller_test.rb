require 'test_helper'

class InsintsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @insint = insints(:one)
  end

  test "should get index" do
    get insints_url
    assert_response :success
  end

  test "should get new" do
    get new_insint_url
    assert_response :success
  end

  test "should create insint" do
    assert_difference('Insint.count') do
      post insints_url, params: { insint: { insalesid: @insint.insalesid, password: @insint.password, subdomen: @insint.subdomen, user_id: @insint.user_id } }
    end

    assert_redirected_to insint_url(Insint.last)
  end

  test "should show insint" do
    get insint_url(@insint)
    assert_response :success
  end

  test "should get edit" do
    get edit_insint_url(@insint)
    assert_response :success
  end

  test "should update insint" do
    patch insint_url(@insint), params: { insint: { insalesid: @insint.insalesid, password: @insint.password, subdomen: @insint.subdomen, user_id: @insint.user_id } }
    assert_redirected_to insint_url(@insint)
  end

  test "should destroy insint" do
    assert_difference('Insint.count', -1) do
      delete insint_url(@insint)
    end

    assert_redirected_to insints_url
  end
end
