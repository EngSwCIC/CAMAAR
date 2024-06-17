class TurmasController < ApplicationController
  def index
    path = 'db/json/classes.json'
    data = File.read(path)
    @json_classes = JSON.parse(data)
  end
end
