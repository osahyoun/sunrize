
Given /^"([^"]*)" is not on sunrize$/ do |username|
  delete_keys
  Redis.new.exists("sunrize:#{username}").should be(false)
end

When /^"([^"]*)" request their data$/ do |username|
  visit "/user/#{username}"
end

Then /^"([^"]*)" should get a not found object$/ do |username|
  expected = JSON.pretty_generate(JSON.parse(fixture('not_found.json')))
  actual   = JSON.pretty_generate(JSON.parse(page.source))
  expected.should == actual
end

When /^"([^"]*)" registers$/ do |username|
  stub_request(:get, "http://www.memrise.com/user/#{username}/").
       with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => fixture("#{username}.html"), :headers => {})

  visit "/"
  fill_in "username", :with => username
  click_button "GO!"
end

Then /^"([^"]*)" should get a JSON encoded object of their usage stats$/ do |username|
  require 'json'
  expected = JSON.pretty_generate(JSON.parse(fixture('MonkeyKing.json')))
  actual   = JSON.pretty_generate(JSON.parse(page.source))
  expected.should == actual
end

Given /^user is not on memrise$/ do
  require 'redis'
  Redis.new.del 'sunrize:foobar'
  stub_request(:get, "http://www.memrise.com/user/foobar/").
    with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    to_return(:status => 404, :body => "", :headers => {})

  visit "/"
  fill_in "username", :with => 'foobar'
  click_button "GO!"

end

Then /^user should get a sorry message$/ do
  page.should have_content("Sorry, we couldn't find you on Memrise. Check your username and try again!")
end

Given /^a user has no ranking yet$/ do
  delete_keys

  stub_request(:get, "http://www.memrise.com/user/foobar/").
       with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => fixture("no_ranking.html"), :headers => {})

  Sunrize::Fetcher.fetch('foobar')
end

Then /^JSON should encode this as null$/ do
  data = Sunrize::User.find('foobar')
  data['rank'].should === ''
end