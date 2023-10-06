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
    players : [Player; 2],
    board : [u32; 100],
    tiles : [Tile; 2],
}

struct Action {
    player_id : u32,
    isMove : bool, // true = move, false = skill
    location : Location,
}

fn main(game : pub Game, action : pub Action) -> pub Game {
    validate_players_locations(game);
    apply_action(game, action)
}

fn apply_action(game : Game, action : Action) -> Game {
    let mut new_game = game;
    if action.isMove {
        check_move_validity(game, action);
        new_game.players[action.player_id].location = action.location;
    }
    new_game
}

fn check_move_validity(game : Game, action : Action) {
    let player = game.players[action.player_id];
    let tile_index = game.board[action.location.x + action.location.y * 10];
    let tile = game.tiles[tile_index];
    assert(tile.isObstacle == false);
    assert((action.location.x >= 0) & (action.location.x < 10));
    assert((action.location.y >= 0) & (action.location.y < 10));
    assert(((action.location.x - player.location.x) <= 1) | ((player.location.x - action.location.x) <= 1));
    assert(((action.location.y - player.location.y) <= 1) | ((player.location.y - action.location.y) <= 1));
}



fn validate_players_locations(game : Game) {
    for i in 0..2 {
        let player = game.players[i];
        let tile_index = game.board[player.location.x + player.location.y * 10];
        let tile = game.tiles[tile_index];
        assert(tile.isObstacle == false);
    }
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
        players: [alice, bob], 
        board: board, 
        tiles: [empty, wall] 
    };

    let action : Action = Action { 
        player_id: 0, 
        isMove: true, 
        location: Location { x: 0, y: 0 } 
    };

    let new_game = main(game, action);

    assert(new_game.players[0].location.x == 0);
    assert(new_game.players[0].location.y == 0);

}


#[test(should_fail)]
fn test_main_fail() {
    let empty : Tile = Tile { id: 0, isObstacle: false };
    let wall : Tile = Tile { id: 1, isObstacle: true };

    let alice : Player = Player { id: 0, location: Location { x: 1, y: 1 } };
    let bob : Player = Player { id: 1, location: Location { x: 8, y: 8 } };

    let board : [u32; 100] = [
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
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
        players: [alice, bob], 
        board: board, 
        tiles: [empty, wall] 
    };

    let action : Action = Action { 
        player_id: 0, 
        isMove: true, 
        location: Location { x: 4, y: 4 } 
    };

    let new_game = main(game, action);

    assert(new_game.players[0].location.x == 4);
    assert(new_game.players[0].location.y == 4);

}