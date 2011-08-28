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

Factory.define :wish_item do |wish|
  wish.description "Foo bar"
  wish.url "http://www.amazon.com/banana"
  wish.association :category, :factory => :wish_category
  wish.association :user
end
