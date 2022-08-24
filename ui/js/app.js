var Ui = {};
var calls = 0;

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var data = event.data;

        switch (data.type) {
            case 'show':
                Ui.Show(data);
                break;
            case 'alert':
                Ui.Alert(data);
                break;
            case 'setalert':
                Ui.SetAlert(data);
                break;
            case 'clear':
                Ui.Clear();
                break;
        }
    });
});

Ui.Show = function (data) {
    if (data.action) {
        $(".container").fadeIn("0.1s");
    } else {
        $(".container").fadeOut("0.1s");
    };
};

Ui.Clear = function (data) {
    calls = 0;

    $(".dp-right-bar").hide();

    $(".dp-alert-cont h1").text('');
    $(".dp-alert-cont p").text('');
    $(".dp-right-bar p").text(0 + '/' + 0);

    $(".dp-alert-noalert").show();
};

Ui.Alert = function (data) {
    calls = data.allcalls;

    $(".dp-right-bar").show();

    $(".dp-alert-cont h1").text(data.title);
    $(".dp-alert-cont p").text(data.content);
    $(".dp-right-bar p").text(data.numcall + '/' + calls);

    $(".dp-alert-noalert").hide();
};

Ui.SetAlert = function (data) {
    $(".dp-alert-cont h1").text(data.title);
    $(".dp-alert-cont p").text(data.content);
    $(".dp-right-bar p").text(data.numcall + '/' + calls);
};