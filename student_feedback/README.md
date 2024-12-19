1. find the .env file and update all it's content according to your needs 
    if you can't find the .env file create a .env file and assign these variables 

    ```.env
        SUPABASE_API_URL=YOUR_SUPABASE_API_URL
        SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
        SMTP_SERVER=YOUR_SMTP_SERVER
        SMTP_PORT=YOUR_SMTP_SERVER_PORT
        SMTP_USER=YOUR_SMTP_EMAIL_OR_USERNAME
        MAIL_APP_PASSWORD=YOUR_SMTP_APP_PASSWORD
    ```

2. create all the tables in the supabase database and then run this sql query

    ```sql

    CREATE OR REPLACE FUNCTION delete_expired_otps()
    RETURNS TRIGGER AS $$
    BEGIN
    DELETE FROM users WHERE otp IS NOT NULL AND otp_expiry <= NOW();
    RETURN NULL;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER otp_cleanup
    AFTER INSERT OR UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION delete_expired_otps();

    ```

3. run flutter pub get to get all the dependencies

4. run the application using the built in debugger or run ```curl flutter run ``` or ```curl flutter run -v ```

    tip : the -v flag lets you view all the details.

