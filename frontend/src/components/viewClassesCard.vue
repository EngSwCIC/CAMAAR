<template>
  <q-card class="col-8 q-pa-md row justify-center" id="cadastrados">
    <h3 class="col-12">Turmas Cadastradas</h3>
    <GenericTable name="Turmas Registradas" :rows="rows" :fields="fields" />
  </q-card>
</template>

<script>
import GenericTable from "src/components/GenericTable.vue"
export default {
  components: {
    GenericTable,
  },
  data() {
    return {
      rows: [
        { id: 1, nome: 'D', codigo: 'Dickerson', turma: 'Macdonald', semestre: '2020-1', horario: '2T' },
        { id: 2, nome: 'E', codigo: 'Larsen', turma: 'Shaw', semestre: '2020-1', horario: '2T' },
        { id: 3, nome: 'G', codigo: 'Geneva', turma: 'Wilson', semestre: '2020-1', horario: '2T' },
        { id: 4, nome: 'T', codigo: null, turma: 'Carney', semestre: '2020-1', horario: '' }
      ],
      fields: [
        {name:'nome', align: 'center', label: 'Nome', field: 'nome'},
        {name:'codigo', align: 'center', label: 'Código', field: 'codigo'},
        {name:'turma', align: 'center', label: 'Turma', field: 'turma'},
        {name:'semestre', align: 'center', label: 'Semestre', field: 'semestre'},
        {name:'horario', align: 'center', label: 'Horário', field: 'horario'}
      ]
    }
  },
}
</script>

<style>

</style>
