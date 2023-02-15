import { shallowMount } from "@vue/test-utils";
import TextSurvey from "src/components/surveySelector/TextSurvey.vue";

describe("ResizableTextarea", () => {
  it("should resize textarea when input is inserted", async () => {
    const wrapper = shallowMount(TextSurvey);
    const textarea = wrapper.find("textarea");

    const input = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
    await textarea.setValue(input);

    expect(textarea.element.style.height).toBe(
      `${textarea.element.scrollHeight}px`
    );
  });

  it("is disabled", () => {
    const wrapper = shallowMount(TextSurvey, {
      props: {
        disabled: true
      }
    });

    const textarea = wrapper.find("textarea");
    expect(textarea.element.disabled).toBe(true);
  });
});
