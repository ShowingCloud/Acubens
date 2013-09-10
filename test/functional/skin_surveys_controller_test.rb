require 'test_helper'

class SkinSurveysControllerTest < ActionController::TestCase
  setup do
    @skin_survey = skin_surveys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:skin_surveys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create skin_survey" do
    assert_difference('SkinSurvey.count') do
      post :create, skin_survey: { age: @skin_survey.age, brands: @skin_survey.brands, care: @skin_survey.care, cost: @skin_survey.cost, effects: @skin_survey.effects, factors: @skin_survey.factors, importance: @skin_survey.importance, infos: @skin_survey.infos, markets: @skin_survey.markets, offline: @skin_survey.offline, problems: @skin_survey.problems, procedures: @skin_survey.procedures, shortcomings: @skin_survey.shortcomings, source: @skin_survey.source, style: @skin_survey.style, time: @skin_survey.time, user: @skin_survey.user, ways: @skin_survey.ways }
    end

    assert_redirected_to skin_survey_path(assigns(:skin_survey))
  end

  test "should show skin_survey" do
    get :show, id: @skin_survey
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @skin_survey
    assert_response :success
  end

  test "should update skin_survey" do
    put :update, id: @skin_survey, skin_survey: { age: @skin_survey.age, brands: @skin_survey.brands, care: @skin_survey.care, cost: @skin_survey.cost, effects: @skin_survey.effects, factors: @skin_survey.factors, importance: @skin_survey.importance, infos: @skin_survey.infos, markets: @skin_survey.markets, offline: @skin_survey.offline, problems: @skin_survey.problems, procedures: @skin_survey.procedures, shortcomings: @skin_survey.shortcomings, source: @skin_survey.source, style: @skin_survey.style, time: @skin_survey.time, user: @skin_survey.user, ways: @skin_survey.ways }
    assert_redirected_to skin_survey_path(assigns(:skin_survey))
  end

  test "should destroy skin_survey" do
    assert_difference('SkinSurvey.count', -1) do
      delete :destroy, id: @skin_survey
    end

    assert_redirected_to skin_surveys_path
  end
end
