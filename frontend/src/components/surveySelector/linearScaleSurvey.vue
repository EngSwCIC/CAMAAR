<script>
export default {
  methods: {
    onChangeSelectedIni(event) {
      this.iniValue = event;
      this.answer();
    },
    onChangeSelectedEnd(event) {
      this.endValue = event;
      this.answer();

    },
    answer: function () {
      this.$emit("answer", {
        iniValue: this.iniValue,
        endValue: this.endValue,
        iniAnswer: this.answer1,
        endAnswer: this.answer2,
      });
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
      answer1: "",
      answer2: "",
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
        <span class="selectValue">{{ iniValue }}</span>
        <input
          v-model="answer1"
          placeholder="Marcador inicial (Opcional)"
          class="container"
          @input="answer"
        />
      </div>
      <div>
        <span class="selectValue">{{ endValue }}</span>
        <input
          v-model="answer2"
          placeholder="Marcador Final (Opcional)"
          class="container"
          @input="answer"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
.container {
  margin-top: 20px;
  margin-left: 20px;
  width: 240px;
  border: none;
  border-bottom: 1px solid #000;
  background: transparent;
  outline: none;
  color: #000;
  font-size: 16px;
  transition: 0.5s;

}
.selection {
  margin: 5px;
  border: none;
  border-bottom: 1px solid #000;
  background: transparent;
  outline: none;
  color: #000;
  font-size: 16px;
  transition: 0.5s;
}

.selectValue {
  margin: 5px;
  font-size: 16px;
  transition: 0.5s;
}

</style>
