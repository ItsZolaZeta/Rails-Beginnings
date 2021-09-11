require "application_system_test_case"

class NavigationTestsTest < ApplicationSystemTestCase
  test 'search term is displayed' do
    visit('/')
    assert page.has_content?('Pinterest')
    fill_in('q', with: 'sunset')
    click_on('Search')
    assert has_content?('sunset')
    assert current_url.include?('q=sunset')
  end

  test 'navbar navigation' do 
    visit('/')
    click_on('Pinterest')
    assert page.has_content?('About')
    assert page.has_content?('Login/Sign up')
    click_on('Login/Sign up')
    assert page.has_content?('Email')
    fill_in('user_email', with: '1234@epfl.ch')
    click_on('Log in')
    assert page.has_content?('Pin List')
  end
end
