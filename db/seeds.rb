# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create! name: "Sam", email: "sam@sam.com", password: "password"
u.quits.create! text: "I quit soda!"
u.quits.create! text: "I quit running, I'm biking instead!"

u = User.create! name: "Wonjun", email: "won@won.com", password: "password"
