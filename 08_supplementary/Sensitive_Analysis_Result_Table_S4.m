clear

table = zeros(4,6);
run('./05-Scripts/Sensitive_Analysis_ISTVF.m')
table(:,1:3) = RE;

clearvars -except table
run('./05-Scripts/Sensitive_Analysis_SIEM.m')
table(:,4:6) = RE;

clearvars -except table

table
