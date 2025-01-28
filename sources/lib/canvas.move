module sui_place::canvas;

use sui::table_vec::{Self, TableVec};
use sui_place::errors::{invalid_x_coordinate, invalid_y_coordinate};

// === Structs ===

public struct Canvas has store {
    width: u64,
    height: u64,
    rows: TableVec<vector<u32>>,
}

// === Public Functions ===

public fun new(width: u64, height: u64, ctx: &mut TxContext): Canvas {
    Canvas {
        width,
        height,
        rows: initialize_canvas(width, height, ctx),
    }
}

public fun set_pixel(canvas: &mut Canvas, x: u64, y: u64, rgb: u32) {
    assert!(x < canvas.width, invalid_x_coordinate!());
    assert!(y < canvas.height, invalid_y_coordinate!());

    let row = canvas.rows.borrow_mut(y);
    let pixel = row.borrow_mut(x);

    *pixel = rgb;
}

// === View Functions ===

public fun get_pixel(canvas: &Canvas, x: u64, y: u64): u32 {
    let row = canvas.rows.borrow(y);
    let pixel = row.borrow(x);

    *pixel
}

// === Private Functions ===

fun initialize_canvas(
    width: u64,
    height: u64,
    ctx: &mut TxContext,
): TableVec<vector<u32>> {
    let mut rows = table_vec::empty(ctx);
    let mut row_index = 0;

    while (row_index < height) {
        let mut row = vector::empty();

        let mut col_index = 0;

        while (col_index < width) {
            row.push_back(0x000000);
            col_index = col_index + 1;
        };

        rows.push_back(row);
        row_index = row_index + 1;
    };

    rows
}
