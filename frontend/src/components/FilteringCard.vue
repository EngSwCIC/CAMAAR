<script setup>
function searchSurvey() {
    return 0;
}
</script>

<style>
#professorSurveySearch {
  background-image: url('/css/searchicon.png'); /* Add a search icon to input */
  background-position: 10px 12px; /* Position the search icon */
  background-repeat: no-repeat; /* Do not repeat the icon image */
  width: 100%; /* Full-width */
  font-size: 16px; /* Increase font-size */
  padding: 12px 20px 12px 40px; /* Add some padding */
  border: 1px solid #ddd; /* Add a grey border */
  margin-bottom: 12px; /* Add some space below the input */
}

#myUL {
  /* Remove default list styling */
  list-style-type: none;
  padding: 0;
  margin: 0;
}
</style>

<template>
    <body>
         <input type="text" id="professorSurveySearch" onkeyup="searchSurvey()" placeholder="Procurar questionários...">
        <ul id="myUL">
            <filtered-card>
        </ul> 
    </body>
</template>