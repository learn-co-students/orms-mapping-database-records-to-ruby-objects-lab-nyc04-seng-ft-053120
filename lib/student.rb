class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database

    # create a new instance of student
    new_student = self.new

    # since a row is an array, we can retrieve info for each attribute using indices
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]

    # return the new instance of the student created
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

    # create a query to retrieve the entire table, save in a var
    sql = "SELECT * FROM students"

    # execute the query by accessing database connection and calling .execute on it, passing in the sql var
    # this will give an array of subarray, each subarray represents a row of data, use self.new_from_db(row) then to map through each subarray in the array, turning each into a new instance of student
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class

    # create a query to find the student in the database with a given name, store the query in a var
    sql = "SELECT * FROM students WHERE students.name = ? LIMIT 1"

    # execute query by accessing database connection and calling .execute on it, passing in the sql var
    # this will give an array of a subarray, map through the subarray of the array, use self.new_from_db(row) to map the subarray into a student instance, return the student instance/first element using .first 
    DB[:conn].execute(sql, name).map { |row| self.new_from_db(row) }.first
  end

  def self.all_students_in_grade_9
    # This is a class method that does not need an argument. This method should return an array of all the students in grade 9.

    # create a sql query to return all rows where students.grade is 9
    sql = "SELECT * FROM students WHERE students.grade = 9"

    # run the sql query using the database connection and .execute, map through each subarray/row of the array returned and turn each subarray/row into a student instance using self.new_from_db(row)
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end
  
  def self.students_below_12th_grade
    # This is a class method that does not need an argument. This method should return an array of all the students below 12th grade.
    
    sql = "SELECT * FROM students WHERE students.grade < 12"

    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(num)
    # This is a class method that takes in an argument of the number of students from grade 10 to select. This method should return an array of exactly X number of students.

    sql = "SELECT * FROM students WHERE students.grade = 10 LIMIT ?"

    DB[:conn].execute(sql, num).map { |row| self.new_from_db(row) }
  end

  def self.first_student_in_grade_10
    # This is a class method that does not need an argument. This should return the first student that is in grade 10.
    sql = "SELECT * FROM students WHERE students.grade = 10 LIMIT 1"

    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }.first
  end

  def self.all_students_in_grade_X(grade)
    # This is a class method that takes in an argument of a grade for which to retrieve the roster. This method should return an array of all students for grade X.
    sql = "SELECT * FROM students WHERE students.grade = ?"

    DB[:conn].execute(sql, grade).map { |row| self.new_from_db(row) }
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
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
