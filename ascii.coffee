$ ->
  document.color = "#000"
  ascii = new window.AsciiMap

class window.AsciiMap
  constructor: () ->
    @grid()
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
  click: () ->
    $("body").on("dragstart", ".cell", (event) -> event.preventDefault())
    $("body").on("click", ".cell", (thing) => @color $(thing.currentTarget))
    $(document).mousemove (e) =>
      x = e.clientX
      y = e.clientY
      elem = $(document.elementFromPoint(x, y))
      if e.which == 1 and elem.hasClass("cell")
        @color elem
  color: (cell, color="", character="") ->
    cell = $(cell)
    cell.css("background", document.color)
  colorwheel: () ->
    # https://www.gidforums.com/t-21296.html
    # https://gist.github.com/MicahElliott/719710
    basic = ["00", "CC", "33", "66", "99", "FF"]
    colors = []
    i = 0
    while i < 6
      console.log "i is #{i}"
      j = 0
      while j < 6
        console.log "j is #{j}"
        k = 0
        while k < 6
          console.log "k is #{k}"
          colors.push basic[i]+basic[j]+basic[k]
          k++
        j++
      i++

    console.log colors.length

    for color in colors
      thing = $("<button />", {
      }).css("background", "##{color}").appendTo("#colors")

    $("body").on("click", "#colors button", ->
      document.color = $(this).css("background-color")
    )
      


