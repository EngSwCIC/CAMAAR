<template>
  <div id="app" ref="testHtml">
    <h1>Test heading</h1>
    <!-- <button @click="getDataApi">GET Data</button> -->
    <div>
      <label>Para fazer download do relatório</label>
      <br>
      <button @click="download">Download</button>
    </div>
  </div>
</template>

<script setup>
import { jsPDF } from "jspdf";
import api from 'src/services/api.js';

const download = () => {
  api.get('/pdf_reports', {
    params: {
      class_id: 1
    }
  })
  .then(response => {
    const doc = new jsPDF();

    // const answers = response.data.answers.map( (a) => {
    //   return [a.id.toString(), a.member_id.toString(), a.option_id.toString(), a.created_at.toString(), a.updated_at.toString() ];
    // });
    const text = JSON.stringify(response.data)
    doc.text(text, 10, 10);
    doc.save("a4.pdf");

    console.log('Download Here!');
  })
  .catch(error => {
    console.log(error);
  });
};

</script>
