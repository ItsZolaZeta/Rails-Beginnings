require "application_system_test_case"

class PinsTest < ApplicationSystemTestCase
  test 'create new pin' do
    user = User.new email: 'new@epfl.ch'
    user.save!
    visit(new_user_path)
    fill_in('Email', with: user.email)
    click_on('Log in')

    visit(new_pin_path)
    fill_in('Title', with: 'Orange sunset')
    fill_in('Tag', with: 'ocean')
    fill_in('Image url', with: "https://images.unsplash.com/photo-1604725333736-1f962a6218d0?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmVhdXRpZnVsJTIwc3Vuc2V0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80")
    click_on('Create Pin')
    assert page.has_content?('Orange sunset')
  end

  test 'editing a pin' do
    user = User.new email: 'new@epfl.ch'
    user.save!
    visit(new_user_path)
    fill_in('Email', with: user.email)
    click_on('Log in')

    pin = Pin.new title: 'Unedited pin', user: user
    pin.save!
    visit(edit_pin_path(pin))
    fill_in('Tag', with: 'new tags')
    fill_in('Title', with: 'Bali')
    click_on('Update Pin')

    assert page.has_content?('Bali')
    assert page.has_content?('new tags')
  end

  test 'search' do
    user = User.new email: 'new@epfl.ch'
    user.save!

    pin_1 = Pin.new title: 'Orange ocean', user: user
    pin_1.save!

    pin_2 = Pin.new title: 'Sunset ocean', user: user
    pin_2.save!

    visit(root_path)
    fill_in('q', with: 'Orange')
    click_on('Search', match: :first)

    assert current_path.include?(pins_search_path)
    assert page.has_content?('Orange ocean')
    refute page.has_content?('Sunset ocean')
  end

  test 'no search results' do
    visit(pins_search_path)
    assert page.has_content?('No pins found matching this search term!')
  end

  test 'root page has 6 most recent pins' do
    user = User.new email: 'new@epfl.ch'
    user.save!

    8.times do |i|
      pin = Pin.new title: "Exciting pin #{i+1}", user: User.new
      pin.save!
    end

    visit(root_path)

    assert page.has_content?('Exciting pin 8')
    assert page.has_content?('Exciting pin 7')
    assert page.has_content?('Exciting pin 6')
    assert page.has_content?('Exciting pin 5')
    assert page.has_content?('Exciting pin 4')
    assert page.has_content?('Exciting pin 3')
    refute page.has_content?('Exciting pin 2')
    refute page.has_content?('Exciting pin 1')
  end

  test 'search by title and tag' do
    pin_1 = Pin.new title: "Go cycling across Europe", 
                    user: User.new,
                    tag: "velo"
    pin_1.save!

    pin_2 = Pin.new title: "Visit Provence", 
                    user: User.new, 
                    tag: "cycling vineyards"
    pin_2.save!

    pin_3 = Pin.new title: "Overnight hike in Switzerland", 
                    user: User.new, 
                    tag: "mountains"
    pin_3.save!

    visit(root_path)

    fill_in('q', with: 'cycling')
    click_on('Search', match: :first)
    
    assert page.has_content?('Go cycling across Europe')
    assert page.has_content?('Visit Provence')
    refute page.has_content?('Overnight hike in Switzerland')
  end

  test 'new pin with no title' do
    user = User.new email: 'new@epfl.ch'
    user.save!

    visit(new_user_path)
    fill_in('Email', with: user.email)
    click_on('Log in')

    visit(new_pin_path())
    fill_in('Tag', with: 'ocean')
    click_on('Create Pin')
    assert page.has_content?("Title can't be blank")
  end

  test 'new pin with no tags too long' do
    user = User.new email: 'new@epfl.ch'
    user.save!

    visit(new_user_path)
    fill_in('Email', with: user.email)
    click_on('Log in')

    visit(new_pin_path())
    fill_in('Title', with: 'Orange sunset')
    fill_in('Tag', with: 'ocean ocean ocean ocean ocean ocean ocean ocean ocean ocean ocean')
    click_on('Create Pin')
    assert page.has_content?("Tag is too long (maximum is 30 characters)")
  end

  test 'existing pin updated with no title' do
    user = User.new email: 'new@epfl.ch'
    user.save!

    visit(new_user_path)
    fill_in('Email', with: user.email)
    click_on('Log in')

    pin = Pin.new title: "Exciting pin!", user: User.new
    pin.save!

    visit(edit_pin_path(pin))
    fill_in('Title', with: '')
    click_on('Update Pin')

    assert page.has_content?("Title can't be blank")
  end

  test 'existing pin updated with tags too long' do
    user = User.new email: 'new@epfl.ch'
    user.save!

    visit(new_user_path)
    fill_in('Email', with: user.email)
    click_on('Log in')

    pin = Pin.new title: "Exciting pin!", user: User.new
    pin.save!

    visit(edit_pin_path(pin))
    fill_in('Tag', with: 'ocean ocean ocean ocean ocean ocean ocean ocean ocean ocean ocean')
    click_on('Update Pin')

    assert page.has_content?("Tag is too long (maximum is 30 characters)")
  end

  test 'new pins cannot be made when not logged in' do
    visit(pins_path())
    refute page.has_content?('Create a new Pin')
  end

  test 'cannot edit pins or add to pinlist when not logged in' do
    pin = Pin.new title: "Exciting pin!", user: User.new
    pin.save!

    visit(pin_path(pin))
    refute page.has_content?('Edit')
    refute page.has_content?('Add to personal pin list')
  end

end
