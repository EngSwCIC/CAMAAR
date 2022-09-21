import ImportPage from "../../../src/pages/menuCoordenador/SurveysPageCoordenador.vue";
import { mount } from "@vue/test-utils";
import { installQuasarPlugin } from "@quasar/quasar-app-extension-testing-unit-jest";
import { Notify } from "quasar";
installQuasarPlugin({ plugins: Notify });

describe("Survey Professor Page Tests", () => {
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
    const header = wrapper.find("h1");
    expect(header.text()).toContain("Seus Questionários");
  });

  it("A pagina possui o botão de questionario 1", () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios,
        },
      },
    });
    const button = wrapper.find("#Button");
    expect(button.text()).toContain("Questionário 1");
  });

  it("A pagina possui o botão de questionario 2", () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios,
        },
      },
    });
    const button = wrapper.find("#Button");
    expect(button.text()).toContain("Questionário 2");
  });

  it("A pagina possui o botão de questionários", () => {
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

  it("A pagina possui o botão de importar do sigaa", () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios,
        },
      },
    });
    const button = wrapper.find("#Button");
    expect(button.text()).toContain("Importar SIGAA");
  });

  it("A pagina possui o botão de voltar", () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios,
        },
      },
    });
    const button = wrapper.find("#Button");
    expect(button.text()).toContain("Voltar");
  });

});
