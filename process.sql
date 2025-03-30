-- This script moves transactions from NEW_TRANSACTIONS to TRANSACTION_HISTORY and TRANSACTION_DETAIL.

DECLARE
    -- Variables for transaction-level data
    v_transaction_no      NEW_TRANSACTIONS.Transaction_no%TYPE;
    v_transaction_date    NEW_TRANSACTIONS.Transaction_date%TYPE;
    v_description         NEW_TRANSACTIONS.Description%TYPE;

    -- Variables for account-level data
    v_account_no          NEW_TRANSACTIONS.Account_no%TYPE;
    v_transaction_type    NEW_TRANSACTIONS.Transaction_type%TYPE;
    v_transaction_amount  NEW_TRANSACTIONS.Transaction_amount%TYPE;

    -- Cursor to select unique transactions for TRANSACTION_HISTORY
    CURSOR cur_transactions IS
        SELECT DISTINCT Transaction_no, Transaction_date, Description
        FROM NEW_TRANSACTIONS;

    -- Cursor to select account-level data for TRANSACTION_DETAIL
    CURSOR cur_transaction_rows (p_transaction_no NEW_TRANSACTIONS.Transaction_no%TYPE) IS
        SELECT Account_no, Transaction_type, Transaction_amount
        FROM NEW_TRANSACTIONS
        WHERE Transaction_no = p_transaction_no;

BEGIN
    -- Process each transaction using outer cursor
    FOR rec IN cur_transactions LOOP
        v_transaction_no := rec.Transaction_no;
        v_transaction_date := rec.Transaction_date;
        v_description := rec.Description;

        -- Insert into TRANSACTION_HISTORY
        INSERT INTO TRANSACTION_HISTORY (Transaction_no, Transaction_date, Description)
        VALUES (v_transaction_no, v_transaction_date, v_description);

        DBMS_OUTPUT.PUT_LINE('Inserted into TRANSACTION_HISTORY: Transaction No ' || v_transaction_no);

        -- Process account-level data using inner cursor
        FOR row_rec IN cur_transaction_rows(v_transaction_no) LOOP
            v_account_no := row_rec.Account_no;
            v_transaction_type := row_rec.Transaction_type;
            v_transaction_amount := row_rec.Transaction_amount;

            -- Insert into TRANSACTION_DETAIL
            INSERT INTO TRANSACTION_DETAIL (Transaction_no, Account_no, Transaction_type, Transaction_amount)
            VALUES (v_transaction_no, v_account_no, v_transaction_type, v_transaction_amount);

            DBMS_OUTPUT.PUT_LINE('Inserted into TRANSACTION_DETAIL: Account No ' || v_account_no ||
                                  ', Type: ' || v_transaction_type ||
                                  ', Amount: ' || v_transaction_amount);
        END LOOP;
    END LOOP;

    -- Commit changes to finalize inserts
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('All transactions processed and committed successfully.');
END;
/
