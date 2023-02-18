<template>
<q-card class="card" :id="`questao-${question_number}`">
    <h6 :class="'question' + (question.optional ? '' : ' required')">{{ question_number + ". " + question.question }}</h6>
    <div v-if="question.question_type.name == 'likert_scale'">
      <QuestaoLikert
        :question="question"
        :question_number="question_number"
        :modelValue="modelValue"
        @update:modelValue = "(value)=>$emit('update:modelValue',value)"
      />
    </div>
    <div v-else-if="question.question_type.name == 'multiple_choice'">

      <QuestaoMultipleChoice
        :modelValue="modelValue"
        :question="question"
        @update:modelValue = "(value)=>$emit('update:modelValue',value)"
      />
    </div>
    <div v-else>
        <QuestaoTextbox
        :modelValue ="modelValue"
        @update:modelValue = "(value)=>$emit('update:modelValue',value)"
        />
    </div>
</q-card>
</template>

<script>
import QuestaoTextbox from "./QuestaoTextbox.vue"
import QuestaoMultipleChoice from "./QuestaoMultipleChoice.vue"
import QuestaoLikert from "./QuestaoLikert.vue";

export default {
    components:{QuestaoLikert, QuestaoTextbox, QuestaoMultipleChoice},
    props: ['question', 'question_number', 'modelValue'],
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
