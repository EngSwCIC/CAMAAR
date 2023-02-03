<script>
export default {
  props: ["answer"],
  mounted() {
    this.resizeTextarea();
    this.$refs.textarea.addEventListener("input", this.resizeTextarea);
  },
  beforeUnmount() {
    this.$refs.textarea.removeEventListener("input", this.resizeTextarea);
  },
  methods: {
    resizeTextarea() {
      this.$refs.textarea.style.height = "auto";
      this.$refs.textarea.style.height =
        this.$refs.textarea.scrollHeight + "px";
    },
    onChangeSelectedIni(event) {
      this.iniValue = event;
    },
    onChangeSelectedEnd(event) {
      this.endValue = event;
    },
  },
  data() {
    return {
      optionsIni: [{ value: 0 }, { value: 1 }],
      optionsEnd: [
        { value: 2 },
        { value: 3 },
        { value: 4 },
        { value: 5 },
        { value: 6 },
        { value: 7 },
        { value: 8 },
        { value: 9 },
        { value: 10 },
      ],
      answer1: "teste",
      answer2: "teste",
      iniValue: 0,
      endValue: 5,
    };
  },
};
</script>

<template>
  <div>
    <div>
      <select
        v-model="iniValue"
        class="selection"
        @change="onChangeSelectedIni(iniValue)"
      >
        <option disabled value="">Escolha incio</option>
        <option v-for="{ value } in optionsIni" :key="value" :value="value">
          {{ value }}
        </option>
      </select>
      <span> E </span>
      <select
        v-model="endValue"
        class="selection"
        @change="onChangeSelectedEnd(endValue)"
      >
        <option disabled value="">Escolha final</option>
        <option v-for="{ value } in optionsEnd" :key="value" :value="value">
          {{ value }}
        </option>
      </select>
    </div>

    <div>
      <div>
        <span>{{ iniValue }}</span>
        <textarea
          ref="textarea"
          :value="answer1"
          placeholder="Marcador inicial (Opcional)"
          class="container"
        ></textarea>
      </div>
      <div>
        <span>{{ endValue }}</span>
        <textarea
          ref="textarea"
          :value="answer2"
          placeholder="Marcador Final (Opcional)"
          class="container"
        ></textarea>
      </div>
    </div>
    <div>
      <span>{{answer1}}</span>
      <!-- vfor ini ao end temos que ter entre ini e end opções de seleção de radio -->
      <span>{{answer2}}</span>
    </div>
  </div>
</template>

<style scoped>
.container {
  margin-top: 20px;
  margin-left: 20px;
  width: 10%;
}
.selection {
  width: 3%;
  margin: 5px;
}
</style>
