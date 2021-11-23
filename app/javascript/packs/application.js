// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

const bootstrap = require("bootstrap")
require("../stylesheets/application")
require("../client/direct-upload")

// DOM Ready
document.addEventListener("DOMContentLoaded", () => {
  // initialize tooltips
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach((el) => {
    new bootstrap.Tooltip(el)
  })
})

window.EasyMDE = require("easymde")
window.marked = require("marked")
