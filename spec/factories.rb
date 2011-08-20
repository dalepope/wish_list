# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Dale Pope"
  user.email                 "dpope@example.com"
  user.password              "foofoobarbar"
  user.password_confirmation "foofoobarbar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :wish_category do |category|
  category.name "Foo bar"
end
