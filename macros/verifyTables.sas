/*
 * Verify a table exists and has the expected columns.
 * The first parameter is a space separated list of table names.
 * The second parameter is a space separated list of columns.
 * All the tables are expected to have the same columns.
 *
 * Example call: %verify(cdw.customer, customerid hhid firstname lastname state zipcode);
 *
 * You may have code that assumes a table exists and has certain columns. If it does not
 * you may get strange errors that are hard to interpret. This macro will give you better
 * messages if you run it before your other code.
 */
%macro verifyTables( tableList, expectedColumns );
   %let i = 1;
   %let table = %scan( &TableList, &i, %str( ) );
   %do %while(%length(&table) > 0);
      %if %sysfunc(exist(&table))
      %then %do;
         %let dsid=%sysfunc(open(&table,i));
         %if (&dsid = 0)
         %then %put Error opening &table: %sysfunc(sysmsg());
         %else %do;
            %let any=%sysfunc(attrn(&dsid, ANY));
            %if &any = -1
            %then %put ERROR: &table has no rows or columns.;
            %else %do;
               %if &any = 0
               %then %put WARNING: &table has 0 rows.;
               %let nrows=%sysfunc(attrn(&dsid, NOBS));

               %let problem=N;
               %let c = 1;
               %let column = %scan(&expectedColumns, &c, %str( ));
               %do %while(%length(&column)>0);
                  %let varnum=%sysfunc(varnum(&dsid,&column));
                  %*put &column &varnum;
                  %if &varnum <= 0
                  %then %do;
                     %put Expected column &column in &table but it was not found.;
                     %let problem = Y;
                  %end;
                  %let c = %eval(&c+1);
                  %let column = %scan( &expectedColumns, &c, %str( ) );
               %end;
               %if &problem = N
               %then %put &table exists, has the expected variables and &nrows rows.;
            %end;
         %end;
      %end;
      %else %put &table does not exist.;
      %let i = %eval(&i+1);
      %let table = %scan( &TableList, &i, %str( ) );
   %end;
   %put Done verifying tables.;
%mend;
