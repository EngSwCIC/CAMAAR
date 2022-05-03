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
    let resultado = await this.$axios.get("http://localhost:3030/turmas")
    console.log('rows', resultado)
    resultado = resultado.data.classes.map(turma=> {
      return {
        nome: turma.name,
        codigo: turma.code,
        turma: turma.classCode,
        semestre: turma.semester,
        horario: turma.time
      }
    })
    this.rows = resultado
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
            turma: turma.classCode,
            semestre: turma.semester,
            horario: turma.time
          }
        })
        this.rows = resultado

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
