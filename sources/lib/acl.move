module sui_place::acl;

// === Structs ===

public struct Admin has key {
    id: UID,
}

// === Init Functions ===

fun init(ctx: &mut TxContext) {
    transfer::transfer(
        Admin {
            id: object::new(ctx),
        },
        ctx.sender(),
    )
}
