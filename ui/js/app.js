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
            case 'dist':
                Ui.Dist(data);
                break;
            case 'aceptAlert':
                Ui.aceptAlert();
                break;
            case 'openLargeDis':
                Ui.OpenLargeDispatch(data)
                break;
            case 'updateUserData':
                Ui.UpdatePopData(data)
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

    $(".dp-alert-cont h1").text('No Alerts');
    $(".dp-alert-cont p").text('Theres no alerts');
    $(".page-cont").removeClass('panic');
    $(".page-cont").text(0 + '/' + 0);
    $('.dp-alert-color').hide()
    $(".dp-alert-cont h3").text('You currently have no alerts');
    $(".dp-alert-cont h4").hide();
    $(".dp-alert-cont h5").hide();
};

Ui.Alert = function (data) {
    calls = data.allcalls;

    if (data.panic) {
        $(".page-cont").addClass('panic');
    } else {
        $(".page-cont").removeClass('panic');
    }

    if (data.color) {
        $('.dp-alert-color').show();
        $(".dp-alert-cont h5").show();
        $('.dp-alert-color').css("background-color", 'rgb(' + data.color + ')');
    } else {
        $('.dp-alert-color').hide()
        $(".dp-alert-cont h5").hide();
    }

    $(".dp-right-bar").show();

    $(".dp-alert-cont h1").text(data.title);
    $(".dp-alert-cont p").text(data.content);
    $(".dp-alert-cont h3").text('[ID: ' + data.id + ']');
    $(".page-cont").text(data.numcall + '/' + calls);
    $(".dp-alert-cont h4").show();
};

Ui.SetAlert = function (data) {
    if (data.panic) {
        $(".page-cont").addClass('panic');
    } else {
        $(".page-cont").removeClass('panic');
    }

    if (data.color) {
        $('.dp-alert-color').show();
        $(".dp-alert-cont h5").show();
        $('.dp-alert-color').css("background-color", 'rgb(' + data.color + ')');
    } else {
        $('.dp-alert-color').hide()
        $(".dp-alert-cont h5").hide();
    }

    $(".dp-alert-cont h1").text(data.title);
    $(".dp-alert-cont p").text(data.content);
    $(".dp-alert-cont h3").text('[ID: ' + data.id + ']');
    $(".page-cont").text(data.numcall + '/' + calls);
    $(".dp-alert-cont h4").show();
};

Ui.Dist = function (data) {
    $(".dp-alert-footer h4").text(data.text + ' ' + data.distance + ' ' + data.med);
};

Ui.aceptAlert = function () {
    $(".dp-core").addClass("borderanm");
    setTimeout(function () {
        $(".dp-core").removeClass("borderanm");
    }, 400);
}

var unitsOutput = '';
var userId = 0;
var noSet = false

Ui.OpenLargeDispatch = function (data) {
    if (data.bool) {
        userId = data.id
        Ui.UnitsMainOutput(data.units)
        $(".units-container").html(unitsOutput);
        $(".big-container").show()
        setTimeout(function () {
            $(".big-bg").css("left", "0rem");
            $(".unit-controller-cont").css("left", "2.5vh");
            $(".units-side-cont").css("left", "0vh");
        }, 50);
    } else {
        unitsOutput = '';
        userId = 0;
        noSet = false
        $(".unit-controller-cont").css("left", "-24vh");
        $(".units-side-cont").css("left", "-14rem");
        $(".big-bg").css("left", "-110rem");
        setTimeout(function () {
            $(".big-container").hide()
        }, 600);
    }
}

Ui.UnitsMainOutput = function (units) {
    units.forEach((element) => {
        var output = '';

        output += '<li>';
        output += '<div class="units" onclick="Ui.ClickUnit(this)">';

        output += '<div class="unit" data-fid="' + element.id + '">';

        output += '<div class="unit-status" id="' + element.status + '"></div>';
        output += '<div class="unit-data">';

        output += '<div class="unit-patrol-icon">';
        output += '<i class="fa-solid ' + element.patrol + '"></i>';
        output += '</div>';
        output += '<div class="unit-dispatch-name">';
        output += '<b id="unit-number">' + element.number + ' - </b>';
        output += '<b id="unit-name-c">' + element.name + '</b>';
        output += '</div>';
        output += '</div>';

        output += '</div>';

        output += '</div>';
        output += '</li>';

        if (element.id == userId) {
            if (!(noSet)) {
                $('.unit-controller-status').attr("id", element.status)
                $('#unit-controller-inp').val(element.number)
                $('[data-fid="' + userId + '"]').children(".unit-data").children('.unit-patrol-icon').children('i').attr("class", "fa-solid " + element.patrol);
                $("#" + element.patrol).addClass("selectedPatrol");
                noSet = true
            }
        }

        unitsOutput += output;
    });
}

Ui.ChangeUnitColor = function (color) {
    $('.unit-controller-status').attr("id", color);
    Ui.UpdateServerSideData('status', color)
}

Ui.ChangePatrol = function (icon) {
    $('.selectedPatrol').attr("class", 'icon-itm');
    $("#" + icon).addClass("selectedPatrol");
    Ui.UpdateServerSideData('patrol', icon)
}

Ui.ChangeNumber = function () {
    let numbValue = $('.unit-number-input').val().toUpperCase()
    if (numbValue.length === 0) {
        $('#unit-controller-inp').val('0A-00')
        Ui.UpdateServerSideData('number', '0A-00')
    } else {
        $('#unit-controller-inp').val(numbValue)
        Ui.UpdateServerSideData('number', numbValue)
    }
}

Ui.UpdateServerSideData = function (type, value) {
    let data = { type, value }
    $.post('https://op-dispatch/updateUserUnit', JSON.stringify(data));
}

Ui.UpdatePopData = function (data) {
    unitsOutput = '';
    Ui.UnitsMainOutput(data.units)
    $(".units-container").html(unitsOutput);
}

$(document).on('keydown', function () {
    switch (event.keyCode) {
        case 27:
            $.post(`https://op-dispatch/closeLarge`);
            break;
    }
});