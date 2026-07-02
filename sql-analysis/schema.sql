create table trials(
   trial_id varchar(20) primary key,
   completion_date date,
   year int,
   sponsor varchar(100),
   therapy_area varchar(100),
   phase varchar(20),
   enrollment_n int,
   duration_months int,
   outcome varchar(100),
   is_success tinyint,
   is_failure tinyint,
   estimated_stock_impact_pct decimal(5,2),
  
 );  
