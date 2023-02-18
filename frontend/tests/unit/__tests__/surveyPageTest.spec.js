import { mount } from "@vue/test-utils";
import axios from "axios";
import StudentClass from "../../../src/pages/StudentClass";

jest.mock("axios"); // cria um mock da biblioteca axios

describe("StudentClass", () => {
  let wrapper;

  const mockData = { // define um objeto com dados mock para ser retornado pelo Axios
    data: [
      {
        id: 1,
        survey_question_id: 1,
        answer: 4,
      },
      {
        id: 2,
        survey_question_id: 2,
        answer: 3,
      },
      {
        id: 3,
        survey_question_id: 1,
        answer: 2,
      },
      {
        id: 4,
        survey_question_id: 2,
        answer: "Bom",
      },
    ],
  };

  beforeEach(() => { // antes de cada teste, configura o mock do Axios para retornar o objeto mockData
    axios.get.mockResolvedValue(mockData);
  });

  beforeEach(() => { // antes de cada teste, cria uma instância da classe "StudentClass" com um objeto mock do Vue.js
    wrapper = mount(StudentClass, {
      mocks: {
        $route: {
          params: {
            id: 1,
          },
        },
      },
    });
  });

  // testa se a as duas tabelas são geradas corretamente na página
  it("should render two tables", () => {
    expect(wrapper.findAll("table").length).toBe(2);
  });

  // testa se os valores gerados na tabela são numéricos
  it("should check if a value is numeric", () => {
    expect(wrapper.vm.isNumeric(4)).toBe(true);
    expect(wrapper.vm.isNumeric("4")).toBe(true);
    expect(wrapper.vm.isNumeric("foo")).toBe(false);
  });

  // verifica se o cálculo da média está sendo feito corretamente
  it("should calculate the average of numeric values in the resposta data", () => {
    const numericData = {
      1: [4, 2],
      2: [3],
    };
    wrapper.setData({ resposta: numericData });

    const filteredAverage = wrapper.vm.filteredResult();
    expect(filteredAverage["1"][0]).toEqual("3.00");
    expect(filteredAverage["2"][0]).toEqual("3.00");
  });
});
