let lastCardialChangeded
function changeCardialDirection(direction,) {    
    $(`#${direction.toLowerCase()}`).css('color', "#0795cb");

    if (lastCardialChangeded != `#${direction.toLowerCase()}`) {
        $(lastCardialChangeded).css('color', "#fff");
        lastCardialChangeded = `#${direction.toLowerCase()}`
    }
}

function changeCardialHeading(heading) {
    $("#player-heading").html(heading.toFixed(5))
}

addEventListener("message", function (event) {
    const data = event.data

    if (data.action == "showCardial") {
        $("body").css("display", "block")
    } else if (data.action == "hideCardial") {
        $("body").css("display", "none")
    } else if (data.action == "changeCardialDirection") {
        changeCardialDirection(data.direction)
    } else if (data.action == "changeCardialHeading") {
        changeCardialHeading(data.heading)
    }
})