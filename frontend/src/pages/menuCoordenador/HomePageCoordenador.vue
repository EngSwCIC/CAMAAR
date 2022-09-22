<template>
  <div class="q-pa-md bg-secondary fullscreen">
    <q-layout
      view="hHh Lpr lff"
      container
      style="height: 900px"
      class="shadow-2 rounded-borders"
    >
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
            <div
              color="black"
              class="row justify-center"
              style="padding-top: 20%; padding-bottom: 10%; font-size: 30px"
            >
              MENU
            </div>
            <div
              class="row justify-center"
              style="padding-bottom: 10%; font-size: 20px; color: #9c27b0"
            >
              COORDENADOR
            </div>
            <template v-for="(menuItem, index) in menuList" :key="index">
              <q-item clickable :active="menuItem.label === 'Outbox'" v-ripple>
                <q-item-section style="color: white; background-color: #9C27B0" @click="$router.push('/surveys/c')">
                  Questionários
                </q-item-section>
              </q-item>
              <q-item clickable :active="menuItem.label === 'Outbox'" v-ripple>
                <q-item-section style="color: white; background-color: #9C27B0" @click="$router.push('/student-subjects/')">
                  Relatórios
                </q-item-section>
              </q-item>
              <q-item clickable :active="menuItem.label === 'Outbox'" v-ripple>
                <q-item-section style="color: white; background-color: #9C27B0" @click="$router.push('/import/')">
                  Importar SIGAA
                </q-item-section>
              </q-item>
              <q-separator :key="'sep' + index" v-if="menuItem.separator" />
            </template>
          </q-list>
        </q-scroll-area>
      </q-drawer>

      <q-page-container class="bg-grey-3">
        <q-page padding>
          <div
            class="text-h3 text-weigth-bold column items-center"
            style="color: #9c27b0"
          >
            <div>Bem vindo ao CAMAAR</div>
          </div>
          <h3
            id="coord"
            class="text-h3 text-weigth-thin column items-center"
            style="color: #000000; padding-top: 2%; padding-bottom: 3%"
          >
            Coordenador
          </h3>
        </q-page>
      </q-page-container>
    </q-layout>
  </div>
</template>

<script>
import { ref } from "vue";
const menuList = [
  {
    label: "QUESTIONÁRIOS",
    separator: false,
  },
];
export default {
  setup() {
    return {
      drawer: ref(true),
      menuList,
    };
  },
};
</script>
