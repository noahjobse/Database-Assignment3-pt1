-- This script processes transactions from the NEW_TRANSACTIONS table.
-- It retrieves unique transaction details and inserts them into TRANSACTION_HISTORY.

DECLARE
    -- Variables to store transaction details
    v_transaction_no      NEW_TRANSACTIONS.Transaction_no%TYPE;
    v_transaction_date    NEW_TRANSACTIONS.Transaction_date%TYPE;
    v_description         NEW_TRANSACTIONS.Description%TYPE;

-- Cursor to fetch unique transactions (one per Transaction_no)
CURSOR cur_transactions IS
    SELECT Transaction_no, Transaction_date, Description
    FROM NEW_TRANSACTIONS
    GROUP BY Transaction_no, Transaction_date, Description;

BEGIN
    -- Start processing transactions using a FOR LOOP
    FOR rec IN cur_transactions LOOP
        v_transaction_no := rec.Transaction_no;
        v_transaction_date := rec.Transaction_date;
        v_description := rec.Description;

        -- Debugging
        DBMS_OUTPUT.PUT_LINE('Processing Transaction No: ' || v_transaction_no);

        INSERT INTO TRANSACTION_HISTORY (Transaction_no, Transaction_date, Description)
        VALUES (v_transaction_no, v_transaction_date, v_description);

        -- Debugging
        DBMS_OUTPUT.PUT_LINE('Inserted Transaction No: ' || v_transaction_no || ' into TRANSACTION_HISTORY.');
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('All transactions processed and committed successfully.');
END;
/
