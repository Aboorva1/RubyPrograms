$order = 0
$available_denominations = []
$details_of_orders = []
$storing_denominations = {}
$initial_denominations = {
    '2000' => 10, 
    '500' => 10, 
    '200' => 10, 
    '100' => 5, 
    '50' => 1, 
    '20' => 10, 
    '10c' => 10, 
    '5c' => 0,
    '2c' => 0,
    '1c' => 0, 
    '10' => 10, 
    '5' => 2, 
    '1' => 0}

def initial_cashbox_amount
    cash = [2000,500,200,100,50,20,10,5,2,1,10,5,1] 
    total_cashbox_amount = 0
    index = 0
    $initial_denominations.each do |denomination, count|
        total_cashbox_amount += (cash[index] * count)
        index += 1
    end
    return total_cashbox_amount
end

def calculate_cashbox_amount
    cash = [2000,500,200,100,50,20,10,5,2,1,10,5,1] 
    total_cashbox_amount = 0
    index = 0
    $storing_denominations.each do |denomination, count|
        total_cashbox_amount += (cash[index] * count)
        index += 1
    end
    return total_cashbox_amount
end


def get_denominations(given_amount)
    puts "Enter denominations : "
    denomination_given = gets.chomp
    total_amount = denomination_given.to_i
    $storing_denominations = $initial_denominations
    while total_amount < given_amount
        $storing_denominations[denomination_given.to_s] += 1
        denomination_given = gets.chomp
        total_amount += denomination_given.to_i
    end
    $storing_denominations[denomination_given.to_s] += 1 
    $initial_denominations = $storing_denominations  ######
end


def check_insufficiency(balance_amount, updated_denominations, denomination_to_customer)
    if (balance_amount > 0 && balance_amount < 10)
        puts "There is no sufficient denominations. Would you like to take a chocolate for #{balance_amount} : Y/N"
        chocolate = gets.chomp
        if chocolate == "Y"
            $details_of_orders << denomination_to_customer
            calculate_cashbox_amount + balance_amount
            return updated_denominations
        else
            puts "Order cancelled"
            $details_of_orders.pop
            return $initial_denominations   #.difference(updated_denominations)  
        end    
    end
end


def balance_to_be_given(balance_amount, given_amount, bill_amount)
    new_order = []
    new_order << $order << bill_amount << given_amount << balance_amount 
    $details_of_orders << new_order
    denomination_to_customer = {}
    index = 0
    updated_denominations = $storing_denominations
    if given_amount >= bill_amount
        while index < $available_denominations.length 
            if (($available_denominations[index]).include?("c"))
                denomination = $available_denominations[index]
            else
                denomination = ($available_denominations[index]).to_i
            end
            while balance_amount >= denomination.to_i
                value = balance_amount/denomination.to_i
                if value <= updated_denominations[denomination.to_s]
                    denomination_to_customer[denomination.to_s] = balance_amount/(denomination.to_i)
                    updated_denominations[denomination.to_s] -= balance_amount/(denomination.to_i)
                    balance_amount = balance_amount % (denomination.to_i)
                else
                    denomination_to_customer[denomination.to_s] = updated_denominations[denomination.to_s]
                    balance_amount = balance_amount - ((denomination.to_i) * (denomination_to_customer[denomination.to_s]))
                    updated_denominations[denomination.to_s] -= updated_denominations[denomination.to_s]
                    break
                end
            end
            index += 1
            if balance_amount == 0
                $details_of_orders << denomination_to_customer
                break 
            end
        end
        if balance_amount == 0
            $storing_denominations = updated_denominations
        else
            $storing_denominations = check_insufficiency(balance_amount,updated_denominations, denomination_to_customer) 
        end   
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
    get_denominations(given_amount)
    $initial_denominations.each do |denomination, count|
        if count != 0
            $available_denominations << denomination.to_s
        end
    end
    balance_amount = given_amount - bill_amount
    balance_to_be_given(balance_amount, given_amount, bill_amount)   
end

def display_details
    puts "Denominations available : ", $storing_denominations
    if $details_of_orders.empty?()
        puts "No details available"
    else
        puts "Order no        Bill amount       Given amount        Balance amount        Balance denomination"
        for detail in $details_of_orders
            print detail
        end
        puts 
    end
    puts "Amount in cashbox:", calculate_cashbox_amount
end
      

while true
    puts "Hi! Welcome..."
    puts "Do you want to purchase: Y/N   //  Display details: D  "
    purchase = gets.chomp
    puts "Initial cashbox amount: ", initial_cashbox_amount
    if purchase == 'Y'
        if initial_cashbox_amount != 0
            create_order
        else
            puts "Cashbox empty! Add amount to cashbox"
        end
    elsif purchase == 'D'
        display_details
    else
        break
    end
end

      

    
    





    
