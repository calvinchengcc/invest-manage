require 'test_helper'

class HoldingsControllerTest < ActionController::TestCase
  setup do
    @holding = holdings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:holdings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create holding" do
    assert_difference('Holding.count') do
      post :create, holding: { datetime: @holding.datetime, exchange: @holding.exchange, holding_id: @holding.holding_id, num_shares: @holding.num_shares, portfolio_id: @holding.portfolio_id, price: @holding.price, symbol: @holding.symbol }
    end

    assert_redirected_to holding_path(assigns(:holding))
  end

  test "should show holding" do
    get :show, id: @holding
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @holding
    assert_response :success
  end

  test "should update holding" do
    patch :update, id: @holding, holding: { datetime: @holding.datetime, exchange: @holding.exchange, holding_id: @holding.holding_id, num_shares: @holding.num_shares, portfolio_id: @holding.portfolio_id, price: @holding.price, symbol: @holding.symbol }
    assert_redirected_to holding_path(assigns(:holding))
  end

  test "should destroy holding" do
    assert_difference('Holding.count', -1) do
      delete :destroy, id: @holding
    end

    assert_redirected_to holdings_path
  end
end
