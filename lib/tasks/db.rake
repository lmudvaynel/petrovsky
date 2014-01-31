namespace :db do
  desc "Prepare database to work with Petrovsky project"
  task prepare: :environment do
    tasks = ['db:drop', 'db:create', 'db:migrate', 'db:seed', 'db:test:prepare']
    tasks.each { |task| Rake::Task[task].execute }
  end
end
