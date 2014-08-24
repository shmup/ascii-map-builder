$ ->
  document.color = "#000"
  ascii = new window.AsciiMap

class window.AsciiMap
  width: 17
  height: 17
  brush_size: 1

  constructor: () ->
    @grid()
    @bindings()
    @colorwheel()
    document.color = "#fff"
  grid: (size=15) =>
    w = $(window)

    ratio_width = @width
    ratio_height = @height

    grid = $("<div />",{
      class: "grid"
      width: ratio_width * size
      height: ratio_height * size
    }).addClass("grid").appendTo("body")

    counter=0
    rh=0
    while rh < ratio_height
      rw=0
      while rw < ratio_width
        counter++
        $("<div />", {
          width: size-1,
          height: size-1
        }).addClass("cell").attr("id", counter).data("index", counter).appendTo(grid)
        rw++
      rh++
    return
  brush: (id) =>
    id = parseInt(id)
    cells = ""
    i=0
    id_row = Math.ceil(id/@height)
    while i < @brush_size
      cell = id+i
      break if Math.ceil((id+i)/@height) != id_row
      cells += "##{cell},"
      k = 1
      width = 0
      while k < @brush_size
        width += @width
        cells += "##{cell+width},"
        k++
      i++
    cells = cells.substr(0, cells.length-1)
    $(cells)
  bindings: () ->
    $(document).keydown (e) =>
      if e.shiftKey
        document.shifted = true
      if e.which == 9
        e.preventDefault()
        $("#shrink").click()
        $("#toggle_colors").click()
    $(document).keypress (e) =>
      @set_character (String.fromCharCode(e.which))

    $("#brush_up").click => @brush_up()
    $("#brush_down").click => @brush_down()
    $(".change_brush").click => $("#brush_size").text(@brush_size)
    $("#brush_size").click -> $(this).text("1")

    $(document).keyup (e) =>
      document.shifted = false

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
        $("#legend ul li").css("display", "inline")
        $("#legend").css("height", "0")
        shrink.text shrink.data("expand")
        $("#legend").css("padding", "0")
        # shrink.text shrink.data("expand")
        # shrink.addClass("left_color")
        # $(".can_shrink").hide()
        # console.log shrink.data("expanded")
      else
        shrink.data("expanded", true)
        $("#legend ul li").css("display", "block")
        $("#legend").css("height", "100%")
        shrink.text shrink.data("shrink")
        $("#legend").css("padding", "5px")
        # $(".can_shrink").show()
        # shrink.css("background-color", "")
        # shrink.removeClass("left_color")
        # console.log shrink.data("expanded")
  color: (cell, color="", character="") =>
    if document.shifted
      document.eye_picker = true

    if document.eye_picker
      document.eye_picker = false
      return @eye_picker cell

    cell = $(cell)

    if @brush_size
      cell = @brush cell.attr("id")

    text = $("#character").val()
    text = "" if text == " "
    # cell.css("background", document.color)
    cell.text(text).css("color", document.color)
  colorwheel: () ->
    colors = [[0, '000000'],[1, '800000'],[2, '008000'],[3, '808000'],[4, '000080'],[5, '800080'],[6, '008080'],[7, 'c0c0c0'],[8, '808080'],[9, 'ff0000'],[10, '00ff00'],[11, 'ffff00'],[12, '0000ff'],[13, 'ff00ff'],[14, '00ffff'],[15, 'ffffff'],[16, '000000'],[17, '00005f'],[18, '000087'],[19, '0000af'],[20, '0000d7'],[21, '0000ff'],[22, '005f00'],[23, '005f5f'],[24, '005f87'],[25, '005faf'],[26, '005fd7'],[27, '005fff'],[28, '008700'],[29, '00875f'],[30, '008787'],[31, '0087af'],[32, '0087d7'],[33, '0087ff'],[34, '00af00'],[35, '00af5f'],[36, '00af87'],[37, '00afaf'],[38, '00afd7'],[39, '00afff'],[40, '00d700'],[41, '00d75f'],[42, '00d787'],[43, '00d7af'],[44, '00d7d7'],[45, '00d7ff'],[46, '00ff00'],[47, '00ff5f'],[48, '00ff87'],[49, '00ffaf'],[50, '00ffd7'],[51, '00ffff'],[52, '5f0000'],[53, '5f005f'],[54, '5f0087'],[55, '5f00af'],[56, '5f00d7'],[57, '5f00ff'],[58, '5f5f00'],[59, '5f5f5f'],[60, '5f5f87'],[61, '5f5faf'],[62, '5f5fd7'],[63, '5f5fff'],[64, '5f8700'],[65, '5f875f'],[66, '5f8787'],[67, '5f87af'],[68, '5f87d7'],[69, '5f87ff'],[70, '5faf00'],[71, '5faf5f'],[72, '5faf87'],[73, '5fafaf'],[74, '5fafd7'],[75, '5fafff'],[76, '5fd700'],[77, '5fd75f'],[78, '5fd787'],[79, '5fd7af'],[80, '5fd7d7'],[81, '5fd7ff'],[82, '5fff00'],[83, '5fff5f'],[84, '5fff87'],[85, '5fffaf'],[86, '5fffd7'],[87, '5fffff'],[88, '870000'],[89, '87005f'],[90, '870087'],[91, '8700af'],[92, '8700d7'],[93, '8700ff'],[94, '875f00'],[95, '875f5f'],[96, '875f87'],[97, '875faf'],[98, '875fd7'],[99, '875fff'],[100, '878700'],[101, '87875f'],[102, '878787'],[103, '8787af'],[104, '8787d7'],[105, '8787ff'],[106, '87af00'],[107, '87af5f'],[108, '87af87'],[109, '87afaf'],[110, '87afd7'],[111, '87afff'],[112, '87d700'],[113, '87d75f'],[114, '87d787'],[115, '87d7af'],[116, '87d7d7'],[117, '87d7ff'],[118, '87ff00'],[119, '87ff5f'],[120, '87ff87'],[121, '87ffaf'],[122, '87ffd7'],[123, '87ffff'],[124, 'af0000'],[125, 'af005f'],[126, 'af0087'],[127, 'af00af'],[128, 'af00d7'],[129, 'af00ff'],[130, 'af5f00'],[131, 'af5f5f'],[132, 'af5f87'],[133, 'af5faf'],[134, 'af5fd7'],[135, 'af5fff'],[136, 'af8700'],[137, 'af875f'],[138, 'af8787'],[139, 'af87af'],[140, 'af87d7'],[141, 'af87ff'],[142, 'afaf00'],[143, 'afaf5f'],[144, 'afaf87'],[145, 'afafaf'],[146, 'afafd7'],[147, 'afafff'],[148, 'afd700'],[149, 'afd75f'],[150, 'afd787'],[151, 'afd7af'],[152, 'afd7d7'],[153, 'afd7ff'],[154, 'afff00'],[155, 'afff5f'],[156, 'afff87'],[157, 'afffaf'],[158, 'afffd7'],[159, 'afffff'],[160, 'd70000'],[161, 'd7005f'],[162, 'd70087'],[163, 'd700af'],[164, 'd700d7'],[165, 'd700ff'],[166, 'd75f00'],[167, 'd75f5f'],[168, 'd75f87'],[169, 'd75faf'],[170, 'd75fd7'],[171, 'd75fff'],[172, 'd78700'],[173, 'd7875f'],[174, 'd78787'],[175, 'd787af'],[176, 'd787d7'],[177, 'd787ff'],[178, 'd7af00'],[179, 'd7af5f'],[180, 'd7af87'],[181, 'd7afaf'],[182, 'd7afd7'],[183, 'd7afff'],[184, 'd7d700'],[185, 'd7d75f'],[186, 'd7d787'],[187, 'd7d7af'],[188, 'd7d7d7'],[189, 'd7d7ff'],[190, 'd7ff00'],[191, 'd7ff5f'],[192, 'd7ff87'],[193, 'd7ffaf'],[194, 'd7ffd7'],[195, 'd7ffff'],[196, 'ff0000'],[197, 'ff005f'],[198, 'ff0087'],[199, 'ff00af'],[200, 'ff00d7'],[201, 'ff00ff'],[202, 'ff5f00'],[203, 'ff5f5f'],[204, 'ff5f87'],[205, 'ff5faf'],[206, 'ff5fd7'],[207, 'ff5fff'],[208, 'ff8700'],[209, 'ff875f'],[210, 'ff8787'],[211, 'ff87af'],[212, 'ff87d7'],[213, 'ff87ff'],[214, 'ffaf00'],[215, 'ffaf5f'],[216, 'ffaf87'],[217, 'ffafaf'],[218, 'ffafd7'],[219, 'ffafff'],[220, 'ffd700'],[221, 'ffd75f'],[222, 'ffd787'],[223, 'ffd7af'],[224, 'ffd7d7'],[225, 'ffd7ff'],[226, 'ffff00'],[227, 'ffff5f'],[228, 'ffff87'],[229, 'ffffaf'],[230, 'ffffd7'],[231, 'ffffff'],[232, '080808'],[233, '121212'],[234, '1c1c1c'],[235, '262626'],[236, '303030'],[237, '3a3a3a'],[238, '444444'],[239, '4e4e4e'],[240, '585858'],[241, '626262'],[242, '6c6c6c'],[243, '767676'],[244, '808080'],[245, '8a8a8a'],[246, '949494'],[247, '9e9e9e'],[248, 'a8a8a8'],[249, 'b2b2b2'],[250, 'bcbcbc'],[251, 'c6c6c6'],[252, 'd0d0d0'],[253, 'dadada'],[254, 'e4e4e4'],[255, 'eeeeee']]
    for color in colors
      thing = $("<button />", {
      }).css("background", "##{color[1]}").appendTo("#colors")
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
  brush_up: () -> @brush_size += 1
  brush_down: () -> if (@brush_size-1) then @brush_size -= 1
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
