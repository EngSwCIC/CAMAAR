<template>
  <q-card class="q-mb-xl row justify-center q-pa-md">
    <h3 class="col-12">Importar</h3>
    <div class="col-12" align="center">
      <div class="col-12 q-mb-lg q-gutter-lg">
        <q-btn :loading="load" id="searchButton" label="Buscar Turmas no SIGAA" @click="search" color="secondary"/>
        <q-btn id="importButton" label="Importar para CAMAAR" @click="importSelected" color="teal-9"/>
      </div>
      <GenericTable
        ref="table"
        name="Importar Turmas"
        select="multiple"
        :rows="rows"
        :fields="fields"
      />
    </div>
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
      selectedRows: [],
      load: false,
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
  methods: {
    async importSelected() {
      console.log(this.selectedRows)
      if(this.selectedRows.length <= 0) {
        this.$q.notify({
          color: 'negative',
          message: 'Selecione uma ou mais turmas para importar.'
        })
        return
      }
      const turmasImportar = this.selectedRows.map(row => {
        return {
          code: row.codigo,
          classCode: row.turma
        }
      })
      try {
        const resultado = await this.$axios.post("http://localhost:3000/import/turmas", {
          classes: turmasImportar
        })
        this.$refs.table.selected = []

        this.$q.notify({
          color: 'positive',
          message: "Turmas selecionadas importadas com sucesso."
        })
        this.$emit('updateCadastradas')
      } catch (e) {
        console.log(e)
        this.$q.notify({
          color: 'negative',
          message: "Não foi possível importar as turmas selecionadas."
        })
      }

    },
    async search () {
      this.load = true
      try{

        let {data: resultado} = await this.$axios.get("http://localhost:3030/import/turmas")
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

      } catch (e) {
        this.$q.notify({
          color: "negative",
          message: "Erro ao buscar turmas"
        })
      }
      this.load = false
    }
  },
}
</script>

<style>

</style>
