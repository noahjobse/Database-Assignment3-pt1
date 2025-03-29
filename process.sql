-- This script processes transactions from the NEW_TRANSACTIONS table.
-- It retrieves transaction details and prints them to the console.

DECLARE
    -- Variables to store transaction details
    v_transaction_no      NEW_TRANSACTIONS.Transaction_no%TYPE;
    v_transaction_date    NEW_TRANSACTIONS.Transaction_date%TYPE;
    v_description         NEW_TRANSACTIONS.Description%TYPE;
    v_account_no          NEW_TRANSACTIONS.Account_no%TYPE;
    v_transaction_type    NEW_TRANSACTIONS.Transaction_type%TYPE;
    v_transaction_amount  NEW_TRANSACTIONS.Transaction_amount%TYPE;

-- Cursor to fetch data from the table
CURSOR cur_transactions IS
    SELECT Transaction_no, Transaction_date, Description, Account_no, Transaction_type, Transaction_amount
    FROM NEW_TRANSACTIONS;

BEGIN
    -- Start processing transactions using a FOR LOOP
    FOR rec IN cur_transactions LOOP
        -- Assign values from the current row to variables
        v_transaction_no := rec.Transaction_no;
        v_transaction_date := rec.Transaction_date;
        v_description := rec.Description;
        v_account_no := rec.Account_no;
        v_transaction_type := rec.Transaction_type;
        v_transaction_amount := rec.Transaction_amount;

        -- Print details (for debugging)
        DBMS_OUTPUT.PUT_LINE('Processing Transaction No: ' || v_transaction_no);
        DBMS_OUTPUT.PUT_LINE('Account No: ' || v_account_no || ', Amount: ' || v_transaction_amount || ', Type: ' || v_transaction_type);
    END LOOP;
END;
/