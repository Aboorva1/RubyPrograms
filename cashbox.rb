$order = 0
$available_denominations = []
$order_details = []
$denominations_after_order_placed = {}
$denomination_when_order_cancelled = {}
$initial_denominations = {
    '2000' => 10, 
    '500' => 10, 
    '200' => 10, 
    '100' => 0, 
    '50' => 1, 
    '20' => 2, 
    '10c' => 1, 
    '5c' => 0,
    '2c' => 0,
    '1c' => 0, 
    '10' => 10, 
    '5' => 0, 
    '1' => 0}

def calculate_cashbox_amount
    cash = [2000,500,200,100,50,20,10,5,2,1,10,5,1] 
    total_cashbox_amount = 0
    denomination_index = 0
    $initial_denominations.each do |denomination, count|
        total_cashbox_amount += (cash[denomination_index] * count)
        denomination_index += 1
    end
    return total_cashbox_amount
end

def get_denominations_from_customer(given_amount)
    puts "Enter denominations : "
    denomination_given = gets.chomp
    total_amount = denomination_given.to_i
    $denominations_after_order_placed = $initial_denominations
    while total_amount < given_amount
        $denominations_after_order_placed[denomination_given.to_s] += 1
        denomination_given = gets.chomp
        total_amount += denomination_given.to_i
    end
    $denominations_after_order_placed[denomination_given.to_s] += 1 
    $initial_denominations = $denominations_after_order_placed  
end

def chocolate_for_change(balance_amount, denominations_after_balance_given, denomination_to_customer)
    if (balance_amount > 0 && balance_amount < 10)
        puts "There is no sufficient denominations. Would you like to take a chocolate for #{balance_amount} : Y/N"
        chocolate = gets.chomp
        if chocolate.casecmp?('y') 
            $order_details << denomination_to_customer
            calculate_cashbox_amount + balance_amount
            return denominations_after_balance_given
        else
            puts "Order cancelled"
            $order_details.pop
            return $denomination_when_order_cancelled   
        end    
    end
end

def check_insufficiency(balance_denomination_array) 
    if balance_denomination_array[0] == 0
        $denominations_after_order_placed = balance_denomination_array[1]
    else
        $denominations_after_order_placed = chocolate_for_change(balance_denomination_array[0], balance_denomination_array[1], balance_denomination_array[3]) 
    end
end

def balance_denomination(balance_amount, denomination, denominations_after_balance_given)
    denomination_to_customer = {}
    while balance_amount >= denomination.to_i
        count_of_denomination = balance_amount/denomination.to_i
        if count_of_denomination <= denominations_after_balance_given[denomination.to_s]
            denomination_to_customer[denomination.to_s] = count_of_denomination
            denominations_after_balance_given[denomination.to_s] -= count_of_denomination
            balance_amount = balance_amount % (denomination.to_i)
        else
            denomination_to_customer[denomination.to_s] = denominations_after_balance_given[denomination.to_s]
            balance_amount = balance_amount - ((denomination.to_i) * (denomination_to_customer[denomination.to_s]))
            denominations_after_balance_given[denomination.to_s] -= denominations_after_balance_given[denomination.to_s]
            break
        end
    end
    return balance_amount, denominations_after_balance_given, denomination_to_customer
end

def balance_to_be_given(balance_amount, given_amount, bill_amount)
    new_order = []
    new_order << $order << bill_amount << given_amount << balance_amount 
    $order_details << new_order
    available_denomination_index = 0
    denominations_after_balance_given = $denominations_after_order_placed
    if given_amount >= bill_amount
        while available_denomination_index < $available_denominations.length 
            if (($available_denominations[available_denomination_index]).include?("c"))
                denomination = $available_denominations[available_denomination_index]
            else
                denomination = ($available_denominations[available_denomination_index]).to_i
            end
            balance_denomination_array = balance_denomination(balance_amount, denomination, denominations_after_balance_given) 
            available_denomination_index += 1
            if balance_denomination_array[0] == 0
                $order_details << balance_denomination_array[2]
                break 
            end
        end
        check_insufficiency(balance_denomination_array)  
    end
end

def create_order
    $order += 1
    puts "Bill of purchased item : "
    bill_amount = gets.chomp.to_i
    puts "Amount given by customer : "
    given_amount = gets.chomp.to_i
    while given_amount < bill_amount
        puts "Give valid amount"
        given_amount = gets.chomp.to_i
    end
    get_denominations_from_customer(given_amount)
    $initial_denominations.each do |denomination, count|
        if count != 0
            $available_denominations << denomination.to_s
        end
    end
    balance_amount = given_amount - bill_amount
    balance_to_be_given(balance_amount, given_amount, bill_amount)   
end

def display_details
    puts "Denominations available : ", $denominations_after_order_placed
    if $order_details.empty?()
        puts "No details available"
    else
        puts "Order no        Bill amount       Given amount        Balance amount       Balance denomination"
        for detail in $order_details
            print detail
        end
        puts 
    end
    puts "Amount in cashbox:", calculate_cashbox_amount
end
      
def main
    while true
        puts "Hi! Welcome..."
        puts "Do you want to purchase: Y/N"
        purchase = gets.chomp
        $denomination_when_order_cancelled = $initial_denominations.clone
        cashbox_amount = calculate_cashbox_amount
        puts "Initial cashbox amount: ", cashbox_amount
        if purchase.casecmp? ("y")
            if cashbox_amount != 0
                create_order
            else
                puts "Cashbox empty! Add amount to cashbox"
            end
        else 
            display_details
        end
    end
end    

main()