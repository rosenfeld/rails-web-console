//
//= require jquery
//= require cookie.js
//= require command_cache.js
//= require_self


$(function() {

var commandHistory = new CommandCache();
var commandIndex = commandHistory.length();
var results = $('#results');
var runScriptButton = $('#run-script');

var script = $('#script');
script[0].focus();

$('html').on('click', function() {
  script[0].focus();
});

runScriptButton.on('click', runScript);
script.on('keydown', onKeyDown);

function out(content, className) {
  var div = document.createElement('div');
  div.setAttribute('class', className || '');
  div.innerHTML = content;
  results.append(div);
  script[0].scrollIntoView();
}

function runScript() {
  var command = script.val();

  out("&#10095; "+command, 'command');
  script.val('');

  if (command == '') {
    return;
  }

  commandHistory.push(command);

  // current command is the last one + 1 (which is empty)
  commandIndex = commandHistory.length();

  $.post(console_context.run_path, {script: command}, function(response) {
    out(response.stdout, 'result type-stdout');
    out(response.value, 'result type-'+response.type);
  }, 'json')
}

function onKeyDown(ev) {
  if (ev.keyCode == 13) {
    runScript();
    ev.preventDefault();
  }
  if (ev.keyCode == 38) { //UP
    if (commandIndex > 0) {
      commandIndex -= 1;
    }
    script.val(commandHistory[commandIndex]);
  }
  if (ev.keyCode == 40) { //DOWN
    if (commandIndex < commandHistory.length()) {
      commandIndex += 1;
    }
  }
  if (ev.keyCode == 40 || ev.keyCode == 38) {
    if (commandIndex == commandHistory.length()) {
      // scroll down to get empty prompt again
      script.val('');
    } else { 
      script.val(commandHistory.get(commandIndex));
    }
  }
}


})







