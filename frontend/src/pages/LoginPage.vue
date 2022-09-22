<!-- eslint-disable vue/no-export-in-script-setup -->
<script setup>
import LoginCard from "src/components/LoginCard.vue";
import SubjectReportTable from "src/components/SubjectReportTable.vue";

let subject = {
  classes: [
    {
      grade: 55,
      name: 'T0'
    },
    {
      grade: 89,
      name: 'oi'
    }
  ],
  name: 'Engenharia de Software'
}

</script>
<template>
  <div class="bg-secondary fullscreen row items-center justify-center">
    <LoginCard class="col-11 col-sm-8 col-md-6 col-lg-4 col-xl-4" />
    <SubjectReportTable :subject="subject" />
  </div>
</template>
