# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PerguntaController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/pergunta').to route_to('pergunta#index')
    end

    it 'routes to #new' do
      expect(get: '/pergunta/new').to route_to('pergunta#new')
    end

    it 'routes to #show' do
      expect(get: '/pergunta/1').to route_to('pergunta#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/pergunta/1/edit').to route_to('pergunta#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/pergunta').to route_to('pergunta#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/pergunta/1').to route_to('pergunta#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/pergunta/1').to route_to('pergunta#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/pergunta/1').to route_to('pergunta#destroy', id: '1')
    end
  end
end
