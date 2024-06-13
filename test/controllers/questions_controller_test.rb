require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

  setup do
    @question = questions(:one)
  end

  test "should get index" do
    get question_url
    assert_response :success
  end

  test "should get new" do
    get question_url
    assert_response :success
  end

  test "should create question" do
    assert_difference("Question.count") do
      post question_url, params: { question: { template_id: @question.template_id, text: @question.text, type: @question.type } }
    end

    assert_redirected_to question_url(Question.last)
  end

  test "should show question" do
    get question_url(@question)
    assert_response :success
  end

  test "should get edit" do
      get question_url(@question)
    assert_response :success
  end

  test "should update question" do
    patch question_url(@question), params: { question: { template_id: @question.template_id, text: @question.text, type: @question.type } }
    assert_redirected_to question_url(@question)
  end

  test "should destroy question" do
    assert_difference("Question.count", -1) do
      delete question_url(@question)
    end

    assert_redirected_to question_url
  end
end
