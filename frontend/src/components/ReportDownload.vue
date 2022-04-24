<template>
  <div>
    <q-btn @click="download" color="primary" label="Download do PDF" />
  </div>
</template>

<script setup>
import { jsPDF } from "jspdf";
import api from "src/services/api.js";

const download = () => {
  api.get("/pdf_reports", {
      params: {
        // class_id: 1
      },
    })
    .then((response) => {
      const doc = new jsPDF();
      var text = "";

      for (const k of ["surveys", "answers", "questions"]) {
        text += `\n\n${k}\n\n`
        for (const resp of response.data[k]) {
          text +=JSON.stringify(resp) + "\n";
        }
      }
      doc.text(text, 10, 10);
      doc.save("relatorio_professor.pdf");
    })
    .catch((error) => {
      console.log(error);
    });
};
</script>
