class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student
    sql = <<-SQL
      SELECT * FROM students
      SQL
    # the sql returns nested arrays with info from database
    student_arrays = DB[:conn].execute(sql)

    student_arrays.map do |row|
      # .map returns a new array with the result of what ever you did to "row"
      self.new_from_db(row)
    end  
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    name_search = <<-SQL
      SELECT * FROM students WHERE students.name = ? 
    SQL
    student_info_array= DB[:conn].execute(name_search,name)
    self.new_from_db(student_info_array[0])
  end
  
  def self.all_students_in_grade_9
    # return and array of students where grade = 9
    self.all.select do |student_instance|
      student_instance.grade == "9"
    end 
  end

  def self.students_below_12th_grade
    # return array of students inst that are <12
    self.all.select do |student|
      student.grade < "12"
    end
  end

  def self.all_students_in_grade_X(grade)
    self.all.select do |student|
        student.grade = "#{grade}"
    end   
    
  end

  def self.first_student_in_grade_10
    sql = <<-SQL 
      SELECT * FROM students
      WHERE students.grade = "10"
    SQL
    DB[:conn].execute(sql).map {|stud| self.new_from_db(stud)}.first
  end

  def self.first_X_students_in_grade_10(amount)
    grade_ten = self.all_students_in_grade_X(10)
    grade_ten.slice(0,amount)   
  end

 

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
