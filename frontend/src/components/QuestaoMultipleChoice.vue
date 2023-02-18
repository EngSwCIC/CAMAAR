<template>
  <div>
    <div v-for="(option, val) in question.question_options" :key="option.id">
      <q-radio
        color="secondary"
        :name="'multiple_choice_answer' + question.id"
        :val="val"
        :model-value="modelValue.content"
        @update:model-value="(value) => $emit('update:modelValue', updateAnswer(value))"
      >
        <label>{{ option.content }}</label>
      </q-radio>
    </div>

  </div>

</template>

<script>
export default {
  props: ['question', 'modelValue'],
  methods: {
    updateAnswer(value) {
      return {
        ...this.modelValue,
        content: value
      }
    }
  }
}
</script>
