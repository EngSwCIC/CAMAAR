# frozen_string_literal: true

class Semester < ApplicationRecord
  validates :half, uniqueness: { scope: :year }
  has_many :forms
  has_many :templates

  def to_s
    "#{half ? '2' : '1'}-#{year}"
  end

  def self.next_semester_id
    latest_semester = order(id: :desc).first

    if latest_semester.nil?
      half = 0
      year = 2020
    elsif latest_semester.half
      half = 0
      year = latest_semester.year + 1
    else
      half = 1
      year = latest_semester.year
    end
    new_semester = create(half:, year:)
    new_semester.id
  end

  def self.current_semester
    latest_semester = order(id: :desc).first
    if latest_semester
      half = if latest_semester.half
               2
             else
               1
             end
      "#{latest_semester.year}.#{half}."
    else
      'Sem semestre cadastrado.'
    end
  end

  def self.current_semester_id
    latest_semester = order(id: :desc).first
    return latest_semester.id if latest_semester

    latest_semester
  end
end
