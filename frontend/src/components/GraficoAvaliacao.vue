<script>
import api from 'src/services/api.js';
export default {
    props: {
        api_url: String
    },
    data(){
        return {
            avaliationData: null,
            avaliationsOptions: [],
            selectedAvaliation: null, 
            avaliationsGrades: null,     
            avaliationRow: [],
            avaliationColumn: [
                { name: 'aluno', align: 'center', label: 'aluno', field: 'aluno', sortable: false },
                { name: 'avaliação', align: 'center', label: 'avaliação', field: 'avaliacao', sortable: false },
            ],           
        }        
    },    
    methods: {
        async fetchData() {
            this.avaliationData = null
            const res = await api.get(this.api_url)
                .then(response => {
                    this.avaliationData = response.data;
                    this.avaliationsGrades = []
                    response.data.map((avaliation, idx) =>{
                        this.avaliationsOptions.push({
                            label: avaliation.title,
                            value: idx
                        });
                        let grades = {}
                        let avaliationRowAux = {}
                        avaliation.answers.map((ans) => {

                            if(!(ans.option_id in grades)){
                                grades[ans.option_id] = [0,0,0,0,0]
                            }

                            grades[ans.option_id][ans.alternative_answer-1]+=1

                            if(ans.option_id in avaliationRowAux){
                                avaliationRowAux[ans.option_id] = [
                                    ...avaliationRowAux[ans.option_id],
                                    {
                                        name: "aluno " + ans.id,
                                        aluno: "aluno " + ans.member_id,
                                        avaliacao: ans.alternative_answer,
                                    }
                                ]
                            }else{
                                avaliationRowAux[ans.option_id] = [
                                    {
                                    name: "aluno " + ans.id,
                                    aluno: "aluno " + ans.member_id,
                                    avaliacao: ans.alternative_answer,
                                    }
                                ]
                            }

                        })
                        this.avaliationRow.push(avaliationRowAux)
                        this.avaliationsGrades.push(grades)
                    })
                })
                .catch(error => {
                    console.log(error);
                });            
            // const res = await fetch(`https://canvasjs.com/services/data/datapoints.php?xstart=1&ystart=1&length=5&type=json`);            
        }
    },
    mounted() {
        this.fetchData()
    },
        
    name: "AvaliationComponent",
    components: {},
  
};
</script>

<template>
    <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; width: 100%;">
        <div style="display: flex; flex-direction: column; width: 80%;">
            <br><br><br><br>
            <!-- {{avaliationsGrades}}-{{avaliationData}} -->
            <!-- {{avaliationsGrades}} -->
            <q-select outlined v-model="selectedAvaliation" :options="avaliationsOptions" label="Selecione a avaliação" emit-value map-options/>
            <div v-if="selectedAvaliation!==null && avaliationData" style="width:100%; height: 100%;">
                <h4>Análise: {{avaliationData[selectedAvaliation].title}}</h4>
                <div v-for="(option, i) in avaliationData[selectedAvaliation].options" :key="i">
                    <h5>{{option.description}}?</h5>       
                    <!-- <div v-for="(answer, i) in avaliationData[selectedAvaliation].answers" :key="i">
                        Aluno: {{answer.member_id}} -
                        Nota: {{answer.alternative_answer}}
                    </div> -->
                    <q-table
                        title="Avaliações"
                        :rows="avaliationRow[selectedAvaliation][option.id]"
                        :columns="avaliationColumn"
                        row-key="name"
                    />
                    <br><br><br><br>
                    <column-chart v-if="selectedAvaliation!==null && avaliationsGrades && avaliationsGrades[selectedAvaliation] && avaliationsGrades[selectedAvaliation][option.id]" :data="[['&#128560;', avaliationsGrades[selectedAvaliation][option.id][0]], ['&#128577;', avaliationsGrades[selectedAvaliation][option.id][1]], ['&#129300;', avaliationsGrades[selectedAvaliation][option.id][2]], ['&#128578;', avaliationsGrades[selectedAvaliation][option.id][3]], ['&#128516;', avaliationsGrades[selectedAvaliation][option.id][4]]]" ytitle="Num. Alunos" ></column-chart>
                    <br><br><br><br>
                </div>
            </div>
        </div>
    </div>
</template>