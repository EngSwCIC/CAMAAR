<template>
  <div class="q-pa-md" style="margin-inline: 64px; padding: 0;">
    <!-- lista com dropdown (pode ser expandida) -->
    <q-list bordered class="rounded-borders" style="width: 100%; margin: 0; background: #eee">
      <q-expansion-item
        expand-separator
        :label="subject.code + ' — ' + subject.name"
      >
        <q-card style="background: #ccddee;">
          <!-- TODO: listar as turmas dessa disciplina -->
          <q-card-section>
            TURMA A — NOME DO PROFESSOR — HORÁRIO
          </q-card-section>
        </q-card>
      </q-expansion-item>
    </q-list>
  </div>
</template>

<script setup>
  const props = defineProps({
  subject: {
    required: true
  }
})

</script>

<style>
  .q-list {
    border-color: #c7c7c7;
  }
  .q-expansion-item--expanded {
    border-color: #5ed3c8;
    background-color: #5ed3c8;
  }
</style>
