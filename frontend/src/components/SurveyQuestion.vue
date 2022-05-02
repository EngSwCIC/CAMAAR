<template>
<div>
    <h6>{{ question_number + ". " + question.question }}</h6>    
    <div v-if="question.question_type == 'likert_scale'">
        <div>
            <thead>
                <th>Pergunta</th>
                <th v-for="(option, index) in likert_options" :key="index">
                    {{ option }}
                </th>
            </thead>
            <tbody>
                <tr v-for="(likert_question, l_index) in question.likert_scale.likert_questions" :key="likert_question.id">
                    <td>{{ likert_question.question }}</td>
                    <td v-for="(option, index) in likert_options" :key="index">
                        <input
                            type="radio"
                            :name="'likert_question_answer' + likert_question.id"
                            :value="option"
                            @input="$emit('update:modelValue', updateLikertAnswer($event.target.value, l_index))">
                    </td>
                </tr>
            </tbody>
        </div>
    </div>
    <div v-else-if="question.question_type == 'multiple_choice'">
        <div v-for="option in question.multiple_choice.options" :key="option.id">
            <input
                :id="option.id"
                type="radio"
                :name="'multiple_choice_answer' + question.id"
                :value="option.option"
                @input="$emit('update:modelValue', updateAnswer($event.target.value))"
            >
            <label :for="option.id">{{ option.option }}</label>
        </div>
    </div>
    <div v-else>
        <textarea :value="modelValue.content" @input="$emit('update:modelValue', updateAnswer($event.target.value))" />
    </div>
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
