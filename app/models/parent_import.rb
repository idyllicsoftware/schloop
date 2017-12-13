class ParentImport
  include ActiveModel::Model
  attr_accessor :file
  attr_reader :school_id
  IMPORT_PASSWORD = "appsite"

  def initialize(attributes = {}, school_id, grade_id)
    @@school_id = school_id
    @@grade_id = grade_id
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_parents[0] != false 
      if imported_parents.map(&:valid?).all?
        imported_parents.each_with_index do |parent, index|
          existing_parent = Parent.find_by_email(parent.email)
          if !existing_parent.present?
            parent.password = IMPORT_PASSWORD 
            parent.save
          else
            parent_data = {"first_name" => parent.first_name, "last_name" => parent.last_name, "email" => parent.email, "cell_number" => parent.cell_number, "school_id" =>  parent.school_id}
            existing_parent.update_attributes(parent_data)
            parent.students.first.parent_id = existing_parent.id
            parent.students.each(&:save!)
          end
        end
        true
      else
        imported_parents.each_with_index do |parent, index|
          error_messages = parent.errors.full_messages - ["Students is invalid", "Student profiles is invalid"]
          error_messages.each do |message|
            errors.add :base, "Row #{index+2}: #{message}"
          end
        end
        false
      end
    else
      false
    end

  end

  def imported_parents
    if File.extname(file.path).delete('.') == "csv"
      @imported_parents ||= load_imported_parents
    else
      return false, "Please upload correct CSV file."
    end
  end

  def load_imported_parents
    spreadsheet = Roo::Spreadsheet.open(file.path)
    student_headers = ["first_name", "last_name", "email", "cell_number", "student_first_name", "student_last_name", "division"]
    header = spreadsheet.row(1)
    if student_headers - header == [] && header - student_headers == []
      (2..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        row["school_id"] = @@school_id
        password =  Devise.friendly_token.first(8)
        row["password"] = password
        division = Division.where(:grade_id => @@grade_id, :name => row["division"])
        return false, "Invalid division in CSV file" if division.blank?
        division_id = division.first.id rescue ""
        parent_data = {"first_name" => row["first_name"], "last_name" => row["last_name"], "email" => row["email"], "cell_number" => row["cell_number"], "school_id" =>  row["school_id"]}
        student_data = {"first_name" => row["student_first_name"], "last_name" => row["student_last_name"], "school_id" =>  row["school_id"]}
        student_profile_data = {"grade_id" => @@grade_id, "division_id"=> division_id, :status => 0}
        parent_detail_data = {"school_id" => @@school_id, "first_name" => row["first_name"], "last_name" => row["last_name"]}
        parent = Parent.find_by(email: row["email"].downcase)
        if parent.blank?
           parent_data.merge!("password" => row["password"])
           parent = Parent.new(parent_data)
        end
        parent_detail = parent.parent_details.last ||  parent.parent_details.build(parent_detail_data)
        student =  parent.students.find_by(first_name: row["student_first_name"], :school_id => row["school_id"]) || parent.students.build(student_data)
        student_profile = student.student_profiles.first || student.student_profiles.build(student_profile_data)
        parent.attributes = parent_data.to_hash
        parent_detail.attributes = parent_detail_data.to_hash
        student.attributes = student_data.to_hash
        student_profile.attributes = student_profile_data.to_hash
        parent
      end    
    else
      return false, "Please check headers of CSV file."
    end
  end

end
