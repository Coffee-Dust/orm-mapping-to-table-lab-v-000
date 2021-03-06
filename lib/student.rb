class Student

	attr_accessor :name, :grade
	attr_reader :id

	def initialize(name, grade)
		@name, @grade = name, grade
	end

	def self.create(hash)
		self.new(nil,nil).tap do |instance|
			hash.each do |key, value|
				instance.send("#{key}=", value)
			end
			instance.save
		end
	end

	def self.create_table
		sql = <<-SQL
			CREATE TABLE IF NOT EXISTS students(
				id INTEGER PRIMARY KEY,
				name TEXT,
				grade INTEGER
			);	
		SQL
		DB[:conn].execute(sql)
	end

	def self.drop_table
		DB[:conn].execute("DROP TABLE students")
	end

	def save
		DB[:conn].execute("INSERT INTO students (name, grade) VALUES(?,?)", self.name, self.grade)
		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten[0]
	end

end
