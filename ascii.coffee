$ ->
  document.color = "#000"
  ascii = new window.AsciiMap

class window.AsciiMap
  constructor: () ->
    @grid()
    @bindings()
    @colorwheel()
  grid: (size=15) ->
    w = $(window)
    # ratio_width = Math.floor w.width()/size
    # ratio_height = Math.floor w.height()/size

    ratio_width = 10
    ratio_height = 10

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
    $(document).keypress (e) =>
      @set_character (String.fromCharCode(e.which))

    $("body").on("dragstart", ".cell", (event) -> event.preventDefault())

    $("#clear").click -> $(".cell").html("")

    $("#save").click => @save()
    $("#load").click => @load()

    $("body").on("click", ".cell", (thing) => @color $(thing.currentTarget))

    $(document).mousemove (e) =>
      x = e.clientX
      y = e.clientY
      elem = $(document.elementFromPoint(x, y))
      if e.which == 1 and elem.hasClass("cell")
        @color elem

    $("#eye").click ->
      document.eye_picker = true

    $("body").on("click", "#colors button", ->
      document.color = $(this).css("background-color")
      $(".left_color").css("background-color", document.color)
    )

    $("#toggle_colors").click -> $("#colors").toggle()

    $("#shrink").click ->
      shrink = $(this)
      if shrink.data("expanded")
        shrink.data("expanded", false)
        $("#legend").css("height", "0")
        $("#legend").css("padding", "0")
        shrink.text shrink.data("expand")
        shrink.addClass("left_color")
        $(".can_shrink").hide()
        console.log shrink.data("expanded")
      else
        shrink.data("expanded", true)
        $("#legend").css("height", "100%")
        $("#legend").css("padding", "5px")
        $(".can_shrink").show()
        shrink.css("background-color", "")
        shrink.removeClass("left_color")
        shrink.text shrink.data("shrink")
        console.log shrink.data("expanded")
  color: (cell, color="", character="") =>
    if document.eye_picker
      document.eye_picker = false
      return @eye_picker cell
    cell = $(cell)
    text = $("#character").val()
    text = "" if text == " "
    # cell.css("background", document.color)
    cell.text(text).css("color", document.color)
  colorwheel: () ->
    basic = ["00", "CC", "33", "66", "99", "FF"]
    colors = []
    # https://www.gidforums.com/t-21296.html
    # https://gist.github.com/MicahElliott/719710
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
  save: () ->
    map_data = []
    $(".cell").each ->
      cell = $(this)
      text = cell.text()
      if text != ""
        map_data.push [cell.data("index"), window.Helper.rgb2hex(cell.css("color")), text]
    map = localStorage.setItem("map", JSON.stringify(map_data))
  load: () ->
    map = JSON.parse(localStorage.getItem("map"))
    grid_cells = $(".cell")
    alerted = false
    for cell in map
      grid_cell = grid_cells.filter -> $(this).data("index") == cell[0]
      if grid_cell.length == 0 and not alerted
        alerted = true
        alert "It looks like the grid is smaller than the saved map! We'll load it anyway, but you can't see it all"
  
      grid_cell.css("color", cell[1])
      grid_cell.text cell[2]
  set_color: (color) ->
    document.color = color
    $(".left_color").css("background-color", color)
  set_character: (c) ->
    $("#character").val c
  eye_picker: (cell) =>
    cell = $(cell)
    color = cell.css("color")
    character = cell.text()
    @set_color color
    @set_character character

class window.Helper
  constructor: () ->
  @rgb2hex: (rgb) ->
    rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
    hex = (x) -> ("0" + parseInt(x).toString(16)).slice(-2)
    "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3])
