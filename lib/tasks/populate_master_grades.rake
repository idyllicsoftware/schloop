# Rake task to populate master grades
desc 'rake populate_msater_grades RAILS_ENV=<environment_name> --trace '
task populate_msater_grades: :environment do
  master_grades_data = [{
    name: 'Playgroup',
    name_map: 'playgroup'
  }, {
    name: 'Nursery',
    name_map: 'nursery'
  }, {
    name: 'Jr. KG',
    name_map: 'jr-kg'
  }, {
    name: 'Sr. KG',
    name_map: 'sr-kg'
  }, {
    name: '1st Grade',
    name_map: '1st-grade'
  }, {
    name: '2nd Grade',
    name_map: '2nd-grade'
  }, {
    name: '3rd Grade',
    name_map: '3rd-grade'
  }, {
    name: '4th Grade',
    name_map: '4th-grade'
  }, {
    name: '5th Grade',
    name_map: '5th-grade'
  }, {
    name: '6th Grade',
    name_map: '6th-grade'
  }, {
    name: '7th Grade',
    name_map: '7th-grade'
  }, {
    name: '8th Grade',
    name_map: '8th-grade'
  }, {
    name: '9th Grade',
    name_map: '9th-grade'
  }, {
    name: '10th Grade',
    name_map: '10th-grade'
  }, {
    name: '11th Grade',
    name_map: '11th-grade'
  }, {
    name: '12th Grade',
    name_map: '12th-grade'
  }]

  ActiveRecord::Base.transaction do
    begin
      master_grades_data.each do |master_grade_datum|
        puts "\n\n================================STARTING MASTER GRADE #{master_grade_datum[:name]} ====================================\n"
        master_grade = MasterGrade.where(name_map: master_grade_datum[:name_map]).first_or_create
        master_grade.name = master_grade_datum[:name]
        master_grade.save!
        puts "\n================================PROCESSING MASTER GRADE #{master_grade.name} ==================================\n"
        puts "\n================================ENDING MASTER GRADE #{master_grade.name} ======================================\n"
      end
    rescue => ex
      Airbrake.notify(ex)
      Rails.logger.debug("Exception on MASTER GRADE creation / updation \n\n Message: #{ex.message}\n\n Backtrace: #{ex.backtrace}")
    end
  end
end
