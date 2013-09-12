require 'test_helper'

class LocalitiesControllerTest < ActionController::TestCase
  setup do
    @locality = localities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:localities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create locality" do
    assert_difference('Locality.count') do
      post :create, locality: { areacode: @locality.areacode, freight_cod: @locality.freight_cod, freight_paid: @locality.freight_paid, level: @locality.level, name: @locality.name, parent: @locality.parent, sort: @locality.sort, telcode: @locality.telcode, zipcode: @locality.zipcode }
    end

    assert_redirected_to locality_path(assigns(:locality))
  end

  test "should show locality" do
    get :show, id: @locality
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @locality
    assert_response :success
  end

  test "should update locality" do
    put :update, id: @locality, locality: { areacode: @locality.areacode, freight_cod: @locality.freight_cod, freight_paid: @locality.freight_paid, level: @locality.level, name: @locality.name, parent: @locality.parent, sort: @locality.sort, telcode: @locality.telcode, zipcode: @locality.zipcode }
    assert_redirected_to locality_path(assigns(:locality))
  end

  test "should destroy locality" do
    assert_difference('Locality.count', -1) do
      delete :destroy, id: @locality
    end

    assert_redirected_to localities_path
  end
end
