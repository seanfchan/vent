Factory.define :user do |user|
  user.name                   'SeanChan'
  user.email                  'sean@example.com'
  user.password               'foobar'
  user.password_confirmation  'foobar'
end

Factory.sequence :name do |n|
  "person_#{n}"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :ventpost do |ventpost|
  ventpost.content 'foobar'
  ventpost.association :user
end