import { shallowMount } from "@vue/test-utils";
import linearScaleSurvey from "src/components/surveySelector/linearScaleSurvey.vue";

describe("linearScaleSurvey", () => {
  it("emits the correct data on answer", () => {
    const wrapper = shallowMount(linearScaleSurvey);

    // Set the answers
    wrapper.vm.answer1 = "Answer 1";
    wrapper.vm.answer2 = "Answer 2";

    // Call the answer method and check that the answer event was emitted with the correct data
    wrapper.vm.answer();
    expect(wrapper.emitted("answer")).toBeTruthy();
    expect(wrapper.emitted("answer")[0]).toEqual([
      {
        iniValue: wrapper.vm.iniValue,
        endValue: wrapper.vm.endValue,
        iniAnswer: wrapper.vm.answer1,
        endAnswer: wrapper.vm.answer2
      }
    ]);
  });

  it("initializes data correctly", () => {
    const wrapper = shallowMount(linearScaleSurvey);

    // Check that the data is initialized correctly
    expect(wrapper.vm.optionsIni).toEqual([{ value: 0 }, { value: 1 }]);
    expect(wrapper.vm.optionsEnd).toEqual([
      { value: 2 },
      { value: 3 },
      { value: 4 },
      { value: 5 },
      { value: 6 },
      { value: 7 },
      { value: 8 },
      { value: 9 },
      { value: 10 }
    ]);
    expect(wrapper.vm.iniValue).toBe(0);
    expect(wrapper.vm.endValue).toBe(5);
    expect(wrapper.vm.answer1).toBe("");
    expect(wrapper.vm.answer2).toBe("");
  });

  it("should emit answer event when onChangeSelectedIni is called", () => {
    const wrapper = shallowMount(linearScaleSurvey);
    const event = 1;
    wrapper.vm.onChangeSelectedIni(event);
    expect(wrapper.emitted().answer).toBeTruthy();
  });

  it("should emit answer event when onChangeSelectedEnd is called", () => {
    const wrapper = shallowMount(linearScaleSurvey);
    const event = 2;
    wrapper.vm.onChangeSelectedEnd(event);
    expect(wrapper.emitted().answer).toBeTruthy();
  });

  it("should emit answer event when answer is called", () => {
    const wrapper = shallowMount(linearScaleSurvey);
    wrapper.vm.answer();
    expect(wrapper.emitted().answer).toBeTruthy();
  });
});
