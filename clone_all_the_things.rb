Dir.chdir './repos'
`heroku apps`.each_line do |line|
  next if line.strip.empty?
  next if line =~ /\A===/
  app_name = line[/^[^\s]+/]
  `git clone git@heroku.work:#{app_name}.git`
end

