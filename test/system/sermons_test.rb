require "application_system_test_case"

class SermonsTest < ApplicationSystemTestCase
  setup do
    @sermon = sermons(:one)
  end

  test "visiting the index" do
    visit sermons_url
    assert_selector "h1", text: "Sermons"
  end

  test "should create sermon" do
    visit sermons_url
    click_on "New sermon"

    fill_in "Description", with: @sermon.description
    fill_in "Link", with: @sermon.link
    fill_in "Title", with: @sermon.title
    click_on "Create Sermon"

    assert_text "Sermon was successfully created"
    click_on "Back"
  end

  test "should update Sermon" do
    visit sermon_url(@sermon)
    click_on "Edit this sermon", match: :first

    fill_in "Description", with: @sermon.description
    fill_in "Link", with: @sermon.link
    fill_in "Title", with: @sermon.title
    click_on "Update Sermon"

    assert_text "Sermon was successfully updated"
    click_on "Back"
  end

  test "should destroy Sermon" do
    visit sermon_url(@sermon)
    click_on "Destroy this sermon", match: :first

    assert_text "Sermon was successfully destroyed"
  end
end
