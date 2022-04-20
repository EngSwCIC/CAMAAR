<template>
  <div class="q-pa-md" style="margin-inline: 64px; padding: 0;">
    <!-- lista com dropdown (pode ser expandida) -->
    <q-list bordered class="rounded-borders" style="width: 100%; margin: 0; background: #eee">
      <q-expansion-item
        expand-separator
        :label="subject.code + ' — ' + subject.name"
      >
        <q-card class="cursor-pointer q-hoverable" style="background: #ccddee; font-size: 0.95em;">
          <!-- TODO: listar as turmas dessa disciplina -->
          <q-card-section v-for="(cclass, idx) in classes" v-bind:key="idx">
            {{formatClassCode(cclass.code)}} — {{getTeacherFromClass(cclass.id)}} —  {{cclass.time}}
          </q-card-section>
        </q-card>
      </q-expansion-item>
    </q-list>
  </div>
</template>

<script setup>
  import axios from 'axios'
  import { ref } from 'vue'

  const props = defineProps({
    subject: {  // disciplina
      required: true
    },
    classes: {  // turmas da disciplina
      required: true
    },
  })

  const formatClassCode = (code) => {
    return 'Turma ' + code[1]
  }

  const teacher = ref({})

  const getTeacherFromClass = (class_id) => {
    axios.get(`http://localhost:3030/cclasses/${class_id}/members`)
      .then(resp => {
        let members = resp.data
        teacher.value = members.find(member => member['occupation'] == 'docente')
      })
      .catch(err => {
        alert(err)
        console.error(err);
      });

    if (teacher.value)
      return teacher.value['name']
    return 'A Definir'
  }

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
