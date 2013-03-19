Gem::Specification.new do |s|
  s.name        = 'mongo_stat'
  s.version     = '0.0.2'
  s.date        = '2013-03-19'
  s.summary     = "MongoStat"
  s.description = "A simple front-end for high performance aggregate counter stores in mongodb"
  s.authors     = ["Adam Fields"]
  s.email       = 'adam@morningside-analytics.com'
  s.files       = ["lib/mongo_stat.rb"]
  s.homepage    =
    'http://rubygems.org/gems/mongo_stat'
  s.add_dependency('mongo')
  s.add_dependency('active_support')
  s.requirements << 'Mongo Gem'
  s.requirements << 'Active Support'  
end
