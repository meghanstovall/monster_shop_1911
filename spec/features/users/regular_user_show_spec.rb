require 'rails_helper'

RSpec.describe 'as a regular user' do
  before(:each) do
    @regular_user = User.create!(name: "Mike",
                                street_address: "456 Logan St. Denver, CO",
                                city: "denver",state: "CO",
                                zip: "80206",
                                email: "new_email1@gmail.com",
                                password: "hamburger1",
                                role: 1)
    visit '/'
    click_link 'Login'
    expect(current_path).to eq('/login')

    fill_in :email, with: @regular_user.email
    fill_in :password, with: 'hamburger1'
    click_button 'Log In'
    end

  it 'I visit my show page and see all info and a link to edit ' do
    expect(current_path).to eq('/profile')
    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@regular_user.street_address)
    expect(page).to have_content(@regular_user.city)
    expect(page).to have_content(@regular_user.state)
    expect(page).to have_content(@regular_user.zip)
    expect(page).to have_content(@regular_user.email)
    expect(page).to have_link('Edit Profile')
    expect(page).to_not have_content('hamburger1')
  end

  it "can edit my profile" do
    click_link 'Edit Profile'
    expect(current_path).to eq("/profile/#{@regular_user.id}/edit")
    expect(page).to have_content(@regular_user.name)
    expect(page).to_not have_content('hamburger1')

    fill_in :name, with: 'bob'
    fill_in :password, with: 'hamburger1'
    fill_in :password_confirmation, with: 'hamburger1'
    click_button 'Submit'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('bob')
    expect(page).to_not have_content(@regular_user.name)
    expect(page).to have_content("Changes Made to Profile Successfully")
  end
end
