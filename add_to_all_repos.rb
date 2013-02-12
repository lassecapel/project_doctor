`heroku apps`.each_line do |line|
  next if line.strip.empty?
  next if line =~ /\A===/
  app_name = line[/^[^\s]+/]
  `heroku sharing:add egbert@brightin.nl --app #{app_name}`
end
