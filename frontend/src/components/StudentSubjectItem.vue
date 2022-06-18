<template>
  <div class="q-pa-md" style="margin-inline: 64px; padding: 0;">
    <!-- lista com dropdown (que pode ser expandida) -->
    <q-list bordered class="rounded-borders" style="width: 100%; margin: 0; background: #eee">
      <q-expansion-item
          expand-separator
          :label="subject.code + ' — ' + subject.name"
      >
        <q-card class="cursor-pointer q-hoverable" style="background: #ccddee; font-size: 0.95em;">
          <!-- TODO: listar as turmas dessa disciplina -->
          <q-card-section v-for="(cclass, idx) in subject_classes" v-bind:key="idx">
            <router-link :to="{path: `/student-class/${subject_classes[idx].id}`}">
              {{ `${formatClassCode(cclass.code)} (${cclass.semester})` }} — {{ teachers[idx] }} — {{ cclass.time }}
            </router-link>
          </q-card-section>
        </q-card>
      </q-expansion-item>
    </q-list>
  </div>
</template>

<script setup>
import axios from 'axios'
import {ref, onUpdated} from 'vue'
import {defineProps, reactive} from "vue";
import router from 'src/router';

const props = defineProps({
  subject: {  // disciplina
    required: true
  },
  subject_classes: {  // turmas da disciplina
    type: Array,
    required: true
  }
})

const formatClassCode = (code) => {
  return 'Turma ' + code[1]
}

const teachers = reactive([])

onUpdated(async () => {
  const getTeacherFromClass = async (class_id) => {
    let teacher;
    await axios.get(`http://localhost:3000/cclasses/${class_id}/members`)
        .then(resp => {
          let members = resp.data
          teacher = members.find(member => member['occupation'] == 'docente')
        })
        .catch(err => {
          alert(err)
          console.error(err);
        });

    if (teacher)
      return teacher['name']
    return 'A Definir'
  }

  for (let i = 0; i < props.subject_classes.length; i++) {
    teachers[i] = await getTeacherFromClass(props.subject_classes[i].id)
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
