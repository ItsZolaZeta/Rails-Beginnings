require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'cascading save' do
    pin = Pin.new title: 'Awesome pin!', user: User.new
    pin.save!

    comment = Comment.new body: 'Great comment!', user: User.new
    pin.comments << comment
    pin.save!

    assert_equal comment, Comment.first
  end
  
  test 'Comments are ordered correctly' do
    pin = Pin.new title: 'Travel', user: User.new
    pin.save!

    comment_1 = Comment.new body: 'This would be fun!', user: User.new
    comment_2 = Comment.new body: 'I agree! Id like to do this as well.', user: User.new

    pin.comments << comment_1
    pin.comments << comment_2
    pin.save!

    assert_equal pin.comments.first, comment_1
    assert_equal 2, pin.comments.length
  end
end
