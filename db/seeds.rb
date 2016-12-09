# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
product_admin = ProductAdmin.first_or_create!(
  first_name: 'Schloop',
  last_name:  'Admin',
  email: 'admin@schloop.co',
  password: 'Test12345',
  work_number: '+91-1235 987 123',
  cell_number: '+91-1235 987 123'
)

csv_text = File.read(Rails.root.join('lib', 'seeds', 'topics.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
csv.each do |row|
  t = Topic.new
  t.title = row['title']
  t.grade_id = row['grade_id']
  t.subject_id = row['subject_id']
  t.teacher_id = row['teacher_id']
  t.is_master = row['is_master']
  t.save
  puts "#{t.title}, saved"
end