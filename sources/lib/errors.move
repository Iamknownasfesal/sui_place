module sui_place::errors;

// === Errors ===

public(package) macro fun wait_time_exceeded(): u64 {
    1
}

public(package) macro fun invalid_x_coordinate(): u64 {
    2
}

public(package) macro fun invalid_y_coordinate(): u64 {
    3
}
