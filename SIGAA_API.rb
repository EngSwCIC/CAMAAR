require "json"

module SIGAA
  class Client
    API_ENDPOINT = 'http://localhost:3000/'.freeze

    def fetch()
      classes = open_file(API_ENDPOINT + "classes.json")
      return classes
    end

    def class(class_code)
      classes = open_file(API_ENDPOINT + "class_members.json")
      return classes.select { |c| c["code"] == class_code }
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
