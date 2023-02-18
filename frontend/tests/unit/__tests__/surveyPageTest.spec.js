import { mount } from "@vue/test-utils";
import axios from "axios";
import StudentClass from "../../../src/pages/StudentClass";

jest.mock("axios");

describe("StudentClass", () => {
  let wrapper;

  const mockData = {
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

  beforeEach(() => {
    axios.get.mockResolvedValue(mockData);
  });

  beforeEach(() => {
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

  it("should render two tables", () => {
    expect(wrapper.findAll("table").length).toBe(2);
  });

  it("should check if a value is numeric", () => {
    expect(wrapper.vm.isNumeric(4)).toBe(true);
    expect(wrapper.vm.isNumeric("4")).toBe(true);
    expect(wrapper.vm.isNumeric("foo")).toBe(false);
  });

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
