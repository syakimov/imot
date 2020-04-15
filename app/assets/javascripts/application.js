// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require_tree .

$(() => {
  const removeRow = (event) => {
    // a -> td -> tr
    event.target.parentElement.parentElement.remove()
  }

  const markAsVisited = (event) => {
    event.target.parentElement.parentElement.className = 'visited'
  }

  const markAsStarred = (event) => {
    if (event.target.innerHTML === '[★]') {
      event.target.innerHTML = '[ ]'
    } else {
      event.target.innerHTML = '[★]'
    }
  }

  $('td.js_index a').click(removeRow);
  $('td.js_link a').click(markAsVisited);
  $('td.js_star a').click(markAsStarred);
});
