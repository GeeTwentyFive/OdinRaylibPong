package main


import rl "vendor:raylib"




WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600

PADDLE_SPEED :: 0.5
BALL_SPEED :: 0.5

PADDLE_HEIGHT :: 50


Paddle :: struct {
    y: f64,
    x: f64,
}


Ball :: struct {
    x: f64,
    y: f64,
}


paddle_l := Paddle{
    x = 10,
    y = WINDOW_HEIGHT/2 - PADDLE_HEIGHT/2,
}
paddle_r := Paddle{
    x = WINDOW_WIDTH - 10,
    y = WINDOW_HEIGHT/2 - PADDLE_HEIGHT/2,
}


BALL_START_X :: WINDOW_WIDTH/2
BALL_START_Y :: WINDOW_HEIGHT/2

ball := Ball{
    BALL_START_X,
    BALL_START_Y,
}




main :: proc() {

    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Raylib Pong - By Gee")
    defer rl.CloseWindow()

    rl.SetTargetFPS(1000)

    rl.ToggleFullscreen()

    rl.HideCursor()
    rl.DisableCursor()


    ball_x_vel : f64 = BALL_SPEED
    ball_y_vel : f64 = BALL_SPEED


    for !rl.WindowShouldClose() {

        // Input handling
        switch {
            case rl.IsKeyDown(rl.KeyboardKey.W):
                if paddle_l.y > 1 { paddle_l.y -= PADDLE_SPEED }
            
            case rl.IsKeyDown(rl.KeyboardKey.S):
                if paddle_l.y+PADDLE_HEIGHT < WINDOW_HEIGHT-1 { paddle_l.y += PADDLE_SPEED }
            
    
            case rl.IsKeyDown(rl.KeyboardKey.UP):
                if paddle_r.y > 1 { paddle_r.y -= PADDLE_SPEED }
            
            case rl.IsKeyDown(rl.KeyboardKey.DOWN):
                if paddle_r.y+PADDLE_HEIGHT < WINDOW_HEIGHT-1 { paddle_r.y += PADDLE_SPEED }
        }


        // Physics
        if ball.y <= 1 || ball.y >= WINDOW_HEIGHT-1 {
            ball_y_vel = -ball_y_vel
        }
        if ball.x <= 1 || ball.x >= WINDOW_WIDTH-1 {
            ball.x = BALL_START_X
            ball.y = BALL_START_Y
        }

        if i32(ball.x) == i32(paddle_l.x)+1 && i32(ball.y) > i32(paddle_l.y) && i32(ball.y) < i32(paddle_l.y)+PADDLE_HEIGHT {
            ball_x_vel = -ball_x_vel
        } else if i32(ball.x) == i32(paddle_r.x)-1 && i32(ball.y) > i32(paddle_r.y) && i32(ball.y) < i32(paddle_r.y)+PADDLE_HEIGHT {
            ball_x_vel = -ball_x_vel
        }

        ball.x += ball_x_vel
        ball.y += ball_y_vel


        // Drawing
        rl.BeginDrawing()
        defer rl.EndDrawing()

        rl.ClearBackground(rl.GRAY)
        
        rl.DrawRectangle(1, 1, WINDOW_WIDTH-1*2, WINDOW_HEIGHT-1*2, rl.BLACK)
        rl.DrawRectangle(0, 1, 1, WINDOW_HEIGHT-1*2, rl.BLUE)
        rl.DrawRectangle(WINDOW_WIDTH-1, 1, 1, WINDOW_HEIGHT-1*2, rl.RED)

        rl.DrawRectangle(i32(paddle_l.x), i32(paddle_l.y), 1, PADDLE_HEIGHT, rl.BLUE)
        rl.DrawRectangle(i32(paddle_r.x), i32(paddle_r.y), 1, PADDLE_HEIGHT, rl.RED)

        rl.DrawPixel(i32(ball.x), i32(ball.y), rl.WHITE)

    }
}
