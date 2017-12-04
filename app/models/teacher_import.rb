class TeacherImport
  include ActiveModel::Model
  attr_accessor :file
  attr_reader :school_id
  IMPORT_PASSWORD = 'appsite'

  def initialize(attributes = {}, school_id)
    
    @@school_id = school_id
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_teachers[0] != false
      if imported_teachers.map(&:valid?).all?
        imported_teachers.each(&:save!)
        true
      else
        imported_teachers.each_with_index do |teacher, index|
          teacher.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+2}: #{message}"
          end
        end
        false
      end
    else
      false
    end
  end

  def imported_teachers
    if File.extname(file.path).delete('.') == "csv"
      @imported_teachers ||= load_imported_teachers
    else
      return false, "Please upload correct CSV file."
    end
  end

  def load_imported_teachers
    spreadsheet = Roo::Spreadsheet.open(file.path)
    teacher_headers = ["first_name", "middle_name", "last_name", "email", "cell_number"]
    header = spreadsheet.row(1)
    if teacher_headers - header == [] && header - teacher_headers == []
      (2..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        password = generated_password = IMPORT_PASSWORD
        row["password"] = password
        row["school_id"] = @@school_id

        
        teacher = Teacher.find_by(email: row["email"].downcase) || Teacher.new(row)
        teacher.attributes = row.to_hash
        teacher
      end
    else
      return false, "Please check headers of CSV file."
    end
  end

end
