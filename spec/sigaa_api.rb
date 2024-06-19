module SIGAA
  class Client
    ConnectionTimeoutError = Class.new(StandardError)
    NotFound = Class.new(StandardError)

    def self.fetch_classes
      classes = JSON.parse(File.read(Rails.public_path + "classes.json"))
      return classes
    end

    def self.find_class(class_code)
      classes = JSON.parse(File.read(Rails.public_path + "class_members.json"))
      puts classes.length
      if classes.length != 0
        return classes.select { |c| c["code"] == class_code }
      else
        raise NotFound, "Não existe uma turma com o código #{class_clode}."
      end
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
