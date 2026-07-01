import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

document.addEventListener("DOMContentLoaded", function() {
  const avatar = document.querySelector(".user-avatar");
  if (!avatar) return; // evita erro nas páginas sem o avatar (ex: login)

  function toggleUserMenu() {
    document.getElementById("userMenu").classList.toggle("open");
  }

  avatar.addEventListener("click", toggleUserMenu);

  document.addEventListener("click", function(event) {
    const wrapper = document.querySelector(".user-avatar-wrapper");
    if (wrapper && !wrapper.contains(event.target)) {
      document.getElementById("userMenu").classList.remove("open");
    }
  });
});
