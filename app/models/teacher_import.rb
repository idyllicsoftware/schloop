class TeacherImport
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
  end

  def imported_teachers
    @imported_teachers ||= load_imported_teachers
  end

  def load_imported_teachers
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      password = generated_password = Devise.friendly_token.first(8)
      row["password"] = password
      row["school_id"] = @@school_id

      
      teacher = Teacher.find_by(email: row["email"]) || Teacher.new(row)
      teacher.attributes = row.to_hash
      teacher
    end    
  end

end
