struct Location {
    x : u32,
    y : u32,
}

struct Player {
    id : u32,
    location : Location,
}

struct Tile {
    id: u32,
    isObstacle: bool,
}

struct Game {
    state : u32,
    challenger : Player,
    defender: Player,
    board : [u32; 100],
    tiles : [Tile; 2],
}

struct Action {
    isChallenger : bool,
    isMove : bool, // true = move, false = skill
    location : Location,
}

fn main(game : pub Game, action : pub Action) -> pub Game {
    validate_players_locations(game);
    // return new game state
    apply_action(game, action)
}

fn apply_action(game : Game, action : Action) -> Game {
    let mut new_game = game;

    if action.isMove {
        if (action.isChallenger) {
            check_move_validity(game, action, new_game.challenger);
            new_game.challenger.location = action.location;
        } else {
            check_move_validity(game, action, new_game.defender);
            new_game.defender.location = action.location;
        }
    }
    new_game
}

fn check_move_validity(game : Game, action : Action, player: Player) {

    // Check if move location is in the bound of the board
    assert((action.location.x >= 0) & (action.location.x < 10));
    assert((action.location.y >= 0) & (action.location.y < 10));

    // Check if move location is adjacent to player
    assert(((action.location.x - player.location.x) <= 1) | ((player.location.x - action.location.x) <= 1));
    assert(((action.location.y - player.location.y) <= 1) | ((player.location.y - action.location.y) <= 1));

    // Check if move location is not an obstacle
    check_if_tile_is_not_an_obsticle(game, action.location);
}

fn check_if_tile_is_not_an_obsticle (game: Game, location: Location) {
    let tile_id = game.board[location.x + location.y * 10];
    for i in 0..game.tiles.len() {
        let tile = game.tiles[i];
        if tile.id == tile_id {
            assert(tile.isObstacle == false);
        }
    }

}

fn validate_players_locations(game : Game) {
    check_if_tile_is_not_an_obsticle(game, game.challenger.location);
    check_if_tile_is_not_an_obsticle(game, game.defender.location);
}

#[test]
fn test_main() {
    let empty : Tile = Tile { id: 0, isObstacle: false };
    let wall : Tile = Tile { id: 1, isObstacle: true };

    let alice : Player = Player { id: 0, location: Location { x: 1, y: 1 } };
    let bob : Player = Player { id: 1, location: Location { x: 8, y: 8 } };

    let board : [u32; 100] = [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 1, 1, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ];

    let game : Game = Game { 
        state: 0, 
        challenger: alice, 
        defender: bob, 
        board: board, 
        tiles: [empty, wall] 
    };

    let action : Action = Action { 
        isChallenger: true, 
        isMove: true, 
        location: Location { x: 0, y: 0 } 
    };

    let new_game = main(game, action);

    assert(new_game.challenger.location.x == 0);
    assert(new_game.challenger.location.y == 0);

}


#[test(should_fail)]
fn test_main_failing() {
    let empty : Tile = Tile { id: 0, isObstacle: false };
    let wall : Tile = Tile { id: 1, isObstacle: true };

    let alice : Player = Player { id: 0, location: Location { x: 1, y: 1 } };
    let bob : Player = Player { id: 1, location: Location { x: 8, y: 8 } };

    let board : [u32; 100] = [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 1, 1, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ];

    let game : Game = Game { 
        state: 0, 
        challenger: alice, 
        defender: bob, 
        board: board, 
        tiles: [empty, wall] 
    };

    let action : Action = Action { 
        isChallenger: true, 
        isMove: true, 
        location: Location { x: 5, y: 5 } 
    };

    let new_game = main(game, action);

    assert(new_game.challenger.location.x == 5);
    assert(new_game.challenger.location.y == 5);

}