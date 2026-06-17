module Sigaa
  class ClassMembersImporter
    Result = Data.define(:created_users, :updated_memberships, :inconsistencies)

    DEFAULT_PATH = Rails.root.join("..", "class_members.json")

    def initialize(path: DEFAULT_PATH, imported_by: nil)
      @path = path
      @imported_by = imported_by
    end

    def call
      created_users = 0
      updated_memberships = 0
      inconsistencies = 0

      parsed_data.each do |class_payload|
        course_class = find_or_create_course_class(class_payload)

        members_for(class_payload).each do |member_payload, membership_role|
          if invalid_member?(member_payload)
            register_inconsistency(member_payload, "Participante sem email ou matricula")
            inconsistencies += 1
            next
          end

          user, created = find_or_create_user(member_payload, course_class.department)
          created_users += 1 if created
          send_password_setup(user) if created && user.pending_password_setup?
          updated_memberships += 1 if ensure_membership(user, course_class, membership_role)
        end
      end

      Result.new(created_users:, updated_memberships:, inconsistencies:)
    end

    private

    attr_reader :path, :imported_by

    def parsed_data
      JSON.parse(File.read(path))
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
        next [] unless value.is_a?(Array)

        role = key == "docente" ? :docente : :discente
        value.map { |member_payload| [ member_payload, role ] }
      end
    end

    def invalid_member?(member_payload)
      member_payload["email"].blank? || member_payload["matricula"].blank?
    end

    def register_inconsistency(member_payload, message)
      ImportInconsistency.create!(source: "class_members.json", message:, payload: member_payload)
    end

    def find_or_create_user(member_payload, department)
      user = User.find_by(email: normalized_email(member_payload)) ||
        User.find_by(registration: member_payload["matricula"].to_s.strip)

      if user
        user.update!(
          name: member_payload["nome"],
          email: normalized_email(member_payload),
          registration: member_payload["matricula"].to_s.strip,
          department:
        )
        [ user, false ]
      else
        [
          User.create!(
            name: member_payload["nome"],
            email: normalized_email(member_payload),
            registration: member_payload["matricula"].to_s.strip,
            role: :participant,
            department:
          ),
          true
        ]
      end
    end

    def normalized_email(member_payload)
      member_payload["email"].to_s.strip.downcase
    end

    def send_password_setup(user)
      UserMailer.password_setup(user, user.generate_password_setup_token!).deliver_now
    end

    def ensure_membership(user, course_class, role)
      ClassMembership.find_or_create_by!(user:, course_class:, role:).previously_new_record?
    end
  end
end
