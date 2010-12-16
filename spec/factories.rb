Factory.sequence :email do |n|
  "user#{n}@example.com"
end
Factory.sequence :comment do |n|
  "can i haz plz feature #{n} so that i don't need to think anymore in order to become dumb"
end

Factory.define :user do |o|
  o.email { Factory.next(:email) }
  o.password '123456'  
end

Factory.define :project do |o|
  o.sequence(:name) {|n| "amazing project #{n}" }
end

Factory.define :field_definition do |o|
  o.sequence(:name) {|n| "field_#{n}" }
  o.sequence(:value) {|n| "window.location.href + #{n}" }
end

Factory.define :suggestion do |o|
  o.content { Factory.next(:comment) } 
  o.association :project
end
