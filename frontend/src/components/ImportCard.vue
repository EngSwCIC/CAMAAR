<template>
  <q-card class="q-mb-xl row justify-center q-pa-md">
    <h3 class="col-12">Importar</h3>
    <q-btn :loading="load" id="searchButton" label="Buscar Turmas" @click="search" color="secondary"/>
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
    async search () {
      this.load = true
      try{

        let {data: resultado} = await this.$axios.get("http://localhost:3000/turmas")
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
