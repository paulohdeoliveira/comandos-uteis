SELECT c.session_id, c.host_name, c.client_interface_name, e.encrypt_option 

FROM sys.dm_exec_connections e 

JOIN sys.dm_exec_sessions c ON c.session_id = e.session_id
