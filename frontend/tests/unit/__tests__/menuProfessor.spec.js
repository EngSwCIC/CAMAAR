import ImportPage from "../../../src/pages/menuProfessor/HomePageProfessor.vue";
import { mount } from "@vue/test-utils";
import { installQuasarPlugin } from "@quasar/quasar-app-extension-testing-unit-jest";
import { Notify } from "quasar";
installQuasarPlugin({ plugins: Notify });

describe("Home Page Tests", () => {
  it("A página existe", () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios,
        },
      },
    });
    expect(wrapper).toBeTruthy();
  });

  it("A página possui título", () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios,
        },
      },
    });
    const header = wrapper.find("h3");
    expect(header.text()).toContain("Bem Vindo ao CAMAAR");
  });

  it("A página possui segundo título", () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios,
        },
      },
    });
    const header = wrapper.find("h3");
    expect(header.text()).toContain("Professor");
  });

  it("A pagina possui o botão de questionarios", () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios,
        },
      },
    });
    const button = wrapper.find("#Button");
    expect(button.text()).toContain("Questionários");
  });

  it("A pagina possui o botão de relatórios", () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios,
        },
      },
    });
    const button = wrapper.find("#Button");
    expect(button.text()).toContain("Relatórios");
  });

});
