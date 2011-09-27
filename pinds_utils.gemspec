$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pinds_utils/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pinds_utils"
  s.version     = PindsUtils::VERSION
  s.authors     = ["Lars Pind"]
  s.email       = ["lars@pinds.com"]
  s.homepage    = "http://pinds.com"
  s.summary     = "Various Rails helpers I have collected over the years."
  s.description = "Various Rails helpers I have collected over the years."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.0.0"

  s.add_development_dependency "sqlite3"
end
