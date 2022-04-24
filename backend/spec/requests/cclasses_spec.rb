require 'rails_helper'

RSpec.describe "Cclasses", type: :request do
  describe "GET /member_classes" do
    context "when member does not exist" do
      before do
        Member.delete_all
        get '/member_classes/1'
      end

      it 'returns a not_found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns custom not found message' do
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Membro não encontrado' })
      end
    end

    context "when member exists" do
      before do
        Member.delete_all
        @subject = Subject.create(code: 'CIC0090', name: 'ENGENHARIA DE SOFTWARE')
        member = Member.create(name: "MARISTELA TERTO DE HOLANDA", registration: "83807519491",
                               username: "83807519491", occupation: "docente", degree: "DOUTORADO",
                               course: "DEPTO CIÊNCIAS DA COMPUTAÇÃO", email: "mholanda@unb.br")
        @class1 = Cclass.create(code: 'TA', semester: '2021.2', time: '35M12', subject_id: @subject.id)
        @class2 = Cclass.create(code: 'TB', semester: '2021.2', time: '24M12', subject_id: @subject.id)
        Enrollment.create(cclass_id: @class1.id, member_id: member.id)
        Enrollment.create(cclass_id: @class2.id, member_id: member.id)
        get "/member_classes/#{member.id}"
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns array with all member classes' do
        expect(JSON.parse(response.body)).to eq([
                                                  {
                                                    'id' => @class1.id,
                                                    'code' => @class1.code,
                                                    'time' => @class1.time,
                                                    'semester' => @class1.semester,
                                                    'subject' => {
                                                      'code' => @subject.code,
                                                      'name' => @subject.name
                                                    }
                                                  },
                                                  {
                                                    'id' => @class2.id,
                                                    'code' => @class2.code,
                                                    'time' => @class2.time,
                                                    'semester' => @class2.semester,
                                                    'subject' => {
                                                      'code' => @subject.code,
                                                      'name' => @subject.name
                                                    }
                                                  },
                                                ])
      end
    end
  end
end
