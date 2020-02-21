require "rails_helper"

describe "user edit page" do
  before(:each) do
    @user_1 = User.create!(
      name: "Peter Webber",
      street_address: "30 Girls Street",
      city: "Los Angeles",
      state: "CA",
      zip: 90036,
      email: "pilotpete@gmail.com",
      password: "password1",
      password_confirmation: "password1",
      role: 1)

    @user_2 = User.create!(
      name: "Jaffar",
      street_address: "30 Girls Street",
      city: "Los Angeles",
      state: "CA",
      zip: 90036,
      email: "jaffar@gmail.com",
      password: "password1!",
      password_confirmation: "password1!",
      role: 1)
  end

  it "can see flash message when trying to change email to one thats already in use" do

    visit "/login"

    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password
    click_button "Log In"

    expect(current_path).to eq("/profile")
    click_link "Edit Profile"

    fill_in :email, with: @user_2.email
    fill_in :password, with: @user_1.password
    fill_in :password_confirmation, with: @user_1.password_confirmation
    click_button "Submit"

    expect(current_path).to eq("/profile/#{@user_1.id}/edit")
    expect(page).to have_content("Email has already been taken")
  end
end
