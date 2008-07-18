require File.dirname(__FILE__)+'/test_helper'

Expectations do
  expect :user => User, :account => Account do
    SignupPresenter.presented
  end
  
  expect User.create!(hash_for_user) do |u|
    SignupPresenter.new(:user => u.expected).user
  end
  
  expect User do
    SignupPresenter.new.user
  end
  
  expect User.any_instance.to.receive(:login=).with('james') do
    SignupPresenter.new(:user_login => 'james')
  end
  
  expect 'mymockvalue' do
    User.any_instance.stubs(:login).returns('mymockvalue')
    SignupPresenter.new.user_login
  end
  
  expect User.any_instance.to.receive(:login=).with('mymockvalue') do
    SignupPresenter.new.user_login = 'mymockvalue'
  end
end
