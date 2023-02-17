<template>
<q-card class="card" :id="`questao-${question_number}`">
    <h6 :class="'question' + (question.optional ? '' : ' required')">{{ question_number + ". " + question.question }}</h6>
    <div v-if="question.question_type.name == 'likert_scale'">
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
    </div>
    <div v-else-if="question.question_type.name == 'multiple_choice'">
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
    <div v-else>
        <QuestaoTextbox
        :modelValue ="modelValue"
        @update:modelValue = "(value)=>$emit('update:modelValue',value)"
        />
        
      <!--  <q-input
            class="textbox"
            color="secondary"
            outlined
            autogrow
            clearable
            :model-value="modelValue.content"
            @update:model-value="(value) => $emit('update:modelValue', updateAnswer(value))"
        /> -->
    </div>
</q-card>
</template>

<script>
import QuestaoTextbox from "./QuestaoTextbox.vue"

export default {
    components:{QuestaoTextbox},
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
        updateAnswer(value) {
            return {
                ...this.modelValue,
                content: value
            }
        },
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

.botoes_likert{
  display: flex;
  justify-content: space-around;
}

.question {
    font-size: 1.1rem;
    padding-bottom: 15px;
    margin: 0;
}

.likert-question {
    width: 120px;
    margin: 10px 15px;
}

.required::after {
    margin-left: 10px;
    content: '* Obrigatório';
    color: red;
    font-size: 0.8rem;
    font-weight: 400;
}

.card {
    margin: auto;
    margin-bottom: 40px;
    padding: 20px 15px;
    width: 100%;
}

.table {
    width: 100%;
}
</style>
