require 'test_helper'

class KursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @kur = kurs(:one)
  end

  test "should get index" do
    get kurs_url
    assert_response :success
  end

  test "should get new" do
    get new_kur_url
    assert_response :success
  end

  test "should create kur" do
    assert_difference('Kur.count') do
      post kurs_url, params: { kur: { byn: @kur.byn, chf: @kur.chf, cny: @kur.cny, date: @kur.date, eur: @kur.eur, gbp: @kur.gbp, jpy: @kur.jpy, kzt: @kur.kzt, uah: @kur.uah, usd: @kur.usd } }
    end

    assert_redirected_to kur_url(Kur.last)
  end

  test "should show kur" do
    get kur_url(@kur)
    assert_response :success
  end

  test "should get edit" do
    get edit_kur_url(@kur)
    assert_response :success
  end

  test "should update kur" do
    patch kur_url(@kur), params: { kur: { byn: @kur.byn, chf: @kur.chf, cny: @kur.cny, date: @kur.date, eur: @kur.eur, gbp: @kur.gbp, jpy: @kur.jpy, kzt: @kur.kzt, uah: @kur.uah, usd: @kur.usd } }
    assert_redirected_to kur_url(@kur)
  end

  test "should destroy kur" do
    assert_difference('Kur.count', -1) do
      delete kur_url(@kur)
    end

    assert_redirected_to kurs_url
  end
end
