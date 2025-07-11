# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CursosController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/cursos').to route_to('cursos#index')
    end

    it 'routes to #new' do
      expect(get: '/cursos/new').to route_to('cursos#new')
    end

    it 'routes to #show' do
      expect(get: '/cursos/1').to route_to('cursos#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/cursos/1/edit').to route_to('cursos#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/cursos').to route_to('cursos#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/cursos/1').to route_to('cursos#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/cursos/1').to route_to('cursos#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/cursos/1').to route_to('cursos#destroy', id: '1')
    end
  end
end
