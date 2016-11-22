# Rake task to populate categories
desc 'rake populate_activity_categories RAILS_ENV=<environment_name> --trace '
task populate_activity_categories: :environment do
  category_type_activity = Category.category_types[:activity]

  categories_data = [{
    name: 'Art and Craft',
    name_map: 'art-and-craft',
    category_type: category_type_activity
  }, {
    name: 'Indoor Activity',
    name_map: 'indoor-activity',
    category_type: category_type_activity
  }, {
    name: 'Outdoor Activity',
    name_map: 'outdoor-activity',
    category_type: category_type_activity
  }, {
    name: 'Quiz',
    name_map: 'quiz',
    category_type: category_type_activity
  }, {
    name: 'Worksheet',
    name_map: 'worksheet',
    category_type: category_type_activity
  }, {
    name: 'Video',
    name_map: 'video',
    category_type: category_type_activity
  }, {
    name: 'Educational Link',
    name_map: 'educational-link',
    category_type: category_type_activity
  }, {
    name: 'Research',
    name_map: 'research',
    category_type: category_type_activity
  }, {
    name: 'Collaborative Project',
    name_map: 'collaborative-project',
    category_type: category_type_activity
  }, {
    name: 'Image',
    name_map: 'image',
    category_type: category_type_activity
  }]

  categories_data.each do |category_datum|
    puts "\n\n================================STARTING CATEGORY #{category_datum[:name]} ====================================\n"
    category = Category.where(category_type: category_datum[:category_type], name_map: category_datum[:name_map]).first_or_create
    category.name = category_datum[:name]
    category.save!
    puts "\n================================ENDING CATEGORY #{category.name} ======================================\n"
  end
end
