require 'test_helper'

class NumsControllerTest < ActionController::TestCase
  setup do
    @num = nums(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nums)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create num" do
    assert_difference('Num.count') do
      post :create, num: {  }
    end

    assert_redirected_to num_path(assigns(:num))
  end

  test "should show num" do
    get :show, id: @num
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @num
    assert_response :success
  end

  test "should update num" do
    patch :update, id: @num, num: {  }
    assert_redirected_to num_path(assigns(:num))
  end

  test "should destroy num" do
    assert_difference('Num.count', -1) do
      delete :destroy, id: @num
    end

    assert_redirected_to nums_path
  end
end
