task :default => :spec
task :test    => :spec
  
desc "Run specs"
task :spec do
  exec "spec spec/"
end

desc "Build a gem"
task :gem => [ :gemspec, :build ]
 
desc "Run specs"
task :spec do
  exec "spec spec/"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "group_by_hash"
    gemspec.summary = "ruby hash with a sql-esque group by method"
    gemspec.description = <<END
A ruby hash with a sql-esque group by method for when you can't do a group by in SQL because it is too complicated
END
    gemspec.email = "paulboone@mindbucket.com"
    gemspec.homepage = "http://github.com/paulboone/group_by_hash"
    gemspec.authors = ["Paul Boone"]
  end
rescue LoadError
  warn "Jeweler not available. Install it with:"
  warn "gem install jeweler"
end