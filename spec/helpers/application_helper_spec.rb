# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'helper methods' do
    it 'responds to helper methods' do
      # Testa se o helper está carregado corretamente
      expect(helper).to respond_to(:link_to)
      expect(helper).to respond_to(:content_for)
      expect(helper).to respond_to(:render)
    end
  end

  describe 'basic helper functionality' do
    it 'can use built-in Rails helpers' do
      expect(helper.pluralize(1, 'item')).to eq('1 item')
      expect(helper.pluralize(2, 'item')).to eq('2 items')
    end

    it 'can format numbers' do
      expect(helper.number_with_delimiter(1_234_567)).to eq('1,234,567')
    end

    it 'can truncate text' do
      long_text = 'This is a very long text that needs to be truncated'
      expect(helper.truncate(long_text, length: 20)).to include('...')
    end
  end

  # Adicione testes específicos para métodos do ApplicationHelper aqui
  # Por exemplo, se você tiver um método para formatar datas:
  # describe '#format_date' do
  #   it 'formats date correctly' do
  #     date = Date.new(2024, 1, 15)
  #     expect(helper.format_date(date)).to eq('15/01/2024')
  #   end
  # end
end
