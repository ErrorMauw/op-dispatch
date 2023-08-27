var mousePosition;
var offset = [0, 0];
var div;
var isDown = false;

div = document.getElementsByClassName("draggable");

for (const element of div) {
    element.addEventListener('mousedown', function (e) {
        isDown = true;
        $(".draggable").addClass("updrag");
        offset = [
            element.offsetLeft - e.clientX,
            element.offsetTop - e.clientY
        ];
    }, true);

    document.addEventListener('mouseup', function () {
        isDown = false;
        $(".draggable").removeClass("updrag");
    }, true);
    
    document.addEventListener('mousemove', function (event) {
        event.preventDefault();
        if (isDown) {
            mousePosition = {
                x: event.clientX,
                y: event.clientY
            };

            // Limit x-coordinate within window width
            var maxX = window.innerWidth - element.offsetWidth;
            var newX = Math.min(maxX, Math.max(0, mousePosition.x + offset[0]));

            // Limit y-coordinate within window height
            var maxY = window.innerHeight - element.offsetHeight;
            var newY = Math.min(maxY, Math.max(0, mousePosition.y + offset[1]));

            element.style.left = newX + 'px';
            element.style.top = newY + 'px';
        }
    }, true);
}
