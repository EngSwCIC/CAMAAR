import { shallowMount } from "@vue/test-utils";
import SurveyQuestion from "../../../src/components/surveySelector/surveySelectorComponent.vue";
import TextSurvey from "../../../src/components/surveySelector/textSurvey.vue";
import RadioSurvey from "../../../src/components/surveySelector/radioSurvey.vue";
import CheckboxSurvey from "../../../src/components/surveySelector/checkboxSurvey.vue";
import LinearScaleSurvey from "../../../src/components/surveySelector/linearScaleSurvey.vue";

describe("SurveyQuestion", () => {
  it("emits a surveyAnswer event on mounted", () => {
    const wrapper = shallowMount(SurveyQuestion);
    const expectedEvent = {
      questionTitle: "",
      selectedType: "text",
      answer: ""
    };
    expect(wrapper.emitted("surveyAnswer")[0][0]).toMatchObject(expectedEvent);
  });

  it('renders the TextSurvey component when selectedType is "text"', () => {
    const wrapper = shallowMount(SurveyQuestion, {
      data() {
        return {
          selectedType: "text"
        };
      }
    });
    expect(wrapper.findComponent(TextSurvey).exists()).toBe(true);
  });

  it('renders the RadioSurvey component when selectedType is "radio"', () => {
    const wrapper = shallowMount(SurveyQuestion, {
      data() {
        return {
          selectedType: "radio"
        };
      }
    });
    expect(wrapper.findComponent(RadioSurvey).exists()).toBe(true);
  });

  it('renders the CheckboxSurvey component when selectedType is "checkbox"', () => {
    const wrapper = shallowMount(SurveyQuestion, {
      data() {
        return {
          selectedType: "checkbox"
        };
      }
    });
    expect(wrapper.findComponent(CheckboxSurvey).exists()).toBe(true);
  });

  it('renders the LinearScaleSurvey component when selectedType is "linear"', () => {
    const wrapper = shallowMount(SurveyQuestion, {
      data() {
        return {
          selectedType: "linear"
        };
      }
    });
    expect(wrapper.findComponent(LinearScaleSurvey).exists()).toBe(true);
  });

  it("emits a surveyAnswer event with the answer when getAnswer method is called", () => {
    const wrapper = shallowMount(SurveyQuestion, {
      data() {
        return {
          questionTitle: "What is your favorite color?"
        };
      }
    });
    const answer = "blue";
    wrapper.vm.getAnswer(answer);
    const expectedEvent = {
      questionTitle: "What is your favorite color?",
      selectedType: "text",
      answer
    };
    expect(wrapper.emitted("surveyAnswer")[1][0]).toMatchObject(expectedEvent);
  });

  it("emits a surveyAnswer event with an empty answer when typeChange method is called", () => {
    const wrapper = shallowMount(SurveyQuestion, {
      data() {
        return {
          questionTitle: "What is your favorite color?",
          selectedType: "text"
        };
      }
    });
    wrapper.vm.typeChange();
    const expectedEvent = {
      questionTitle: "What is your favorite color?",
      selectedType: "text",
      answer: ""
    };
    expect(wrapper.emitted("surveyAnswer")[0][0]).toMatchObject(expectedEvent);
  });
});
