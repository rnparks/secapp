require 'test_helper'

class XbrlsControllerTest < ActionController::TestCase
  setup do
    @xbrl = xbrls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:xbrls)
  end

  test "should show num" do
    get :show, id: @xbrl
    assert_response :success
  end
end
