task :check do
  #Rake::Task['test'].invoke # could also be spec if you're using rspec
  Rake::Task['rails_best_practices'].invoke
  Rake::Task['brakeman'].invoke  
end

task :rails_best_practices do
  path = File.expand_path("../../../", __FILE__)
  sh "bundle exec rails_best_practices"
end

task :brakeman do
  sh "bundle exec brakeman -q -z -o text"
end