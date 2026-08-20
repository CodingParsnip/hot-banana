# Hot Banana — Design Direction

> **A living document.** This is a north star, not a contract. Expect phases,
> features, and even the core framing to change as things get playtested. When
> a decision here turns out wrong in practice, change the game *and* update this
> doc.

---

## Vision in one line

**You're a banana that's dangerously hot — and controlled overheating is your power source.**

Hot Banana keeps Flappy Bird's twitchy, one-button *moment-to-moment* feel, but
grows a **heat-management roguelike** around it. The heat meter isn't a "don't
die" gauge; it's a resource you deliberately push and pull to survive and to
unleash power.

## The core pillar: heat is the whole game

Every system should push or pull on the player's temperature. If a feature
doesn't interact with heat, question whether it belongs.

- **Flapping** heats you up; **gliding/falling** cools you down. *(built)*
- **Items** are your throttle: 🌶️ heat up, 🧊 cool down.
- **Overheating** is a gamble, not just death — ride the red zone to charge a
  **Blaze** you can spend on a burst of power.
- **Obstacles & enemies** push your heat around (fire pipes heat, ice caves cool),
  so the environment constantly forces heat decisions.
- **Bosses** are heat *puzzles* (e.g. only vulnerable while you're Blazing).
- **Roguelike builds** are *how you've tuned your relationship with heat* — perks
  that reward running hot, or that let you dump heat for a shield.

## Flappy → roguelike bridge

Keep the **twitch layer** exactly as it is — one button, skill-based, unforgiving.
Change only the **structure around it**:

- Endless run → a sequence of short, **themed biomes**, each ending in a **boss**.
- **Upgrade picks between biomes** build your run.
- **Permadeath** ends a run; **persistent unlocks** carry across runs.

The skill test stays; a roguelike grows around it.

---

## Development pathway

Each phase is independently playable and sets up the next. Ship and playtest one
before starting the next.

| Phase | Goal | Why it's here |
|---|---|---|
| **0 — Foundation** ✅ | Core loop, heat mechanic, menus, readable static camera. | Done — see "Current state." |
| **1 — Make heat *bite*** | The **Blaze** mechanic: near-max heat charges a spendable burst; overheating is the risk. | Smallest change, biggest payoff. Defines the game's identity before content is built on it. Directly fixes "overheat doesn't matter yet." |
| **2 — Items & heat economy** | 🌶️/🧊 pickups in the gaps; grabbing them is a heat trade-off. Score coins. | Cheap risk/reward routing layer on top of Phase 1's stakes. |
| **3 — Obstacle & enemy variety** | Fire pipes (heat), ice pipes (cool), moving/narrow gaps; 1–2 simple enemies. | Content variety — every hazard ties back to heat. |
| **4 — Biomes & bosses** | Endless → finite themed segments, each ending in a boss heat-puzzle. | The big structural shift; needs Phases 1–3 as its vocabulary. |
| **5 — Roguelike meta** | Run = biome sequence; pick a perk/mutation between biomes; permadeath; persistent unlocks; hub screen. | Becomes a roguelike once there's content to build runs from. |

### Phase detail

**Phase 1 — Blaze (the hook).**
Turn overheat from pure death into risk/reward. Sketch: holding above ~80% heat
charges a Blaze meter; at 100% you either burst (death) or, timed right, release
a **Blaze Dash** — a brief invulnerable burst that clears a gap / melts a hazard.
Sell it with feedback: the screen warms and reddens, an audio cue, the banana
glows. No new content required — this is a mechanics + game-feel pass.

**Phase 2 — Items & heat economy.**
Pickups float in the pipe gaps. 🌶️ chili = instant heat + a short speed/score
multiplier (risky but rewarding); 🧊 ice = cool down (safe reset). Optional score
coins. The player now makes constant heat trades and routing choices.

**Phase 3 — Obstacle & enemy variety.**
Obstacle variants with heat identity: fire pipes that heat you as you pass, ice
pipes that cool you, moving pipes, narrow gaps. 1–2 simple enemies (a diving bird,
a bee) to add dodging. Prefer hazards that interact with heat.

**Phase 4 — Biomes & bosses.**
Replace endless generation with finite, themed segments — e.g. Orchard (tutorial)
→ Desert (passively heats you; cooling is scarce) → Ice Caves (cools you; you must
generate heat) → Volcano (boss). Each biome ~30–60s, ends in a boss. Bosses are
heat puzzles (e.g. only damageable while Blazing). Needs: a level/biome definition
system, per-biome theming (palette/background/hazard set), a win condition, and a
boss-fight framework.

**Phase 5 — Roguelike meta.**
A run is a sequence of biomes. Between biomes, choose one **heat perk / banana
mutation** (run hot for power, vent heat for shields, etc.). Death ends the run;
unlocks persist. Add a hub/run-select screen.

---

## Open questions (lock these early — they ripple through everything)

1. **Control model.** Stays strictly one-button, or does Blaze/dash need a
   **second input** (e.g. a "vent heat" button)? Changes the whole feel.
2. **Is heat the *only* health?** Roguelikes usually pair a resource with HP.
   Adding **hearts** (a hit costs a heart, not instant death) makes builds and
   bosses far more forgiving and designable — but softens the flappy tension.
   Big call.
3. **Run length & saves.** How long is one full run (3 biomes? 6?), and what
   persists between runs? Sets the scope of Phase 5.

*Current lean:* start Phase 1 regardless of these, since it's the identity and
doesn't depend on them.

---

## Current state (Phase 0 — built)

Godot **4.7** project. The playable core loop is in place:

- **Flap-to-fly** with gravity ([`player.gd`](player.gd)); one button
  (`Space`/`Up`/click).
- **Heat mechanic** ([`player.gd`](player.gd), [`main.gd`](main.gd)): flapping
  heats, gliding cools, overheating is a second death state; HUD heat bar recolors
  green→red and the banana tints with heat.
- **Procedural endless obstacles** ([`spawner.gd`](spawner.gd)) with tunable
  spacing/gap/spawn distances.
- **Scoring + persistent high score** (`user://highscore.save`).
- **Static, readable camera** ([`game_camera.gd`](game_camera.gd)): 1.2× zoom,
  fixed vertical frame with the floor pinned to the bottom, follows horizontally.
- **Menus in screen-space CanvasLayers**: start screen, "Hot banana! Game over."
  end-screen (Play again / Main menu), and an **ESC pause menu**
  ([`pause_menu.gd`](pause_menu.gd)) with a 3-2-1 resume, restart, and main-menu.
- **Group-based collision** (`obstacles` / `floor`).

Most feel knobs are exported on the `Player`, `ObstacleSpawner`, and `GameCamera`
nodes for live tuning in the editor.
