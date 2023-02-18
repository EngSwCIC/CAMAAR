import { shallowMount } from "@vue/test-utils";
import TextSurvey from "src/components/surveySelector/TextSurvey.vue";

describe("ResizableTextarea", () => {
  // let addEventListener;
  // let removeEventListener;

  // beforeAll(() => {
  //   addEventListener = jest.spyOn(window, "addEventListener");
  //   removeEventListener = jest.spyOn(window, "removeEventListener");
  // });

  // afterAll(() => {
  //   addEventListener.mockRestore();
  //   removeEventListener.mockRestore();
  // });

  // it("deve remover o Autosize", () => {
  //   wrapper.unmount();
  //   expect(removeEventListenerSpy).toHaveBeenCalledWith(
  //     "input",
  //     expect.any(Function)
  //   );
  //   removeEventListenerSpy.mockRestore();
  // });

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

  it("should remove input event listener on unmount", () => {
    const removeEventListenerMock = jest.fn();
    const addEventListenerMock = jest.fn();
    const wrapper = shallowMount(TextSurvey);

    // mock addEventListener method
    wrapper.vm.$refs.textarea.addEventListener = addEventListenerMock;
    wrapper.vm.$refs.textarea.removeEventListener = removeEventListenerMock;

    // trigger beforeUnmount hook
    wrapper.unmount();

    // assert removeEventListener was called with expected arguments
    expect(removeEventListenerMock).toHaveBeenCalledWith(
      "input",
      wrapper.vm.resizeTextarea
    );
  });
});
