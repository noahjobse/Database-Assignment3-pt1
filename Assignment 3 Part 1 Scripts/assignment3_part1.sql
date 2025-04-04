SET SERVEROUTPUT ON;

DECLARE
    CURSOR transaction_cursor IS
    SELECT
        transaction_no,
        transaction_date,
        description
    FROM
        new_transactions
    GROUP BY
        transaction_no,
        transaction_date,
        description
    ORDER BY
        transaction_no;

    CURSOR detail_cursor (
        current_trans_no new_transactions.transaction_no%TYPE
    ) IS
    SELECT
        account_no,
        transaction_type,
        transaction_amount
    FROM
        new_transactions
    WHERE
        transaction_no = current_trans_no;

    trans_number      new_transactions.transaction_no%TYPE;
    trans_date        new_transactions.transaction_date%TYPE;
    trans_description new_transactions.description%TYPE;
    acct_number       new_transactions.account_no%TYPE;
    entry_type        new_transactions.transaction_type%TYPE;
    entry_amount      new_transactions.transaction_amount%TYPE;
    default_type      account_type.default_trans_type%TYPE;
BEGIN
    FOR transaction_record IN transaction_cursor LOOP
        trans_number := transaction_record.transaction_no;
        trans_date := transaction_record.transaction_date;
        trans_description := transaction_record.description;
        INSERT INTO transaction_history (
            transaction_no,
            transaction_date,
            description
        ) VALUES (
            trans_number,
            trans_date,
            trans_description
        );

        FOR detail_record IN detail_cursor(trans_number) LOOP
            acct_number := detail_record.account_no;
            entry_type := detail_record.transaction_type;
            entry_amount := detail_record.transaction_amount;
            INSERT INTO transaction_detail (
                transaction_no,
                account_no,
                transaction_type,
                transaction_amount
            ) VALUES (
                trans_number,
                acct_number,
                entry_type,
                entry_amount
            );

            SELECT
                at.default_trans_type
            INTO default_type
            FROM
                     account a
                JOIN account_type at ON a.account_type_code = at.account_type_code
            WHERE
                a.account_no = acct_number;

            IF default_type = 'D' THEN
                IF entry_type = 'D' THEN
                    UPDATE account
                    SET
                        account_balance = account_balance + entry_amount
                    WHERE
                        account_no = acct_number;

                ELSE
                    UPDATE account
                    SET
                        account_balance = account_balance - entry_amount
                    WHERE
                        account_no = acct_number;

                END IF;
            ELSE
                IF entry_type = 'D' THEN
                    UPDATE account
                    SET
                        account_balance = account_balance - entry_amount
                    WHERE
                        account_no = acct_number;

                ELSE
                    UPDATE account
                    SET
                        account_balance = account_balance + entry_amount
                    WHERE
                        account_no = acct_number;

                END IF;
            END IF;

            dbms_output.put_line('Account '
                                 || acct_number
                                 || ' updated for transaction '
                                 || trans_number);
        END LOOP;

        DELETE FROM new_transactions
        WHERE
            transaction_no = trans_number;

    END LOOP;

    COMMIT;
END;
/
