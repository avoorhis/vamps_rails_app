namespace :mysql_db do
  db_config = Rails.application.config.database_configuration[Rails.env]

  desc "Dump the whole db into a gziped file"
  task :dump do
    system "mysqldump -u#{db_config['username']} -p#{db_config['password']} --database #{db_config['database']} | gzip > db/vamps2_backup.sql.gz"
  end
  
  desc "Restore the whole db from a gziped file"
  task :restore do
    system "gunzip < db/vamps2_backup.sql.gz | mysql -u#{db_config['username']} -p#{db_config['password']} #{db_config['database']}"
  end  
end