require 'test_helper'

class SchedPrevisionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sched_previsions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sched_prevision" do
    assert_difference('SchedPrevision.count') do
      post :create, :sched_prevision => { }
    end

    assert_redirected_to sched_prevision_path(assigns(:sched_prevision))
  end

  test "should show sched_prevision" do
    get :show, :id => sched_previsions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sched_previsions(:one).to_param
    assert_response :success
  end

  test "should update sched_prevision" do
    put :update, :id => sched_previsions(:one).to_param, :sched_prevision => { }
    assert_redirected_to sched_prevision_path(assigns(:sched_prevision))
  end

  test "should destroy sched_prevision" do
    assert_difference('SchedPrevision.count', -1) do
      delete :destroy, :id => sched_previsions(:one).to_param
    end

    assert_redirected_to sched_previsions_path
  end
end
