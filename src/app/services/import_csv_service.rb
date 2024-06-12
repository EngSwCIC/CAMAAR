# app/services/import_csv_service.rb
# import csv library
require 'csv'

# ??? THE EXTERNAL CSV FILE SHOULD CONTAIN USER DATA AND WHAT ELSE MORE? LOOKING AT THE DATABASE SCHEMA, MANY DATA SHOULD COME FROM THE
# RESPONSES 

class ImportCsvService
  # constructor class
  # file_path will be an instance variable that will store the path to be used in the call method
  def initialize(file_path)
    @file_path = file_path
  end

  def call
    # reads the csv file row by row (first row contains the headers)
    CSV.foreach(@file_path, headers: true) do |row|
      # converts each row to a hash where keys are the column headers and values are the rows data
      user_data = row.to_hash
      # save the user data to the database
      save_user(user_data)
    end
  end

  # private method that handles saving the user's data to the database
  private

  def save_user(data)
    # create a new usuario record with the data from the csv row and save it to the database
    Usuario.create!(
      email: data['email'],
      senha: data['senha'],
      curso: data['curso'],
      ocupação: data['ocupação'],
      matrícula: data['matrícula'],
      isAdmin: data['isAdmin'],
      Nome: data['Nome']
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save user: #{e.message}"
  end
end
