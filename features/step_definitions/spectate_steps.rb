Given /^no Spectate is running$/ do
  true
end

Then /^Spectate should be running$/ do
  Spectate.ping.should be_true
end