document.addEventListener('DOMContentLoaded', function() {
    var menuButton = document.getElementById('menuButton');
    var sideBar = document.getElementById('sideBar');
  
    menuButton.addEventListener('click', function() {
      sideBar.style.display = (sideBar.style.display === 'block') ? 'none' : 'block';
    });
  
    document.addEventListener('click', function(event) {
      if (!menuButton.contains(event.target) && !sideBar.contains(event.target)) {
        sideBar.style.display = 'none';
      }
    });
  });
  