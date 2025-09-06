function load_chemical_data(filename)
    data = Dict{String, Tuple{Float64, Vector{Float64}}}()
    current_name = ""
    current_temp = 0.0
    coefficients = Float64[]

    lines = readlines(filename)

    for line in lines
        line_stripped = strip(line)
        if line_stripped == ""  # Skip empty lines
            continue
        end

        number_pattern = r"[-+]?(\d+\.\d*|\.\d+)([eE][-+]?\d+)?|[-+]?\d+"
        matches = collect(eachmatch(number_pattern, line_stripped))
        if length(matches) > 0
            nums = [parse(Float64, match.match) for match in matches]

            # Determine the type of line based on the last character
            last_number = endswith(line_stripped, "1") ? 1 :
                         endswith(line_stripped, "2") ? 2 :
                         endswith(line_stripped, "3") ? 3 :
                         endswith(line_stripped, "4") ? 4 : nothing

            if last_number == 1
                # Split the line into parts based on whitespace
                parts = split(line_stripped)
                # The first part is the chemical name
                if length(parts) > 0
                    current_name = parts[1]
                    # The temperature is the penultimate part before '1'
                    temp_str = parts[end - 1]
                    current_temp = parse(Float64, temp_str)
                    coefficients = Float64[]
                end
            elseif last_number ∈ (2, 3, 4)
                # These lines contain coefficients
                append!(coefficients, nums[1:end-1])
                if last_number == 4
                    data[current_name] = (current_temp, coefficients)
                    current_name = ""
                    current_temp = 0.0
                    coefficients = Float64[]
                end
            end
        end
    end

    return data
end

function species_cp(T, data_for_a_species)
    R_cal = 1.98720425864083
    cal_to_J = 4.184
    
    T_common, coeffs = data_for_a_species
    # Select the appropriate set of coefficients based on T
    if T >= T_common
        a = coeffs[1:7]    # High-temperature coefficients: a1 to a7
    else
        a = coeffs[8:14]   # Low-temperature coefficients: a8 to a14
    end
    # NASA polynomial for Cp/R
    Cp_R = a[1] + a[2]*T + a[3]*T^2 + a[4]*T^3 + a[5]*T^4
    # Convert to Cp in J/(mol·K)
    Cp_cal = Cp_R * R_cal
    Cp = Cp_cal * cal_to_J
    return Cp # J/mol/K
end

function h0(T, data_for_a_species)
    R_cal = 1.98720425864083
    cal_to_J = 4.184
    
    T_common, coeffs = data_for_a_species
    # Select the appropriate set of coefficients based on T
    if T >= T_common
        a = coeffs[1:7]    # High-temperature coefficients: a1 to a7
    else
        a = coeffs[8:14]   # Low-temperature coefficients: a8 to a14
    end
    # NASA polynomial for (H/RT)
    H_RT = a[1] + a[2]*T/2 + a[3]*(T^2)/3 + a[4]*(T^3)/4 + a[5]*(T^4)/5 + a[6]/T
    # Convert to H in cal/mole
    H_cal = H_RT * R_cal * T
    H = H_cal * cal_to_J
    return H # J/mol
end
