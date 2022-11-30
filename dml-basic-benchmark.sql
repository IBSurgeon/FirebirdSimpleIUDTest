create database "localhost:d:\temp\inserttest4.fdb" user "SYSDBA" password "megalink" page_size 16384;

set term ^;
execute block as
begin
    -- ######################################################
    rdb$set_context('USER_SESSION', 'ROWS_TO_HANDLE', 1000000);
    -- ######################################################
    execute statement 'drop sequence g';
when any do 
    begin 
    end
end
^
set term ;^
commit;

create sequence g;

recreate table test(
     id int
    ,grp smallint
    ,pid int
    ,dts timestamp
    ,code_sml varchar(15)
    ,code_med varchar(150)
    ,code_lrg varchar(1500)
    ,code_unq char(16) character set octets
    ,constraint test_pk primary key(id)
    ,constraint test_unq unique( code_unq )
);

create index test_pid on test(pid);
create descending index test_dts on test(dts);
create index test_dml on test(code_sml);
create index test_med on test(code_med);
create index test_lrg on test(code_lrg);
commit;
----------------------------------------------

set bail on;
set list on;
set stat on;

set term ^;
execute block returns( inserted_rows int, elap_ms int )
as
    declare i int = 0;
    declare t timestamp;
begin
    inserted_rows = rdb$get_context('USER_SESSION', 'ROWS_TO_HANDLE');
    t = 'now';
    while ( i < inserted_rows ) do
    begin
        insert into test(id, grp, pid, dts, code_sml, code_med, code_lrg, code_unq)
        values(
             gen_id(g,1)
            ,rand() * 10
            ,rand() * 1000
            ,dateadd( rand()*1000000 second to timestamp '01.01.2019 00:00:00' )
            ,lpad('', 15, 'QWERTY' )
            ,lpad('', 150, 'QWERTY' )
            ,lpad('', 1500, 'QWERTY' )
            ,gen_uuid()
        );
        i = i + 1;
    end
    elap_ms = datediff(millisecond from t to cast('now' as timestamp));
    suspend;
end
^
commit^
-----------------------------------------------

execute block returns( updated_rows int, elap_ms int )
as
    declare i int = 0;
    declare t timestamp;
begin
    updated_rows = rdb$get_context('USER_SESSION', 'ROWS_TO_HANDLE');
    t = 'now';
    while ( i < updated_rows ) do
    begin
        update test set 
            grp = rand() * 10
           ,pid = rand() * 1000
           ,dts = dateadd( rand()*100000 second to timestamp '01.01.2019 00:00:00'  )
           ,code_sml = lpad('', 15, 'ASDFGH' )
           ,code_med = lpad('', 150, 'ASDFGH' )
           ,code_lrg = lpad('', 1500, 'ASDFGH' )
           ,code_unq = gen_uuid()
        where id = :i+1 ;
        i = i + 1;
    end
    elap_ms = datediff(millisecond from t to cast('now' as timestamp));
    suspend;
end
^

commit^
-----------------------------------------------

execute block returns( deleted_rows int, elap_ms int )
as
    declare i int = 0;
    declare t timestamp;
begin
    deleted_rows = rdb$get_context('USER_SESSION', 'ROWS_TO_HANDLE');
    t = 'now';
    while ( i < deleted_rows ) do
    begin
        delete from test where id = :i+1 ;
        i = i + 1;
    end
    elap_ms = datediff(millisecond from t to cast('now' as timestamp));
    suspend;
end
^

set term ;^
commit;