var lastEscTime = 0
jQuery(function($) {
    $('#clearResults').click(function() { $('#results').empty() })
    $('#runScript').click(function() {
        $.post('/console/run', {script: $('#script').val()}, function(data) {
            $('<div/>').attr('class', 'console_result').html(data).appendTo('#results')
        })
    })
    $('#script').keydown(function(ev) {
        if (ev.ctrlKey && ev.keyCode == 13) $('#runScript').click() // Ctrl + Enter
        if (ev.keyCode == 27) {
            if (new Date().getTime() - lastEscTime < 1000) $('#clearResults').click() // Esc, Esc within a second
            lastEscTime = new Date().getTime()
        }
    })
})
