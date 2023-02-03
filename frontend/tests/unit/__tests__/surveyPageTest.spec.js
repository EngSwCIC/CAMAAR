import { shallowMount } from '@vue/test-utils';
import axios from 'axios';
import Table from './Table.vue';

jest.mock('axios', () => ({
  get: jest.fn().mockResolvedValue({ data: [] })
}));

describe('Table.vue', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(Table, {
      data() {
        return {
          filteredAnswers: [],
          questionAnswers: [],
          resposta: null,
          columns: [],
        };
      },
    });
  });

  it('calls getAnswers when created', () => {
    expect(axios.get).toHaveBeenCalledWith('api/surveys/1/answers');
  });

});
