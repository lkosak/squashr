namespace :squashr do
  namespace :db do
    desc "Rebuild database from model definitions (DESTROYS ALL EXISTING DATA!)"
    task :setup => :environment do
      if Squashr.env == 'production'
        raise "Running db:setup on production will destroy all your data. " \
              "Let's not do that."
      end

      DataMapper.auto_migrate!(:default)
    end

    desc "Attempt to automatically migrate tables based on model definitions"
    task :migrate => :environment do
      DataMapper.auto_upgrade!(:default)
    end
  end

  desc "Attempt to book matches"
  task :book => :environment do
    Scheduler.book_all
  end
end
