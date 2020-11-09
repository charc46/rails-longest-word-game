require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "p", count: 10
  end

  test "Clicking submit takes us to the score page" do
    visit new_url
    fill_in "answer", with: "wrong"
    click_on "Play"

    assert_text "Sorry but WRONG is not in the grid."
  end
end
