When /^I execute "([^\"]*)"$/ do |command|
  @output = `#{command}`
end

Then /^I should see "([^\"]*)"$/ do |text|
  @output.should =~ /#{text}/m
end
