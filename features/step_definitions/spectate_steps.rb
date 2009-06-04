Given /^no Spectate is running$/ do
  true
end

Then /^Spectate should be running$/ do
  Spectate::Client.ping.should succeed
end