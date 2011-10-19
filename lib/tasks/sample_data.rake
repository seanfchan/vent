namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => 'Eample User',
                         :email => 'example@gmail.com',
                         :password => 'foobar',
                         :password_confirmation => 'foobar')
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@gmail.jp"
      password = 'password'
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end

    User.all(:limit => 6).each do |user|
      50.times do
        user.ventposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end


end