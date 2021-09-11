require "application_system_test_case"

class PinCommentsTest < ApplicationSystemTestCase
  test 'adding a Comment to a pin' do
    user = User.new email: 'new@epfl.ch'
    user.save!

    visit(new_user_path)
    fill_in('Email', with: user.email)
    click_on('Log in')

    pin = Pin.new title: 'Watermelon', user: user
    pin.save!

    visit(new_user_path)
    fill_in('Email', with: user.email)
    click_on('Log in')

    visit(pin_path(pin))
    fill_in('Add a comment', with: 'Cool fruit!')
    click_on('Post', match: :first)
    assert_equal pin_path(pin), page.current_path
    assert page.has_content?('Cool fruit!')
  end

  test 'comments cannot be added when not logged in' do
    pin = Pin.new title: 'Ocean', user: User.new
    pin.save!

    visit(pin_path(pin))
    refute page.has_content?('Add a comment')
  end
end
