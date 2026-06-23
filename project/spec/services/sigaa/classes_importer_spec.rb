require "rails_helper"

RSpec.describe Sigaa::ClassesImporter do
  let!(:admin) { create(:user, :admin) }
  let(:path) { Rails.root.join("tmp", "spec_classes.json") }
  let(:semester) { "2021.2" }

  after do
    File.delete(path) if File.exist?(path)
  end

  it "cadastra turmas novas do periodo informado" do
    write_classes_file([
      {
        "code" => "CIC0097",
        "name" => "BANCOS DE DADOS",
        "class" => { "classCode" => "TA", "semester" => "2021.2", "time" => "35T45" }
      }
    ])

    result = described_class.new(path:, semester:, imported_by: admin).call

    course_class = CourseClass.find_by!(code: "CIC0097", class_code: "TA", semester: "2021.2")
    expect(result.created_count).to eq(1)
    expect(result.updated_count).to eq(0)
    expect(course_class.name).to eq("BANCOS DE DADOS")
    expect(course_class.time).to eq("35T45")
  end

  it "atualiza turmas existentes quando os dados mudam no SIGAA" do
    department = create(:department, code: "CIC")
    CourseClass.create!(
      code: "CIC0097",
      class_code: "TA",
      semester: "2021.2",
      name: "Nome antigo",
      time: "10:00",
      department:
    )

    write_classes_file([
      {
        "code" => "CIC0097",
        "name" => "BANCOS DE DADOS",
        "class" => { "classCode" => "TA", "semester" => "2021.2", "time" => "35T45" }
      }
    ])

    result = described_class.new(path:, semester:, imported_by: admin).call

    expect(result.created_count).to eq(0)
    expect(result.updated_count).to eq(1)
    expect(CourseClass.find_by!(code: "CIC0097").name).to eq("BANCOS DE DADOS")
  end

  it "ignora turmas de outros periodos" do
    write_classes_file([
      {
        "code" => "CIC0097",
        "name" => "BANCOS DE DADOS",
        "class" => { "classCode" => "TA", "semester" => "2026.1", "time" => "35T45" }
      }
    ])

    result = described_class.new(path:, semester:, imported_by: admin).call

    expect(result.created_count).to eq(0)
    expect(result.updated_count).to eq(0)
  end

  def write_classes_file(payload)
    File.write(path, JSON.pretty_generate(payload))
  end
end
