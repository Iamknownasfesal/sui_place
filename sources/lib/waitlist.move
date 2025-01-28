module sui_place::waitlist;

use sui::{clock::Clock, table::{Self, Table}};
use sui_place::errors::wait_time_exceeded;

// === Structs ===

public struct Waitlist has store {
    list: Table<address, u64>,
    wait_time: u64,
}

// === Public Functions ===

public fun new(ctx: &mut TxContext, wait_time: u64): Waitlist {
    Waitlist {
        list: table::new(ctx),
        wait_time,
    }
}

public fun add_to_waitlist(
    waitlist: &mut Waitlist,
    clock: &Clock,
    ctx: &mut TxContext,
) {
    if (!waitlist.list.contains(ctx.sender())) {
        waitlist.list.add(ctx.sender(), clock.timestamp_ms());
        return
    };

    let value = waitlist.list.borrow_mut(ctx.sender());
    assert!(
        clock.timestamp_ms() - *value > waitlist.wait_time,
        wait_time_exceeded!(),
    );
    *value = clock.timestamp_ms();
}
