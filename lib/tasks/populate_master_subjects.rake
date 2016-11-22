# Rake task to populate master subjects
desc 'rake populate_master_subjects RAILS_ENV=<environment_name> --trace '
task populate_master_subjects: :environment do
  master_subjects_data = [{
    name: 'Algebra',
    name_map: 'algebra'
  }, {
    name: 'Arts',
    name_map: 'arts'
  }, {
    name: 'Biology',
    name_map: 'biology'
  }, {
    name: 'Chemistry',
    name_map: 'chemistry'
  }, {
    name: 'Civics',
    name_map: 'civics'
  }, {
    name: 'Drawing',
    name_map: 'drawing'
  }, {
    name: 'English',
    name_map: 'english'
  }, {
    name: 'General Knowledge',
    name_map: 'general_knowledge'
  }, {
    name: 'Geography',
    name_map: 'geography'
  }, {
    name: 'Geometry',
    name_map: 'geometry'
  }, {
    name: 'Hindi',
    name_map: 'hindi'
  }, {
    name: 'History',
    name_map: 'history'
  }, {
    name: 'Marathi',
    name_map: 'marathi'
  }, {
    name: 'Mathematics',
    name_map: 'mathematics'
  }, {
    name: 'Physics',
    name_map: 'physics'
  }, {
    name: 'Science',
    name_map: 'science'
  }, {
    name: 'Social Science',
    name_map: 'social_science'
  }, {
    name: 'Computer Science',
    name_map: 'computer_science'
  }, {
    name: 'Life Skills',
    name_map: 'life_skills'
  }]

  ActiveRecord::Base.transaction do
    begin
      master_subjects_data.each do |master_subject_datum|
        puts "\n\n================================STARTING MASTER SUBJECT #{master_subject_datum[:name]} ====================================\n"
        master_subject = MasterSubject.where(name_map: master_subject_datum[:name_map]).first_or_create
        master_subject.name = master_subject_datum[:name]
        master_subject.save!
        puts "\n================================PROCESSING MASTER SUBJECT #{master_subject.name} ==================================\n"
        puts "\n================================ENDING MASTER SUBJECT #{master_subject.name} ======================================\n"
      end
    rescue => ex
      Airbrake.notify(ex)
      Rails.logger.debug("Exception on MASTER SUBJECT creation / updation \n\n Message: #{ex.message}\n\n Backtrace: #{ex.backtrace}")
    end
  end
end
