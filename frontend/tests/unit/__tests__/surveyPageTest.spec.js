import { mount } from "@vue/test-utils";
import axios from "axios";
import StudentClass from "@/components/StudentClass.vue";

describe("StudentClass", () => {
  let wrapper;

  beforeEach(() => {
    const id = 1;
    const url = "https://api.example.com";
    const response = await axios.get(url);
    const mockData = { data: response.data };
    wrapper = mount(StudentClass, {
      mocks: {
        $route: {
          params: {
            id,
          },
        },
      },
      data() {
        return {
          resposta: mockData.data,
        };
      },
    });
    it("should render two tables", () => {
      expect(wrapper.findAll("table").length).toBe(2);
    });
  });
});

