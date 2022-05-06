class Avaliation < ApplicationRecord
    has_many :options
    belongs_to :cclass
    has_many :answers, :through => :options

    def as_json(**options)
        unless options.has_key? :include
          options.merge!(include: [:options, :answers])
        end
        super(options)
    end
end
