package graphs_viewer

import c "core:c"
import fmt "core:fmt"
import la "core:math/linalg"
import n "core:math/linalg/hlsl"
import rand "core:math/rand"
import mem "core:mem"
import os "core:os"
import "core:runtime"
import "core:slice"
import "core:sort"
import "core:strings"
import "core:unicode"
import "core:unicode/utf8"
import rl "vendor:raylib"

BUFFER_SIZE_OF_EACH_PATH :: 1024

SHOW_LEAK :: true
TEST_MODE :: false
INTERFACE_RAYLIB :: true
DEBUG_PATH :: false
DEBUG_INTERFACE_WORD :: false

DEBUG_FILTERING_SEARCH :: false // this is for main debug

DEBUG_READ_ERRORN :: false
COUNT_TOTAL_PROGRAMS_PATH :: false
TEST_STATEMENT :: false

main_source :: proc() {


  windown_dim :: n.int2{400, 100}

  when INTERFACE_RAYLIB {

    rl.InitWindow(windown_dim.x, windown_dim.y, "Spawn Rune")
    rl.SetTargetFPS(60)
  }

  keyfor: rl.KeyboardKey
  keyfor = rl.GetKeyPressed()

  // fmt.println ("Hello World")


  when INTERFACE_RAYLIB {

    is_running :: true

    // fmt.println(keyfor)

    rl.BeginDrawing()

    pause: bool = false

    when TEST_MODE {
      fmt.println("counter :: ", counter)
    }

    runner_simbol: string = ""

    word: string = ""

    // temp_word: cstring
    rune_one_caracter: rune
    runes_swaps: []rune
    swap_str_arr: []string
    str_temp: string

    filter_now: []string
    raw_arr_filter: string

    for is_running && rl.WindowShouldClose() == false {

      // rl.DrawText("Hello World!", 10, 10, 20, rl.DARKGRAY)
      /*scores: cstring = strings.clone_to_cstring(
            fmt.tprintf("hello world",  context.temp_allocator,
        )*/

      // rl.DrawText(string(windown_dim.x), 0, 0, 20, rl.DARKGRAY)
      // rl.DrawText(string(windown_dim.y), 0, 10, 20, rl.DARKGRAY)

      /// handle game play velocity
      keyfor = rl.GetKeyPressed()
      if keyfor == rl.KeyboardKey.ENTER {

      } else if (keyfor >= rl.KeyboardKey.A) && (keyfor <= rl.KeyboardKey.Z) {

      } else if keyfor == rl.KeyboardKey.BACKSPACE {

      } else if keyfor == rl.KeyboardKey.SPACE {

      } else if keyfor == rl.KeyboardKey.PERIOD {

      } else if (keyfor == rl.KeyboardKey.MINUS) ||
         (keyfor == rl.KeyboardKey.KP_SUBTRACT) {

      } else if keyfor == rl.KeyboardKey.TAB {

        /// TODOOOOOOO : add rotate on list of results for search of now
      }

      raw_arr_filter = strings.join(filter_now, " ", context.temp_allocator)

      rl.ClearBackground(rl.WHITE)

      rl.DrawText("Graphs Viewer", 100, 100, 20, rl.DARKGRAY)

      rl.DrawText(
        "Hello World!",
        (windown_dim.x / 2) - 30,
        (windown_dim.y / 2) + 10,
        20,
        rl.LIGHTGRAY,
      )


      rl.DrawText(
        strings.unsafe_string_to_cstring(word),
        (windown_dim.x / 2) - 40,
        (windown_dim.y / 2) - 20,
        20,
        rl.DARKGRAY,
      )

      rl.DrawText(
        strings.unsafe_string_to_cstring(raw_arr_filter),
        (windown_dim.x / 2) - 190,
        (windown_dim.y / 2) + 30,
        20,
        rl.BLACK,
      )

      rl.EndDrawing()
    }
  }
}

when !TEST_MODE {
  main_test_fail :: proc() {

    counter := 0

    name_binary, now_string: string = "", ""

    fd, err := os.open("/bin", os.O_RDONLY, 0)
    files_info, ok := os.read_dir(fd, BUFFER_SIZE_OF_EACH_PATH)
    if ok == 0 {
      when DEBUG_READ_ERRORN {
        fmt.println("ERROR READ ::: |", now_string, "|")
      }
    }

    if len(files_info) != 0 {

      for binary in files_info {

        // fmt.print (now_string," - ")
        name_binary = strings.cut(
          binary.fullpath,
          strings.last_index(binary.fullpath, "/"),
          0,
          context.temp_allocator,
        )

        counter += 1

        when DEBUG_PATH {
          name_binary = strings.trim_left(name_binary, "/")
          fmt.print(name_binary)
          fmt.print(" - ")
          fmt.println(binary.fullpath)
        }

      }
    }

    fmt.println(counter)

  }
}

main_scheduler :: proc() {

  // put LUA stuff here

  // main_proc() // still not working propely

  main_source()
}

main :: proc() {

  when SHOW_LEAK {
    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
  }

  when !TEST_MODE {
    main_scheduler()
  } else {
    testing()
  }

  when SHOW_LEAK {
    for _, leak in track.allocation_map {
      fmt.printf("%v leaked %v bytes\n", leak.location, leak.size)
    }
    for bad_free in track.bad_free_array {
      fmt.printf(
        "%v allocation %p was freed badly\n",
        bad_free.location,
        bad_free.memory,
      )
    }
  }
  return
}
