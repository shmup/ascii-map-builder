$ ->
  document.color = "#000"
  ascii = new window.AsciiMap

class window.AsciiMap
  constructor: () ->
    @grid()
    @bindings()
    @click()
    @colorwheel()
  grid: (size=15) ->
    w = $(window)
    ratio_width = Math.floor w.width()/size
    ratio_height = Math.floor w.height()/size

    p = $("<div />",{
      class: "grid"
      width: ratio_width * size
      height: ratio_height * size
    }).addClass("grid").appendTo("body")

    counter=0
    rh=0
    while rh <= ratio_height
      rw=0
      while rw <= ratio_width
        counter++
        $("<div />", {
          width: size-1,
          height: size-1
        }).addClass("cell").data("index", counter).appendTo(p)
        rw++
      rh++
    return
  bindings: () ->
    $(document).keypress (e) ->
      $("#character").val String.fromCharCode(e.which)
  click: () ->
    # ignore dragging event
    $("body").on("dragstart", ".cell", (event) -> event.preventDefault())
    # bind to a single click
    $("body").on("click", ".cell", (thing) => @color $(thing.currentTarget))
    # bind to movement
    $(document).mousemove (e) =>
      x = e.clientX
      y = e.clientY
      elem = $(document.elementFromPoint(x, y))
      if e.which == 1 and elem.hasClass("cell")
        @color elem
  color: (cell, color="", character="") ->
    cell = $(cell)
    text = $("#character").val()
    text = "" if text == " "
    # cell.css("background", document.color)
    cell.text(text).css("color", document.color)
  colorwheel: () ->
    # https://www.gidforums.com/t-21296.html
    # https://gist.github.com/MicahElliott/719710
    basic = ["00", "CC", "33", "66", "99", "FF"]
    colors = []
    i = 0
    while i < 6
      j = 0
      while j < 6
        k = 0
        while k < 6
          colors.push basic[i]+basic[j]+basic[k]
          k++
        j++
      i++

    for color in colors
      thing = $("<button />", {
      }).css("background", "##{color}").appendTo("#colors")

    $("body").on("click", "#colors button", ->
      document.color = $(this).css("background-color")
    )
      


