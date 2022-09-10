<template>
  <div class="q-pa-md bg-secondary fullscreen">
    <q-layout view="hHh Lpr lff" container style="height: 900px" class="shadow-2 rounded-borders">
      <q-header elevated class="bg-secondary">
        <q-toolbar>
          <q-btn flat @click="drawer = !drawer" round dense icon="menu" />
        </q-toolbar>
      </q-header>

      <q-drawer
        v-model="drawer"
        :width="200"
        :breakpoint="500"
        overlay
        bordered
        class="bg-menu"
      >
        <q-scroll-area class="fit">
          <q-list>
            <div color=black class="row justify-center" style="padding-top: 20%; padding-bottom: 10%;font-size: 30px" >
              MENU
            </div>
            <div class="row justify-center" style="padding-bottom: 10%;font-size: 20px; color: #9C27B0" >
              ALUNO
            </div>
            <template v-for="(menuItem, index) in menuList" :key="index">
              <q-item clickable :active="menuItem.label === 'Outbox'" v-ripple>
                <q-item-section style="color: white; background-color: #9C27B0">
                  {{ menuItem.label}}
                </q-item-section>
              </q-item>
              <q-separator :key="'sep' + index" v-if="menuItem.separator" />
            </template>

          </q-list>
        </q-scroll-area>
      </q-drawer>

      <q-page-container class="bg-grey-3">
        <q-page padding>
          <div class="text-h3 text-weigth-bold column items-center" style="color: #9C27B0">
            <div>Bem vindo ao CAMAAR</div>
          </div>
          <div class="text-h3 text-weigth-thin column items-center" style="color: #000000; padding-top: 2%; padding-bottom: 3%">
            <div>Aluno</div>
          </div>
          <div class="row justify-center" style="padding: 2%">
            <q-btn color="secondary" @click="redirect" style="font-size: 200%">
              Questionários (como aluno)
            </q-btn>
          </div>
        </q-page>
      </q-page-container>
    </q-layout>
  </div>
</template>

<script>
import { ref } from 'vue'
const menuList = [
    {
    label: 'QUESTIONÁRIOS',
    separator: false
  },
]
export default {
  setup () {
    return {
      drawer: ref(true),
      menuList
    }
  }
}
</script>