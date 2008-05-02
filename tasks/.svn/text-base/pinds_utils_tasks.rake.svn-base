desc "Migrate development, push to test database, and annotate models"
task :migrate => ["db:migrate", "db:test:prepare"] do
  puts "Ignore deprecation warning"
  puts `rake annotate_models`
end

desc "Migrate down one step"
task :downgrate => :environment do
  ActiveRecord::Migrator.migrate("db/migrate/", ActiveRecord::Migrator.current_version - 1)  
end

desc "Migrate down one step, then back up, fix test, and annotate models"
task :regrate => [:downgrate, :migrate]