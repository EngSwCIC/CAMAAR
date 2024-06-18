require "json"

module SIGAA
  class Client
    API_ENDPOINT = 'http://localhost:3000/'.freeze

    ConnectionTimeoutError = Class.new(StandardError)
    NotFound = Class.new(StandardError)

    def fetch_classes()
      classes = open_file(API_ENDPOINT + "classes.json")
      return classes
    end

    def find_class(class_code)
      classes = open_file(API_ENDPOINT + "class_members.json")
      return classes.select { |c| c["code"] == class_code } if classes.length() != 0

      raise NotFound, "Não existe uma turma com o código #{class_clode}."
    end

    private

    def open_file(file_path)
      file = File.open(file_path)
      data = JSON.load(file)
      file.close
      return data
    end
  end
end
