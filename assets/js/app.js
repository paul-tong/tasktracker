// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import $ from "jquery";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function update_buttons() {
  $('.time-button').each( (_, bt) => {
    let start = $(bt).data('start_time');
    if (start == "") {
      $(bt).text("Start");
    }
    else {
      $(bt).text("Stop");
    }
  });
}

function time_click(ev) {
  let bt = $(ev.target);
  let start = bt.data('start_time');

  if (start == "") { 
    bt.data('start_time', Date.now());
  }
  else {
    let start = bt.data('start_time')
    let stop = Date.now();
    let task_id = bt.data('task_id');
    add_time_block(task_id, start.toString(), stop.toString());
    bt.data('start_time', "");
  }
  update_buttons();
}


function add_time_block(task_id, start, stop) {
  let text = JSON.stringify({
    timeblock: {
        task_id: task_id,
        start_time: start,
        stop_time: stop
      },
  });

  $.ajax(time_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { alert("add timeblock success!"); },
    error: (resp) => {alert("add timeblock failed!");},
  });
}


function init_time() {
  if (!$('.time-button')) {
    alert("no button");
    return;
  }

  $(".time-button").click(time_click);

  update_buttons();
}

$(init_time);
