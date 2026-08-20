# Hot Banana 🍌

A Flappy Bird–style arcade game built in **Godot 4.2**. Guide a nervous banana
through an endless gauntlet of pipes — one tap keeps it aloft, gravity does the
rest.

## Play

- **Flap:** `Space`, `Up`, or left mouse button
- **Pause:** `Esc` — resume (with a 3-2-1 countdown), restart, or quit to the menu
- Clear each pipe pair to score. Hit a pipe or the ground and it's over.
- **Watch the heat.** Every flap heats the banana up; gliding cools it down.
  Let it **overheat** and it bursts — so you can't just spam-flap to stay safe.
  The banana reddens and the HEAT bar fills as it climbs.
- Your best score is saved between runs.

## Running the project

1. Install [Godot 4.2](https://godotengine.org/download).
2. Open `project.godot` in the Godot editor.
3. Press **F5** (Play) or the ▶ button.

## How it fits together

| File | Role |
| --- | --- |
| `main.gd` / `main.tscn` | Top-level flow: start screen, countdown, scoring, death/retry. |
| `player.gd` / `player.tscn` | The banana — movement, flapping, and death on collision. |
| `spawner.gd` | Procedural, endless pipe spawning ahead of the player. |
| `game_camera.gd` | Follows the player horizontally. |
| `obstacle.tscn` / `duo_obstacle.tscn` | A single pipe / a top-and-bottom pipe pair. |
| `floor.tscn` | The ground (an infinite world boundary). |
| `start_screen.tscn` / `death_screen.tscn` | Menu and game-over overlays. |

### Tuning difficulty

Most feel-related knobs live at the top of `spawner.gd` (pipe spacing, gap
height range, spawn/despawn distances) and `player.gd` (`RUN_SPEED`, `ACCEL`,
`JUMP_VELOCITY`, and the heat tuning `heat_per_flap` / `cool_rate`). They're
exported where useful, so you can also tweak them live from the Inspector on the
`Player` and `ObstacleSpawner` nodes.

## Status

Core endless loop is in place: procedural obstacles, scoring, persistent high
score, camera follow, and a countdown → play → game-over → retry cycle. The
signature **heat mechanic** is implemented — flapping heats the banana, gliding
cools it, and overheating is a second failure state — which is what sets Hot
Banana apart from a plain Flappy clone.
