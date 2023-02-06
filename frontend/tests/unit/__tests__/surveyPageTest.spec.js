import { shallowMount } from "@vue/test-utils";
import axios from "axios";
import TableComponent from "../../../src/components/TableComponent";

jest.mock("axios", () => ({
  get: jest.fn().mockResolvedValue({ data: ["api/surveys/1/answers"] }),
}));

describe("Table.vue", () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(TableComponent, {
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

  it("calls getAnswers when created", () => {
    expect(axios.get).toHaveBeenCalledWith("api/surveys/1/answers");
  });
});
