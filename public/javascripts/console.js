jQuery(function($) {
    $('#clearResults').click(function() { $('#results').empty() })
    $('#runScript').click(function() {
        $.post('/console/run', {script: $('#script').val()}, function(data) {
            $('<div/>').attr('class', 'console_result').html(data).appendTo('#results')
        })
    })
})
