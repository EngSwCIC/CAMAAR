# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormulariosController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/formularios').to route_to('formularios#index')
    end

    it 'routes to #new' do
      expect(get: '/formularios/new').to route_to('formularios#new')
    end

    it 'routes to #show' do
      expect(get: '/formularios/1').to route_to('formularios#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/formularios/1/edit').to route_to('formularios#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/formularios').to route_to('formularios#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/formularios/1').to route_to('formularios#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/formularios/1').to route_to('formularios#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/formularios/1').to route_to('formularios#destroy', id: '1')
    end
  end
end
