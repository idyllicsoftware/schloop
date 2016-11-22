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
    name: '(1-12th Grade)',
    name_map: '1-12th-grade'
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
