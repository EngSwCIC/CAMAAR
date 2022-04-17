<script setup>
  import GenericTable from 'src/components/GenericTable.vue'
  const fields = ['nome', 'codigo', 'codigo_da_turma', 'semestre', 'horario']
  const items = [
                { id: 1, nome: 'D', codigo: 'Dickerson', codigo_da_turma: 'Macdonald', semestre: '2020-1', horario: '2T' },
                { id: 2, nome: 'E', codigo: 'Larsen', codigo_da_turma: 'Shaw', semestre: '2020-1', horario: '2T' },
                { id: 3, nome: 'G', codigo: 'Geneva', codigo_da_turma: 'Wilson', semestre: '2020-1', horario: '2T' },
                { id: 4, nome: 'T', codigo: 'Jami', codigo_da_turma: 'Carney', semestre: '2020-1', horario: '2T' }
              ] 
</script>

<template>
<div class="bg-secondary fullscreen column items-center justify-center">
  <h1>Import Page</h1>
  <GenericTable rows=items columns=fields />
</div>
</template>

