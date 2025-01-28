module sui_place::core;

use sui::{balance::{Self, Balance}, clock::Clock, coin::{Self, Coin}, sui::SUI};
use sui_place::{
    acl::Admin,
    canvas::{Self, Canvas},
    constants::{width, height, spam_price, wait_time},
    waitlist::{Self, Waitlist}
};

// === Structs ===
public struct Place has key, store {
    id: UID,
    canvas: Canvas,
    treasury: Balance<SUI>,
    spam_price: u64,
    waitlist: Waitlist,
}

// === Init Functions ===

fun init(ctx: &mut TxContext) {
    transfer::public_share_object(Place {
        id: object::new(ctx),
        canvas: canvas::new(width!(), height!(), ctx),
        treasury: balance::zero(),
        spam_price: spam_price!(),
        waitlist: waitlist::new(ctx, wait_time!()),
    })
}

// === Public Functions ===

public fun set_pixel(
    place: &mut Place,
    x: u64,
    y: u64,
    rgb: u32,
    payment: &mut Coin<SUI>,
    clock: &Clock,
    ctx: &mut TxContext,
) {
    waitlist::add_to_waitlist(&mut place.waitlist, clock, ctx);
    place.treasury.join(payment.split(place.spam_price, ctx).into_balance());
    canvas::set_pixel(&mut place.canvas, x, y, rgb);
}

// === Admin Functions ===

public fun withdraw_treasury(
    _: &Admin,
    place: &mut Place,
    ctx: &mut TxContext,
): Coin<SUI> {
    let value = place.treasury.value();
    coin::take(&mut place.treasury, value, ctx)
}

public fun set_spam_price(_: &Admin, place: &mut Place, price: u64) {
    place.spam_price = price;
}
