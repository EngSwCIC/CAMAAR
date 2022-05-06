<template>
  <div>
    <q-btn @click="download" color="primary" label="Download do PDF" />
  </div>
</template>

<script setup>
import { jsPDF } from "jspdf";
import api from "src/services/api.js";

const download = (surveys) => {
  api.get("/pdf_reports", {
      params: {
        // class_id: 1
      },
    })
    .then((response) => {
      const doc = new jsPDF();
      doc.text(response.data.data, 2 , 2);
      doc.save("relatorio_professor.pdf");
    })
    .catch((error) => {
      console.log(error);
    });
};
</script>
