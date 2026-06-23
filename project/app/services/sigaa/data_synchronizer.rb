module Sigaa
  class DataSynchronizer
    Result = Data.define(:created_count, :updated_count, :inconsistencies, :already_up_to_date?)

    def initialize(semester:, imported_by:, classes_path: ClassesImporter::DEFAULT_PATH, members_path: ClassMembersImporter::DEFAULT_PATH)
      @semester = semester
      @imported_by = imported_by
      @classes_path = classes_path
      @members_path = members_path
    end

    def call
      classes_result = ClassesImporter.new(path: classes_path, semester:, imported_by:).call
      members_result = ClassMembersImporter.new(path: members_path, semester:, imported_by:).call

      created_count = classes_result.created_count + members_result.created_count
      updated_count = classes_result.updated_count + members_result.updated_count

      Result.new(
        created_count:,
        updated_count:,
        inconsistencies: members_result.inconsistencies,
        already_up_to_date?: created_count.zero? && updated_count.zero?
      )
    end

    def self.available_semesters(classes_path: ClassesImporter::DEFAULT_PATH, members_path: ClassMembersImporter::DEFAULT_PATH)
      from_classes = JSON.parse(File.read(classes_path)).filter_map { |entry| entry.dig("class", "semester") }
      from_members = JSON.parse(File.read(members_path)).filter_map { |entry| entry["semester"] }

      (from_classes + from_members).uniq.sort.reverse
    end

    private

    attr_reader :semester, :imported_by, :classes_path, :members_path
  end
end
