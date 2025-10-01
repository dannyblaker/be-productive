gunzip -c backup.sql.gz | PGPASSWORD="your_password" psql -U your_username -d your_database
