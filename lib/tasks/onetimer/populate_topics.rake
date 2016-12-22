# Rake task to populate master grades
desc 'rake populate_topics RAILS_ENV=<environment_name> --trace '
task populate_topics: :environment do
  create_topic_data = {
    "playgroup" => {
      'algebra' => ['quadratirac_eauation', 'linear_algebra'],
      'science' => ['plants', 'animals']
      },
    "nursery" => {
      'physics' => ['acceleration', 'center ofmass'],
      'science' => ['force', 'momentum']
    },
    "jr-kg" => {
      'physics' => ['Voltage', 'Transistor'],
      'science' => ['Resistor', 'Plasma']
    },
    "sr-kg" => {
      'physics' => ['Ohms law', 'Magnetic field'],
      'science' => ['Lenzs law', 'Joule heating']
    },
    "1st-grade" => {
      'physics' => ['Ion', 'Faradays law of induction'],
      'science' => ['Electron', 'Electric potential']
    },
    "2nd-grade" => {
      'physics' => ['Electric field', 'Electric current'],
      'science' => ['Electric charge', 'Direct current']
    },
    "3rd-grade" => {
      'physics' => ['Coulombs law', 'Capacitor'],
      'science' => ['Velocity', 'Speed']
    },
    "4th-grade" => {
      'physics' => ['Newtons laws of motion', 'equilibrium'],
      'science' => ['parallel universe', 'solar system']
    },
    "5th-grade" => {
      'physics' => ['quadratirac_eauation:advanced', 'linear_algebra:advanced'],
      'science' => ['acceleration:advanced', 'center ofmass:advanced']
    },
    "6th-grade" => {
      'physics' => ['force:advanced', 'momentum:advanced'],
      'science' => ['Voltage:advanced', 'Transistor:advanced']
    },
    "7th-grade" => {
      'physics' => ['Resistor:advanced', 'Plasma:advanced'],
      'science' => ['Ohms law:advanced', 'Magnetic field:advanced']
    },
    "8th-grade" => {
      'physics' => ['Lenzs law:advanced', 'joule heating:advanced'],
      'science' => ['warm hole', 'black hole']
    },
    "9th-grade" => {
      'physics' => ['Ion', 'Faradays law of induction'],
      'science' => ['Electron', 'Electric potential']
    },
    "10th-grade" => {
      'physics' => ['Electric field', 'Electric current'],
      'science' => ['Electric charge', 'Direct current']
    },  
    "11th-grade" => {
      'physics' => ['Coulombs law', 'Speed'],
      'science' => ['Velocity', 'Capacitor']
    },
    "12th-grade" => {
      'physics' => ['Newtons laws of motion:advanced', 'black hole:advanced'],
      'science' => ['parallel universe:advanced', 'warm hole:advanced']
    }
  }

  master_grades_by_name_map = MasterGrade.all.index_by(&:name_map)
  master_subjects_by_name_map = MasterSubject.all.index_by(&:name_map)

  create_topic_params = []
  create_topic_data.each do |grade_name_map, subjects_data|
    subjects_data.each do |subject_name_map, topics|
      topics.each do |topic|
        create_topic_params << {
          title: topic,
          master_grade_id: master_grades_by_name_map[grade_name_map].id,
          master_subject_id: master_subjects_by_name_map[subject_name_map].id,
          teacher_id: 0
        }
      end 
    end 
  end 
  Topic.create(create_topic_params)
end