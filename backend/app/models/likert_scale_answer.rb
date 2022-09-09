class LikertScaleAnswer < ApplicationRecord
    belongs_to :likert_scale_question
    belongs_to :question_answer

    def as_json(options: {})
        super(
          only: [:answer]
        )
    end

    def self.map_likert_options(option)
        case option
            when 'Discordo totalmente'
                1
            when 'Discordo parcialmente'
                2
            when 'Não sei/Não se aplica'
                3
            when 'Concordo parcialmente'
                4
            when 'Concordo totalmente'
                5
            else
                "Error"
        end
    end

end
