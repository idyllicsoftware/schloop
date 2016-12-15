class SetValuesInTopics < ActiveRecord::Migration

  def change
  	Topic.create(title: 'Acceleration',	master_grade_id: 1,	master_subject_id: 1,is_created_by_teacher: 0)
  	Topic.create(title: 'Center of mass',	master_grade_id: 2,	master_subject_id: 2,is_created_by_teacher: 1)
  	Topic.create(title: 'Force',	master_grade_id: 3,	master_subject_id: 3,is_created_by_teacher: 0)
  	Topic.create(title: 'Mass',	master_grade_id: 4,	master_subject_id: 4,is_created_by_teacher:1)
  	Topic.create(title: 'Momentum',master_grade_id:5,master_subject_id: 1,is_created_by_teacher:0)
  	Topic.create(title: 'Newtons laws of motion',master_grade_id:6,master_subject_id: 2,is_created_by_teacher:0)
  	Topic.create(title: 'Speed',master_grade_id: 7,master_subject_id: 3,is_created_by_teacher:1)
  	Topic.create(title: 'Velocity',master_grade_id: 1,master_subject_id: 4,is_created_by_teacher:0)
  	Topic.create(title: 'Capacitor',master_grade_id: 2,master_subject_id: 1,is_created_by_teacher:1)
  	Topic.create(title: 'Coulombs law',master_grade_id: 3,master_subject_id: 2,is_created_by_teacher:1)
  	Topic.create(title: 'Direct current',master_grade_id: 4,master_subject_id: 3,is_created_by_teacher:1)
  	Topic.create(title: 'Electric charge',master_grade_id: 5,master_subject_id: 4,is_created_by_teacher:0)
  	Topic.create(title: 'Electric current',master_grade_id: 6,master_subject_id: 1,is_created_by_teacher:1)
  	Topic.create(title: 'Electric field',master_grade_id: 7,master_subject_id: 2,is_created_by_teacher:1)
  	Topic.create(title: 'Electric potential',master_grade_id: 1,master_subject_id: 3,is_created_by_teacher:0)
  	Topic.create(title: 'Electron',master_grade_id: 2,master_subject_id: 4,is_created_by_teacher:1)
  	Topic.create(title: 'Faradays law of induction',master_grade_id:3,master_subject_id: 1,is_created_by_teacher:1)
  	Topic.create(title: 'Ion',master_grade_id: 4,master_subject_id: 2,is_created_by_teacher:0)
  	Topic.create(title: 'Joule heating',master_grade_id: 5,master_subject_id: 3,is_created_by_teacher:1)
  	Topic.create(title: 'Lenzs law',master_grade_id: 6,master_subject_id: 4,is_created_by_teacher:0)
  	Topic.create(title: 'Magnetic field',master_grade_id: 7,master_subject_id: 1,is_created_by_teacher:1)
  	Topic.create(title: 'Ohms law',master_grade_id: 1,master_subject_id: 2,is_created_by_teacher:0)
  	Topic.create(title: 'Plasma (physics)',master_grade_id:2,master_subject_id: 3,is_created_by_teacher:0)
  	Topic.create(title: 'Resistor',master_grade_id:3,master_subject_id: 4,is_created_by_teacher:0)
  	Topic.create(title: 'Transistor',master_grade_id:4,master_subject_id: 1,is_created_by_teacher:0)
  	Topic.create(title: 'Voltage',master_grade_id:5,master_subject_id: 2,is_created_by_teacher:0)
 end

end
