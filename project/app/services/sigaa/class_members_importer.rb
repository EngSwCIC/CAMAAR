module Sigaa
  class ClassMembersImporter
    Result = Data.define(:created_count, :updated_count, :inconsistencies)

    DEFAULT_PATH = Rails.root.join("..", "class_members.json")

    def initialize(path: DEFAULT_PATH, semester: nil, imported_by: nil)
      @path = path
      @semester = semester
      @imported_by = imported_by
    end

    def call
      created_count = 0
      updated_count = 0
      inconsistencies = 0

      parsed_data.each do |class_payload|
        course_class = find_or_create_course_class(class_payload)

        members_for(class_payload).each do |member_payload, membership_role|
          if invalid_member?(member_payload)
            register_inconsistency(member_payload, "Participante sem email ou matricula")
            inconsistencies += 1
            next
          end

          user_status = sync_user(member_payload, course_class.department)
          created_count += 1 if user_status == :created
          updated_count += 1 if user_status == :updated

          membership_status = ensure_membership(user_for(member_payload), course_class, membership_role)
          created_count += 1 if membership_status == :created
        end
      end

      Result.new(created_count:, updated_count:, inconsistencies:)
    end

    private

    attr_reader :path, :semester, :imported_by

    def parsed_data
      data = JSON.parse(File.read(path))
      return data if semester.blank?

      data.select { |entry| entry["semester"] == semester }
    end

    def find_or_create_course_class(class_payload)
      code = class_payload.fetch("code")
      department = department_for(code)

      CourseClass.find_or_create_by!(
        code:,
        class_code: class_payload.fetch("classCode"),
        semester: class_payload.fetch("semester")
      ) do |course_class|
        course_class.department = department
        course_class.name = class_payload["name"]
      end
    end

    def department_for(code)
      department_code = imported_by&.department&.code || code.to_s[/\A[A-Za-z]+/]&.upcase || "GERAL"
      Department.find_or_create_by!(code: department_code) { |department| department.name = department_code }
    end

    def members_for(class_payload)
      class_payload.flat_map do |key, value|
        next [] unless %w[dicente docente].include?(key)

        role = key == "docente" ? :docente : :discente
        members = value.is_a?(Array) ? value : (value.is_a?(Hash) ? [ value ] : [])
        members.map { |member_payload| [ member_payload, role ] }
      end
    end

    def invalid_member?(member_payload)
      member_payload["email"].blank? || member_registration(member_payload).blank?
    end

    def member_registration(member_payload)
      member_payload["matricula"].presence || member_payload["usuario"].presence
    end

    def register_inconsistency(member_payload, message)
      ImportInconsistency.create!(source: "class_members.json", message:, payload: member_payload)
    end

    def sync_user(member_payload, department)
      registration = member_registration(member_payload).to_s.strip
      email = normalized_email(member_payload)
      name = member_payload["nome"]

      user = User.find_by(email:) || User.find_by(registration:)

      if user.nil?
        user = User.create!(
          name:,
          email:,
          registration:,
          role: :participant,
          department:
        )
        send_password_setup(user) if user.pending_password_setup?
        return :created
      end

      updates = {}
      updates[:name] = name if user.name != name
      updates[:email] = email if user.email != email
      updates[:registration] = registration if user.registration != registration
      updates[:department] = department if user.department_id != department.id

      if updates.any?
        user.update!(updates)
        :updated
      else
        :unchanged
      end
    end

    def user_for(member_payload)
      registration = member_registration(member_payload).to_s.strip
      User.find_by(email: normalized_email(member_payload)) || User.find_by!(registration:)
    end

    def normalized_email(member_payload)
      member_payload["email"].to_s.strip.downcase
    end

    def send_password_setup(user)
      UserMailer.password_setup(user, user.generate_password_setup_token!).deliver_now
    end

    def ensure_membership(user, course_class, role)
      membership = ClassMembership.find_or_create_by!(user:, course_class:, role:)
      membership.previously_new_record? ? :created : :unchanged
    end
  end
end
