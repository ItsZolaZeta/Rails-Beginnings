require 'test_helper'

class PinTest < ActiveSupport::TestCase
  test 'the first empty pin created is first in the list' do
    first_pin = Pin.new title: 'First pin', user: User.new
    first_pin.save!
    second_pin = Pin.new title: 'Second pin', user: User.new
    second_pin.save!
    assert_equal(first_pin, Pin.all.first)
  end

  test 'the first complete Pin created is first in the list' do
    first_pin = Pin.new title: 'United Kingdom',
                        image_url: 'http://fpoimg.com/255x170',
                        tag: 'brexit',
                        user: User.new
    first_pin.save!
    second_pin = Pin.new title: 'Japan',
                         image_url: 'http://fpoimg.com/255x170',
                         tag: 'skiing',
                         user: User.new
    second_pin.save!
    assert_equal(first_pin, Pin.all.first)
  end

  test 'updated_at is changed after updating title' do
    pin = Pin.new title: 'Visit Marrakech',
                  user: User.new
    pin.save!
    first_updated_at = pin.updated_at
    pin.title = 'Marrakech'
    pin.save!
    refute_equal(pin.updated_at, first_updated_at)
  end

  test 'updated_at is changed after updating tags' do
    pin = Pin.new title: 'Pin', 
                  tag: 'old tag', 
                  user: User.new
    pin.save!
    first_updated_at = pin.updated_at
    pin.tag = 'new tag'
    pin.save!
    refute_equal(pin.updated_at, first_updated_at)
  end

  test 'updated_at is changed after updating image_url' do
    pin = Pin.new title: 'Pin', 
                  image_url: 'http://fpoimg.com/255x170', 
                  user: User.new
    pin.save!
    first_updated_at = pin.updated_at
    pin.image_url = 'https://images.unsplash.com/photo-1604725333736-1f962a6218d0?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmVhdXRpZnVsJTIwc3Vuc2V0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80'
    pin.save!
    refute_equal(pin.updated_at, first_updated_at)
  end

  test 'One matching result' do
    pin = Pin.new title: 'United States of America', 
                  user: User.new
    pin.save!
    assert_equal Pin.search('America').length, 1
  end

  test 'No matching result' do
    pin = Pin.new title: 'USA', 
                    user: User.new
    pin.save!
    assert_equal 0, Pin.search('America').length
  end

  test 'Two matching result' do
    pin_1 = Pin.new title: 'Blue Ocean', 
                    user: User.new
    pin_1.save!
    pin_2 = Pin.new title: 'Turquoise Ocean', 
                    user: User.new
    pin_2.save!
    assert_equal Pin.search('Ocean').length, 2
  end

  test 'most_recent with no pins' do
    assert_empty Pin.most_recent
  end

  test 'most_recent with 2 pins' do
    pin_1 = Pin.new title: 'Fun pin 1', 
                    user: User.new
    pin_1.save!
    pin_2 = Pin.new title: 'Fun pin 2', 
                    user: User.new
    pin_2.save!

    assert_equal 2, Pin.most_recent.length
    assert_equal Pin.most_recent.first, pin_2
  end

  test 'most_recent with 10 pins' do
    10.times do |i|
      pin = Pin.new title: "Fun pin #{i+1}", 
                      user: User.new
      pin.save!
    end

    assert_equal Pin.most_recent.length, 6
    assert_equal Pin.most_recent.first.title, "Fun pin 10"
  end

  test 'search with tag' do
    pin = Pin.new title: "Portugal", 
                  user: User.new,
                  tag: "lisbon ronaldo"
    pin.save!

    assert_equal 1, Pin.search('ronaldo').length
  end

  test 'search with title and tag' do
    pin_1 = Pin.new title: "Switzerland", 
                    user: User.new,
                    tag: "mountains"
    pin_1.save!

    pin_2 = Pin.new title: "mountains in Italy", 
                      user: User.new,
                      tag: "Tuscany"
    pin_2.save!

    assert_equal 2, Pin.search('mountains').length
  end

  test 'maximum length of tag' do
    pin = Pin.new title: "long tag pin",
                  tag: 'ocean ocean ocean ocean ocean ocean ocean ocean ocean ocean ocean', 
                  user: User.new
    refute pin.valid?
  end

  test 'presence of title' do
    pin = Pin.new
    refute pin.valid?
  end
end
