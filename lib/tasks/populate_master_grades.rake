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
  }, {
      name: 'BE 1',
      name_map: 'be-1'
  }, {
      name: 'BE 2',
      name_map: 'be-2'
  }, {
      name: 'BE 3',
      name_map: 'be-3'
  }, {
      name: 'BE 4',
      name_map: 'be-4'
  }, {
      name: 'BE 5',
      name_map: 'be-5'
  }, {
      name: 'ME 1',
      name_map: 'me-1'
  }, {
      name: 'ME 2',
      name_map: 'me-2'
  }, {
      name: 'B.Pharma 1',
      name_map: 'b-pharma-1'
  }, {
      name: 'B.Pharma-2',
      name_map: 'b-pharma-2'
  }, {
      name: 'B.Pharma-3',
      name_map: 'b-pharma-3'
  }, {
      name: 'M.Pharma 1',
      name_map: 'm-pharma-1'
  }, {
      name: 'M.Pharma 2',
      name_map: 'm-pharma-2'
  }, {
      name: 'BBA 1',
      name_map: 'bba-1'
  }, {
      name: 'BBA 2',
      name_map: 'bba-2'
  }, {
      name: 'BBA 3',
      name_map: 'bba-3'
  }, {
      name: 'MBA 1',
      name_map: 'mba-1'
  }, {
      name: 'MBA 2',
      name_map: 'mba-2'
  }, {
      name: 'MBA 3',
      name_map: 'mba-3'
  }, {
      name: 'BCA 1',
      name_map: 'bca-1'
  }, {
      name: 'BCA 2',
      name_map: 'bca-2'
  }, {
      name: 'BCA 3',
      name_map: 'bca-3'
  }, {
      name: 'MCA 1',
      name_map: 'mca-1'
  }, {
      name: 'MCA 2',
      name_map: 'mca-2'
  }, {
      name: 'MCA 3',
      name_map: 'mca-3'
  }, {
      name: 'Bachelors 1',
      name_map: 'bachelors-1'
  }, {
      name: 'Bachelors 2',
      name_map: 'bachelors-2'
  }, {
      name: 'Bachelors 3',
      name_map: 'bachelors-3'
  }, {
      name: 'Masters 1',
      name_map: 'masters-1'
  }, {
      name: 'Masters 2',
      name_map: 'masters-2'
  }, {
      name: 'Masters 3',
      name_map: 'masters-3'
  }, {
      name: 'MBBS 1',
      name_map: 'mbbs-1'
  }, {
      name: 'MBBS 2',
      name_map: 'mbbs-2'
  }, {
      name: 'MBBS 3',
      name_map: 'mbbs-3'
  }, {
      name: 'MBBS 4',
      name_map: 'mbbs-4'
  }, {
      name: 'MBBS 5',
      name_map: 'mbbs-5'
  }, {
      name: 'MD 1',
      name_map: 'md-1'
  }, {
      name: 'MD 2',
      name_map: 'md-2'
  }, {
      name: 'MD 3',
      name_map: 'md-3'
  }, {
      name: 'Alumni',
      name_map: 'alumni'
  }, {
      name: 'Followers',
      name_map: 'followers'
  }, {
      name: 'Internal Communication',
      name_map: 'internal-communication'
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
