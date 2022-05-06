<script setup>
import SelectClass from "../components/SelectClass.vue";
import SendButton from "../components/SendButton.vue"
import CheckboxInput from "../components/CheckboxInput.vue";
import SugestionField from "../components/SugestionField.vue"
import ScaleTable from "../components/ScaleTable.vue"
import CheckboxQuestions from "src/components/CheckboxQuestions.vue";
import {ref} from 'vue'
import {api} from "../boot/axios"

const selectQuestion = ref({
    pergunta: 'Selecione a Primeira Disciplina/Turma para analisar:',
    opcoes: [
        'ALGORITMOS E PROGRAMAÇÃO DE COMPUTADORES (GRADUAÇÃO) - Turma 05A - VINICIUS RUELA PEREIRA BORGES (60h) e RICARDO PEZZUOL JACOBI (30h)',
        'AUTÔMATOS E COMPUTABILIDADE (GRADUAÇÃO) - Turma A - JORGE CARLOS LUCERO (90h)'
    ]
})

const checkboxQuestion = ref({
    pergunta: 'Qual a metodologia de aferição da frequência do estudante que está sendo utilizada?',
    checkboxQuestions: [
        'Presença em aulas síncronas', 
        'Tarefas entregues (exercícios, trabalhos, resenhas, portifólios, etc)', 
        'Visualização de lições e vídeo aulas',
        'Não estou aferindo'
    ]
})

const ScaleQuestions = ref([
    // '1. O plano de ensino entregue no início do semestre foi ajustado.',
    // '2. Estou sendo efetivo na comunicação com os estudantes.',
    // '3. Utilizo recursos didáticos síncronos.',
    // '4. Utilizo recursos didáticos assíncronos.',
    // '5. As estratégias didáticas adotadas nesta disciplina estão sendo efetivas para aprendizagem.',
    // '6. A bibliografia básica da disciplina está disponível para acesso online.'
])

const SugestionQuestion = ref()

function getClass(){
    api.get("member_classes/45").then(response => {
        selectQuestion.value.opcoes = response.data.map(turmas => {
            return turmas.subject.name + " - " + turmas.subject.code
        })
    })
}

function getQuestions(){
    api.get("/surveys/1").then(response => {
            response.data.survey_questions.map((question) => {
                switch(question.question_type){
                    case "Escala":
                        ScaleQuestions.value.push(question.question)
                        break;

                    case "Dissertativa":
                        SugestionQuestion.value = question.question
                        break;
                }
            })
        }
    )
}


getClass()

getQuestions()

</script>
<template>
    <div className="container">
        <SelectClass :campos="selectQuestion"/>
        <CheckboxQuestions :campos="checkboxQuestion"/>
        <ScaleTable :questions="ScaleQuestions"/>
        <SugestionField :question="SugestionQuestion"/>
        <SendButton/>
    </div>
</template>

<style scoped>
    .container {
        display: flex;
        flex-flow: column wrap;
        justify-content: space-around;
        align-content: center;
        height: 100vh;
    }
</style>


