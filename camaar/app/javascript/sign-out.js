document.addEventListener('DOMContentLoaded', function() {
    var userButton = document.getElementById('userButton');
    var signOut = document.getElementById('signOut');
  
    userButton.addEventListener('click', function() {
      signOut.style.display = (signOut.style.display === 'block') ? 'none' : 'block';
    });
  
    document.addEventListener('click', function(event) {
      if (!userButton.contains(event.target) && !signOut.contains(event.target)) {
        signOut.style.display = 'none';
      }
    });
  });
  