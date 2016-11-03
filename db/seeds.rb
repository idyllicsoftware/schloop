# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

product_admin = ProductAdmin.first_or_create!(
  first_name: 'Schloop',
  last_name:  'Admin',
  email: 'admin@schloop.co',
  password: 'Test1234',
  work_number: '1235987123',
  cell_number: '1235987123'
)