<template>
  <q-card class="col-8 q-pa-md row justify-center" id="cadastrados">
    <h3 class="col-12">Turmas Cadastradas</h3>
    <GenericTable
      ref="table"
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
    try {
      let resultado = await this.$axios.get("/api/turmas")
      resultado = resultado.data.map(turma=> {
        return {
          nome: turma.name,
          codigo: turma.subjectCode,
          turma: turma.code,
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
  },
  methods: {
    async updateRows () {
      try{
        let {data: resultado} = await this.$axios.get("/api/turmas")
        console.log(resultado)
        resultado = resultado.map(turma=> {
          return {
            nome: turma.name,
            codigo: turma.subjectCode,
            turma: turma.code,
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
