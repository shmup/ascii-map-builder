// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  $(function() {
    var ascii;
    document.color = "#000";
    return ascii = new window.AsciiMap;
  });

  window.AsciiMap = (function() {
    AsciiMap.prototype.width = 100;

    AsciiMap.prototype.height = 50;

    AsciiMap.prototype.brush_size = 1;

    function AsciiMap() {
      this.eye_picker = __bind(this.eye_picker, this);
      this.color = __bind(this.color, this);
      this.brush = __bind(this.brush, this);
      this.grid = __bind(this.grid, this);
      this.grid();
      this.bindings();
      this.colorwheel();
      document.color = "#fff";
    }

    AsciiMap.prototype.grid = function(size) {
      var counter, grid, ratio_height, ratio_width, rh, rw, w;
      if (size == null) {
        size = 15;
      }
      w = $(window);
      ratio_width = this.width;
      ratio_height = this.height;
      grid = $("<div />", {
        "class": "grid",
        width: ratio_width * size,
        height: ratio_height * size
      }).addClass("grid").appendTo("body");
      counter = 0;
      rh = 0;
      while (rh < ratio_height) {
        rw = 0;
        while (rw < ratio_width) {
          counter++;
          $("<div />", {
            width: size - 1,
            height: size - 1
          }).addClass("cell").attr("id", counter).data("index", counter).appendTo(grid);
          rw++;
        }
        rh++;
      }
    };

    AsciiMap.prototype.brush = function(id) {
      var cell, cells, i, id_row, k, width;
      id = parseInt(id);
      cells = "";
      i = 0;
      id_row = Math.ceil(id / this.height);
      while (i < this.brush_size) {
        cell = id + i;
        if (Math.ceil((id + i) / this.height) !== id_row) {
          break;
        }
        cells += "#" + cell + ",";
        k = 1;
        width = 0;
        while (k < this.brush_size) {
          width += this.width;
          cells += "#" + (cell + width) + ",";
          k++;
        }
        i++;
      }
      cells = cells.substr(0, cells.length - 1);
      return $(cells);
    };

    AsciiMap.prototype.bindings = function() {
      $(document).keydown((function(_this) {
        return function(e) {
          if (e.shiftKey) {
            document.shifted = true;
          }
          if (e.which === 9) {
            e.preventDefault();
            $("#shrink").click();
            return $("#toggle_colors").click();
          }
        };
      })(this));
      $(document).keypress((function(_this) {
        return function(e) {
          return _this.set_character(String.fromCharCode(e.which));
        };
      })(this));
      $("#brush_up").click((function(_this) {
        return function() {
          return _this.brush_up();
        };
      })(this));
      $("#brush_down").click((function(_this) {
        return function() {
          return _this.brush_down();
        };
      })(this));
      $(".change_brush").click((function(_this) {
        return function() {
          return $("#brush_size").text(_this.brush_size);
        };
      })(this));
      $("#brush_size").click(function() {
        return $(this).text("1");
      });
      $(document).keyup((function(_this) {
        return function(e) {
          return document.shifted = false;
        };
      })(this));
      $("body").on("dragstart", ".cell", function(event) {
        return event.preventDefault();
      });
      $("#clear").click(function() {
        return $(".cell").html("");
      });
      $("#save").click((function(_this) {
        return function() {
          return _this.save();
        };
      })(this));
      $("#load").click((function(_this) {
        return function() {
          return _this.load();
        };
      })(this));
      $("body").on("click", ".cell", (function(_this) {
        return function(thing) {
          return _this.color($(thing.currentTarget));
        };
      })(this));
      $(document).mousemove((function(_this) {
        return function(e) {
          var elem, x, y;
          x = e.clientX;
          y = e.clientY;
          elem = $(document.elementFromPoint(x, y));
          if (e.which === 1 && elem.hasClass("cell")) {
            return _this.color(elem);
          }
        };
      })(this));
      $("#eye").click(function() {
        return document.eye_picker = true;
      });
      $("body").on("click", "#colors button", function() {
        document.color = $(this).css("background-color");
        return $(".left_color").css("background-color", document.color);
      });
      $("#toggle_colors").click(function() {
        return $("#colors").toggle();
      });
      return $("#shrink").click(function() {
        var shrink;
        shrink = $(this);
        if (shrink.data("expanded")) {
          shrink.data("expanded", false);
          $("#legend ul li").css("display", "inline");
          $("#legend").css("height", "0");
          shrink.text(shrink.data("expand"));
          return $("#legend").css("padding", "0");
        } else {
          shrink.data("expanded", true);
          $("#legend ul li").css("display", "block");
          $("#legend").css("height", "100%");
          shrink.text(shrink.data("shrink"));
          return $("#legend").css("padding", "5px");
        }
      });
    };

    AsciiMap.prototype.color = function(cell, color, character) {
      var text;
      if (color == null) {
        color = "";
      }
      if (character == null) {
        character = "";
      }
      if (document.shifted) {
        document.eye_picker = true;
      }
      if (document.eye_picker) {
        document.eye_picker = false;
        return this.eye_picker(cell);
      }
      cell = $(cell);
      if (this.brush_size) {
        cell = this.brush(cell.attr("id"));
      }
      text = $("#character").val();
      if (text === " ") {
        text = "";
      }
      return cell.text(text).css("color", document.color);
    };

    AsciiMap.prototype.colorwheel = function() {
      var color, colors, thing, _i, _len, _results;
      colors = [[0, '000000'], [1, '800000'], [2, '008000'], [3, '808000'], [4, '000080'], [5, '800080'], [6, '008080'], [7, 'c0c0c0'], [8, '808080'], [9, 'ff0000'], [10, '00ff00'], [11, 'ffff00'], [12, '0000ff'], [13, 'ff00ff'], [14, '00ffff'], [15, 'ffffff'], [16, '000000'], [17, '00005f'], [18, '000087'], [19, '0000af'], [20, '0000d7'], [21, '0000ff'], [22, '005f00'], [23, '005f5f'], [24, '005f87'], [25, '005faf'], [26, '005fd7'], [27, '005fff'], [28, '008700'], [29, '00875f'], [30, '008787'], [31, '0087af'], [32, '0087d7'], [33, '0087ff'], [34, '00af00'], [35, '00af5f'], [36, '00af87'], [37, '00afaf'], [38, '00afd7'], [39, '00afff'], [40, '00d700'], [41, '00d75f'], [42, '00d787'], [43, '00d7af'], [44, '00d7d7'], [45, '00d7ff'], [46, '00ff00'], [47, '00ff5f'], [48, '00ff87'], [49, '00ffaf'], [50, '00ffd7'], [51, '00ffff'], [52, '5f0000'], [53, '5f005f'], [54, '5f0087'], [55, '5f00af'], [56, '5f00d7'], [57, '5f00ff'], [58, '5f5f00'], [59, '5f5f5f'], [60, '5f5f87'], [61, '5f5faf'], [62, '5f5fd7'], [63, '5f5fff'], [64, '5f8700'], [65, '5f875f'], [66, '5f8787'], [67, '5f87af'], [68, '5f87d7'], [69, '5f87ff'], [70, '5faf00'], [71, '5faf5f'], [72, '5faf87'], [73, '5fafaf'], [74, '5fafd7'], [75, '5fafff'], [76, '5fd700'], [77, '5fd75f'], [78, '5fd787'], [79, '5fd7af'], [80, '5fd7d7'], [81, '5fd7ff'], [82, '5fff00'], [83, '5fff5f'], [84, '5fff87'], [85, '5fffaf'], [86, '5fffd7'], [87, '5fffff'], [88, '870000'], [89, '87005f'], [90, '870087'], [91, '8700af'], [92, '8700d7'], [93, '8700ff'], [94, '875f00'], [95, '875f5f'], [96, '875f87'], [97, '875faf'], [98, '875fd7'], [99, '875fff'], [100, '878700'], [101, '87875f'], [102, '878787'], [103, '8787af'], [104, '8787d7'], [105, '8787ff'], [106, '87af00'], [107, '87af5f'], [108, '87af87'], [109, '87afaf'], [110, '87afd7'], [111, '87afff'], [112, '87d700'], [113, '87d75f'], [114, '87d787'], [115, '87d7af'], [116, '87d7d7'], [117, '87d7ff'], [118, '87ff00'], [119, '87ff5f'], [120, '87ff87'], [121, '87ffaf'], [122, '87ffd7'], [123, '87ffff'], [124, 'af0000'], [125, 'af005f'], [126, 'af0087'], [127, 'af00af'], [128, 'af00d7'], [129, 'af00ff'], [130, 'af5f00'], [131, 'af5f5f'], [132, 'af5f87'], [133, 'af5faf'], [134, 'af5fd7'], [135, 'af5fff'], [136, 'af8700'], [137, 'af875f'], [138, 'af8787'], [139, 'af87af'], [140, 'af87d7'], [141, 'af87ff'], [142, 'afaf00'], [143, 'afaf5f'], [144, 'afaf87'], [145, 'afafaf'], [146, 'afafd7'], [147, 'afafff'], [148, 'afd700'], [149, 'afd75f'], [150, 'afd787'], [151, 'afd7af'], [152, 'afd7d7'], [153, 'afd7ff'], [154, 'afff00'], [155, 'afff5f'], [156, 'afff87'], [157, 'afffaf'], [158, 'afffd7'], [159, 'afffff'], [160, 'd70000'], [161, 'd7005f'], [162, 'd70087'], [163, 'd700af'], [164, 'd700d7'], [165, 'd700ff'], [166, 'd75f00'], [167, 'd75f5f'], [168, 'd75f87'], [169, 'd75faf'], [170, 'd75fd7'], [171, 'd75fff'], [172, 'd78700'], [173, 'd7875f'], [174, 'd78787'], [175, 'd787af'], [176, 'd787d7'], [177, 'd787ff'], [178, 'd7af00'], [179, 'd7af5f'], [180, 'd7af87'], [181, 'd7afaf'], [182, 'd7afd7'], [183, 'd7afff'], [184, 'd7d700'], [185, 'd7d75f'], [186, 'd7d787'], [187, 'd7d7af'], [188, 'd7d7d7'], [189, 'd7d7ff'], [190, 'd7ff00'], [191, 'd7ff5f'], [192, 'd7ff87'], [193, 'd7ffaf'], [194, 'd7ffd7'], [195, 'd7ffff'], [196, 'ff0000'], [197, 'ff005f'], [198, 'ff0087'], [199, 'ff00af'], [200, 'ff00d7'], [201, 'ff00ff'], [202, 'ff5f00'], [203, 'ff5f5f'], [204, 'ff5f87'], [205, 'ff5faf'], [206, 'ff5fd7'], [207, 'ff5fff'], [208, 'ff8700'], [209, 'ff875f'], [210, 'ff8787'], [211, 'ff87af'], [212, 'ff87d7'], [213, 'ff87ff'], [214, 'ffaf00'], [215, 'ffaf5f'], [216, 'ffaf87'], [217, 'ffafaf'], [218, 'ffafd7'], [219, 'ffafff'], [220, 'ffd700'], [221, 'ffd75f'], [222, 'ffd787'], [223, 'ffd7af'], [224, 'ffd7d7'], [225, 'ffd7ff'], [226, 'ffff00'], [227, 'ffff5f'], [228, 'ffff87'], [229, 'ffffaf'], [230, 'ffffd7'], [231, 'ffffff'], [232, '080808'], [233, '121212'], [234, '1c1c1c'], [235, '262626'], [236, '303030'], [237, '3a3a3a'], [238, '444444'], [239, '4e4e4e'], [240, '585858'], [241, '626262'], [242, '6c6c6c'], [243, '767676'], [244, '808080'], [245, '8a8a8a'], [246, '949494'], [247, '9e9e9e'], [248, 'a8a8a8'], [249, 'b2b2b2'], [250, 'bcbcbc'], [251, 'c6c6c6'], [252, 'd0d0d0'], [253, 'dadada'], [254, 'e4e4e4'], [255, 'eeeeee']];
      _results = [];
      for (_i = 0, _len = colors.length; _i < _len; _i++) {
        color = colors[_i];
        _results.push(thing = $("<button />", {}).css("background", "#" + color[1]).appendTo("#colors"));
      }
      return _results;
    };

    AsciiMap.prototype.save = function() {
      var map, map_data;
      map_data = [];
      $(".cell").each(function() {
        var cell, text;
        cell = $(this);
        text = cell.text();
        if (text !== "") {
          return map_data.push([cell.data("index"), window.Helper.rgb2hex(cell.css("color")), text]);
        }
      });
      return map = localStorage.setItem("map", JSON.stringify(map_data));
    };

    AsciiMap.prototype.load = function() {
      var alerted, cell, grid_cell, grid_cells, map, _i, _len, _results;
      map = JSON.parse(localStorage.getItem("map"));
      grid_cells = $(".cell");
      alerted = false;
      _results = [];
      for (_i = 0, _len = map.length; _i < _len; _i++) {
        cell = map[_i];
        grid_cell = grid_cells.filter(function() {
          return $(this).data("index") === cell[0];
        });
        if (grid_cell.length === 0 && !alerted) {
          alerted = true;
          alert("It looks like the grid is smaller than the saved map! We'll load it anyway, but you can't see it all");
        }
        grid_cell.css("color", cell[1]);
        _results.push(grid_cell.text(cell[2]));
      }
      return _results;
    };

    AsciiMap.prototype.brush_up = function() {
      return this.brush_size += 1;
    };

    AsciiMap.prototype.brush_down = function() {
      if (this.brush_size - 1) {
        return this.brush_size -= 1;
      }
    };

    AsciiMap.prototype.set_color = function(color) {
      document.color = color;
      return $(".left_color").css("background-color", color);
    };

    AsciiMap.prototype.set_character = function(c) {
      return $("#character").val(c);
    };

    AsciiMap.prototype.eye_picker = function(cell) {
      var character, color;
      cell = $(cell);
      color = cell.css("color");
      character = cell.text();
      this.set_color(color);
      return this.set_character(character);
    };

    return AsciiMap;

  })();

  window.Helper = (function() {
    function Helper() {}

    Helper.rgb2hex = function(rgb) {
      var hex;
      rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
      hex = function(x) {
        return ("0" + parseInt(x).toString(16)).slice(-2);
      };
      return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
    };

    return Helper;

  })();

}).call(this);
