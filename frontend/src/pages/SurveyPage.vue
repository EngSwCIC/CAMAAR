<template>
<div v-if="survey">
    <h2> {{ survey.name }} </h2>
    <p> {{ survey.description }} </p>
    <div v-for="(cclass, c_index) in cclasses" :key="cclass.id">
        <div>
            <h4>{{ cclass.subject.code + ' - ' + cclass.subject.name }}</h4>
        </div>
        <div v-for="(question, q_index) in survey.survey_questions" :key="question.id" >
            <SurveyQuestion
                :question="question"
                :question_number="q_index+1"
                v-model="survey_answers[c_index].answers_attributes[q_index]"
            />
        </div>
    </div>
    <q-btn
        @click="submitAnswer"
        rounded
        color="secondary"
    >Enviar</q-btn>
</div>
</template>

<script>
import SurveyQuestion from '../components/SurveyQuestion.vue'
import axios from 'axios'
import { useQuasar } from 'quasar'
import { useRouter } from 'vue-router'

export default {
    components: {
        SurveyQuestion,
    },
    data() {
        return {
        survey: null,
        cclasses: null,
        survey_answers: []
        };
    },
    setup() {
        const $q = useQuasar()
        const router = useRouter()

        const notify = (param) => {
            $q.notify(param)
        }

        return {
            notify,
            router
        }
    },
    async mounted() {
        try {
            const res_s = await axios.get('http://localhost:3000/surveys/' + this.$route.params.id)
            this.survey = res_s.data
        } catch(err) {
            console.error(err)
            this.notify({
                message: 'Erro ao carregar questionário.',
                position: 'top',
                color: 'negative'
            })
            this.router.push({path: '/home'})
        }

        // Temporariamente usa id de membro = 1 para protótipo do questionário
        const res_c = await axios.get(`http://localhost:3000/members/${1}/cclasses`)
        this.cclasses = res_c.data

        this.cclasses.forEach(cclass => {
           this.survey_answers.push({
               survey_id: this.survey.id,
               cclass_id: cclass.id,
               answers_attributes: this.survey.survey_questions.map(question => {
                    if (question.question_type == 'likert_scale')
                        return {
                            survey_question_id: question.id,
                            question_type: question.question_type,
                            likert_answers_attributes: question.likert_scale.likert_questions.map(l_question => (
                                {
                                    likert_question_id: l_question.id,
                                    content: ''
                                }
                            ))
                        }
                    else
                        return {
                            survey_question_id: question.id,
                            question_type: question.question_type,
                            content: ''
                        }

               })
           })
        }); 
    },
    methods: {
        async submitAnswer() {
            this.survey_answers.forEach(async subject_answer => {
                try {
                    const res = await axios.post(
                        'http://localhost:3000/survey_answers',
                        subject_answer, { 
                            headers: {
                                Authorization: 'Bearer ' + localStorage.getItem('token')
                            }
                        })

                    this.notify({
                        message: 'Resposta enviada com sucesso!',
                        position: 'top',
                        color: 'positive'
                    })
            
                    this.router.push({path: '/home'})
                } catch(err) {
                    this.notify({
                        message: 'Falha ao enviar resposta.',
                        position: 'top',
                        color: 'negative'
                    })
                }
                

            })
        }
    }
};
</script>