class TeacherImport
  include ActiveModel::Model
  attr_accessor :file

  def initialize(attributes = {})
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
        binding.pry
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
      
      teacher = Teacher.find_by(id: row["id"]) || Teacher.new
      teacher.attributes = row.to_hash
      teacher
    end    
  end

end
