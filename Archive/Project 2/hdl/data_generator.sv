// data_generator.sv
class data_generator;
    rand bit [31:0] random_data;

    // Constraint block to define constraints on random_data
    constraint random_data_constraint {
        // Example constraints: random_data should be within range [0, 100]
        random_data inside {[0:100]};
    }

    // Function to generate random data
    function void generate_random_data();
        // Randomize random_data using constraints
        randomize(random_data) with {random_data_constraint;};
    endfunction
endclass