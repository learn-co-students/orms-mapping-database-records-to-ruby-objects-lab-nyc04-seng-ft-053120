class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new 
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
  end

  # retrieve all the rows from the "Students" database
  # remember each row should be a new instance of the Student class
  def self.all
    sql = <<-SQL
      SELECT *
       FROM students
    SQL
   
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end 

    # find the student in the database given a name
    # return a new instance of the Student class
  def self.find_by_name(name)
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE name = ?
        LIMIT 1
      SQL
   
      DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
      end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  #This method should return an array of all the students in grade 9.
  def self.all_students_in_grade_9
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = 9 
      SQL
   
      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
  end

  #This method should return an array of all the students below 12th grade.
  def self.students_below_12th_grade
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade < 12
      SQL
   
      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
  end

  #DO NOT UNDERSTND WHAT THIS METHOD WANTS
  #This is a class method that takes in an argument of the number of students from
  #grade 10 to select.
  #This method should return an array of exactly X number of students.
  def self.first_X_students_in_grade_10(number_students_grade_10)

  end

  #NOT PASSING
  #this should return the first student that is in grade 10.
  def self.first_student_in_grade_10 
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = 10
        ORDER BY id
        LIMIT 1
      SQL
   
      DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
      end.first
  end

  #This is a class method that takes in an argument of a grade for which to retrieve the roster. This method should return an array of all students for grade X.
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
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
