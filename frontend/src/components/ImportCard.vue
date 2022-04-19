<template>
  <q-card class="q-mb-xl row justify-center q-pa-md">
    <h3 class="col-12">Importar</h3>
    <q-btn id="searchButton" label="Buscar Turmas" @click="search" color="secondary"/>
    <GenericTable
      name="Importar Turmas"
      select="multiple"
      :rows="rows"
      :fields="fields"
    />
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
        { id: 4, nome: 'T', codigo: 'Jami', turma: 'Carney', semestre: '2020-1', horario: '2T' }
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
  methods: {
    async search () {
      const resultado = await this.$axios.get("http://localhost:3030/turmas")
      this.rows = resultado.data.rows
    }
  },
}
</script>

<style>

</style>
