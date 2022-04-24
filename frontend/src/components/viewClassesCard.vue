<template>
  <q-card class="col-8 q-pa-md row justify-center" id="cadastrados">
    <h3 class="col-12">Turmas Cadastradas</h3>
    <GenericTable 
      name="Turmas Registradas" 
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
      rows: [],
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
   console.log(resultado)
   this.rows = resultado.data.rows
  },
  methods: {
    async updateRows () {
      try{
        console.log("oi1")
        let {data: resultado} = await this.$axios.get("http://localhost:3030/turmas")
        resultado = resultado.classes.map(turma=> {
          return {
            nome: turma.name,
            codigo: turma.code,
            turma: turma.class.classCode,
            semestre: turma.class.semester,
            horario: turma.class.time
          }
        })
        this.rows = resultado

        this.$q.notify({
          color: 'positive',
          message: "Turmas cadastradas atualizadas com sucesso."
        })
      } catch (e) {
        this.$q.notify({
          color: "negative",
          message: "Erro ao buscar turmas cadastradas"
        })
      }
    }
  }
}
</script>

<style>

</style>
