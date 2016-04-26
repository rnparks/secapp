require 'test_helper'

class SubsControllerTest < ActionController::TestCase
  setup do
    @sub = subs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subs)
  end

  test "should show sub" do
    get :show, id: @sub
    assert_response :success
  end
end
