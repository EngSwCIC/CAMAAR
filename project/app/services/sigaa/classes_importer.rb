module Sigaa
  class ClassesImporter
    Result = Data.define(:created_count, :updated_count)

    DEFAULT_PATH = Rails.root.join("..", "classes.json")

    def initialize(path: DEFAULT_PATH, semester:, imported_by: nil)
      @path = path
      @semester = semester
      @imported_by = imported_by
    end

    def call
      created_count = 0
      updated_count = 0

      entries_for_semester.each do |entry|
        attrs = extract_class_attrs(entry)
        course_class = CourseClass.find_by(
          code: attrs[:code],
          class_code: attrs[:class_code],
          semester: attrs[:semester]
        )

        if course_class.nil?
          CourseClass.create!(attrs.merge(department: department_for(attrs[:code])))
          created_count += 1
        elsif course_class_attributes_changed?(course_class, attrs)
          course_class.update!(attrs.slice(:name, :time))
          updated_count += 1
        end
      end

      Result.new(created_count:, updated_count:)
    end

    private

    attr_reader :path, :semester, :imported_by

    def entries_for_semester
      JSON.parse(File.read(path)).select do |entry|
        entry.dig("class", "semester") == semester
      end
    end

    def extract_class_attrs(entry)
      class_info = entry.fetch("class")
      {
        code: entry.fetch("code"),
        name: entry.fetch("name"),
        class_code: class_info.fetch("classCode"),
        semester: class_info.fetch("semester"),
        time: class_info["time"]
      }
    end

    def department_for(code)
      department_code = imported_by&.department&.code || code.to_s[/\A[A-Za-z]+/]&.upcase || "GERAL"
      Department.find_or_create_by!(code: department_code) { |department| department.name = department_code }
    end

    def course_class_attributes_changed?(course_class, attrs)
      course_class.name != attrs[:name] || course_class.time != attrs[:time]
    end
  end
end
