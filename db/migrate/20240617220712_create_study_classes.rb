class CreateStudyClasses < ActiveRecord::Migration[7.1]
  def change
    create_table :study_classes do |t|
      t.string 'code'
      t.string 'name'
      t.string 'classCode'
      t.string 'semester'
      t.string 'time'

      # relacao de docente, a de dicente vai ser por meio de uma join_table
      t.references :docente, index: true, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
