class ParentImport
  include ActiveModel::Model
  attr_accessor :file
  attr_reader :school_id

  def initialize(attributes = {}, school_id)
    
    @@school_id = school_id
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_parents.map(&:valid?).all?
      imported_parents.each(&:save!)
      true
    else

      imported_parents.each_with_index do |parent, index|
        parent.errors.full_messages.each do |message|
          binding.pry
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_parents
    @imported_parents ||= load_imported_parents
  end

  def load_imported_parents
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row["school_id"] = @@school_id
      password = generated_password = Devise.friendly_token.first(8)
      parent_data = {"first_name" => row["first_name"], "last_name" => row["last_name"], "email" => row["email"], "cell_number" => row["cell_number"], "password" => password, "school_id" =>  row["school_id"]}      
      student_data = {"first_name" => row["student_first_name"], "last_name" => row["student_last_name"], "school_id" =>  row["school_id"]}
      parent = Parent.find_by(email: row["email"]) || Parent.new(parent_data)
      student = parent.students.build(student_data)
      parent.attributes = parent_data.to_hash
      student.attributes = student_data.to_hash
      binding.pry
       parent, student
    end    
  end

end
