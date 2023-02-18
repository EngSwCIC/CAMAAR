<template>
  <div>
    <q-markup-table>
      <thead>
      <th>Questão</th>
      <th v-for="(option, index) in likert_options" :key="index">
        {{ option }}
      </th>
      </thead>
      <tbody>
      <tr v-for="(likert_question,l_index) in question.likert_scale_questions" :key="likert_question.id">
        <div class="likert-question">{{ likert_question.question }}</div>
        <td v-for="(option, index) in likert_options" :key="index">
          <div>
            <q-radio
              color="secondary"
              :name="'likert_question_answer' + likert_question.question_number"
              :val="option"
              :model-value="modelValue.likert_answers_attributes[l_index].content"
              @update:model-value="(value) => $emit('update:modelValue', updateLikertAnswer(value, l_index))"
            >
              <label></label>
            </q-radio>
          </div>
        </td>
      </tr>
      </tbody>
    </q-markup-table>

  </div>
</template>



<script>
export default {
  props: ['question', 'question_number', 'modelValue'],
  data() {
    return{
      likert_options: [
        'Discordo totalmente',
        'Discordo parcialmente',
        'Não sei/Não se aplica',
        'Concordo parcialmente',
        'Concordo totalmente'
      ]
    }
  },
  methods: {
    updateLikertAnswer(value, index) {
      return {
        ...this.modelValue,
        likert_answers_attributes:
          this.modelValue.likert_answers_attributes.map((answer, idx) => {
            if (index == idx)
              return {
                ...answer,
                content: value
              }
            else
              return answer
          })
      }
    }
  }
}
</script>

<style scoped>
td {
  text-align: center;
}

th {
  text-align: center;
  font-size: 0.8rem;
}

.likert-question {
  width: 120px;
  margin: 10px 15px;
}
</style>
