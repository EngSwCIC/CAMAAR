<script>
  import GenericTable from "src/components/GenericTable.vue"
  export default {
    name: 'ImportPage',
    components: {
      GenericTable
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
    async mounted() {
      const resultado = await this.$axios.get("http://localhost:3030/turmas")
      this.rows = resultado.data.rows
    }
  }
</script>

<template>
<div class="bg-secondary fullscreen column items-center text-center justify-center">
  <h1>Import Page</h1>
  <GenericTable name="Turmas Registradas"  :rows="rows" :fields="fields" />
</div>
</template>

